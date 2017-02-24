
--1. Create a derived table that returns the position name as position and count of employees at that
--position. (I know that this can be done as a simple join, but do it in the format 
--of a derived table. There still will be a join in the subquery portion).

Select [Position Name], Count(EmployeeKey) [Employees] from 
(
 Select PositionName [Position Name], EmployeeKey from Position p
 inner join EmployeePosition ep on p.PositionKey = ep.PositionKey
) as Positions
group by [Position Name]



--2. Create a derived table that returns a column HireYear and the count of employees
--who were hired that year. (Same comment as above).

Select [Hire Year], Count(EmployeeKey) [Employees Hired] from 
(
 Select Year(EmployeeHireDate) [Hire Year], EmployeeKey from Employee
) as EmployeeHireYears
group by [Hire Year]


--3. Redo problem 1 as a Common Table Expression (CTE).
with PositionEmployees as 
(
 Select PositionName [Position Name],  EmployeeKey from Position p
 inner join EmployeePosition ep on p.PositionKey = ep.PositionKey
)
Select [Position Name], Count(EmployeeKey) from PositionEmployees
group by [Position Name];

--4. Redo problem 2 as a CTE.
with EmployeeHireYears as 
(
 Select Year(EmployeeHireDate) [Hire Year], EmployeeKey from Employee
)
Select [Hire Year], Count(EmployeeKey) [Employees Hired] 
from EmployeeHireYears group by [Hire Year]


--5. Create a CTE that takes a variable argument called @BusBarn and returns the count of 
--busses grouped by the description of that bus type at a particular Bus barn. Set @BusBarn to 3.

create function fx_BusBarnTypeCount
(@BusBarn int)
returns table 
as 
return 
Select [Bus Type], count(BusKey) [Busses] from 
(
 Select BusKey, BusBarnKey, BusTypeDescription [Bus Type]
 from Bus inner join BusType 
 on Bus.BusTypekey = BusType.BusTypeKey
) as BusTypeNames
 where BusBarnKey = @BusBarn
 group by [Bus Type];

Select * from dbo.fx_BusBarnTypeCount(3);


--6. Create a View of Employees for Human Resources it should contain all 
--the information in the Employee table plus their position and hourly pay rate

create view vw_HumanResources
as 
Select e.EmployeeKey, EmployeeLastName, EmployeeFirstName, EmployeeAddress, 
EmployeeCity, EmployeeZipCode, EmployeePhone, EmployeeEmail, EmployeeHireDate, 
PositionName, EmployeeHourlyPayRate 
from Employee e 
inner join EmployeePosition ep 
on e.EmployeeKey = ep.EmployeeKey 
inner join Position p
on ep.PositionKey = p.PositionKey

Select * from vw_HumanResources;

--7. Alter the view in 6 to bind the schema
alter view vw_HumanResources with schemabinding
as 
Select e.EmployeeKey [Employee Key], EmployeeLastName, EmployeeFirstName, EmployeeAddress, 
EmployeeCity, EmployeeZipCode, EmployeePhone, EmployeeEmail, EmployeeHireDate, 
PositionName, EmployeeHourlyPayRate 
from dbo.Employee e 
inner join dbo.EmployeePosition ep 
on e.EmployeeKey = ep.EmployeeKey 
inner join dbo.Position p
on ep.PositionKey = p.PositionKey


--8. Create a view of the Bus Schedule assignment that returns the Shift times,
-- The Employee first and last name, the bus route (key) and the Bus (key).
-- Use the view to list the shifts for Neil Pangle in October of 2014

create view vw_DriverShifts
as 
Select EmployeeFirstName, EmployeeLastName, BusRouteKey, BusScheduleAssignmentDate [Assigned],
BusDriverShiftStartTime, BusDriverShiftStopTime 
from Employee e
inner join BusScheduleAssignment bsa 
on e.EmployeeKey = bsa.EmployeeKey
inner join BusDriverShift bds
on bsa.BusDriverShiftKey = bds.BusDriverShiftKey

Select BusRouteKey [Route], Day(Assigned) [Day of Month], 
BusDriverShiftStartTime, BusDriverShiftStopTime 
from vw_DriverShifts
where EmployeeFirstName = 'Neil'
and EmployeeLastName = 'Pangle'
and Year(Assigned) = 2014 
and Month(Assigned) = 10

--9. Create a table valued function that takes a parameter of city 
-- and returns all the employees who live in that city

Create function fx_EmployeesByCity(@City nvarchar(255))
returns table
as 
return 
Select EmployeeFirstName, EmployeeLastName
from Employee
Where EmployeeCity = @City

Select * from fx_EmployeesByCity('Bellevue')


--10. Use the cross apply operator to return the last 3 routes driven by each driver

Select distinct bsa.EmployeeKey, bsa.BusRouteKey [Route],
bsa.BusScheduleAssignmentDate
from dbo.BusScheduleAssignment as bsa 
inner join Employee e
on bsa.EmployeeKey = e.EmployeeKey
cross apply 
(
Select bs2.BusRouteKey, bs2.EmployeeKey, bs2.BusScheduleAssignmentDate 
from BusScheduleAssignment bs2
where bs2.EmployeeKey = bsa.EmployeeKey
order by BusScheduleAssignmentDate desc
offset 0 rows
fetch first 3 rows only
) as b 






