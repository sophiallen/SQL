

-- Create a cross join between employees and bus routes to show all possible combinations 
-- of routes and drivers (better use position to distinguish only drivers this involves a
-- cross join and an inner join. I will accept either)
select EmployeeFirstName, EmployeeLastName, BusRouteKey from Employee 
inner join EmployeePosition on Employee.EmployeeKey = EmployeePosition.EmployeeKey
inner join Position on EmployeePosition.PositionKey = Position.PositionKey
cross join BusRoute 
where PositionName = 'Driver'

-- List all the bus type details for each bus assigned to bus barn 3
Select * from Bus inner join Bustype 
on Bus.BusTypekey = BusType.BusTypeKey
where Bus.BusBarnKey = 3

-- What is the total cost of all the busses at bus barn 3
Select sum(BustypePurchasePrice) as [Total Cost] 
from Bus inner join Bustype 
on Bus.BusTypekey = BusType.BusTypeKey
where Bus.BusBarnKey = 3   -- Result: 2164960.00

-- What is the total cost per type of bus at bus barn 3
Select Bus.BusTypeKey, sum(BustypePurchasePrice) as [Total Cost] 
from Bus inner join Bustype 
on Bus.BusTypekey = BusType.BusTypeKey
where Bus.BusBarnKey = 3
group by Bus.BusTypekey

-- List the last name, first name, email, position name and hourly pay for each employee
Select EmployeeLastname, EmployeeFirstName, EmployeeEmail,
PositionName, EmployeeHourlyPayRate from Employee 
inner join EmployeePosition on Employee.EmployeeKey = EmployeePosition.EmployeeKey
inner join Position on EmployeePosition.PositionKey = Position.PositionKey

-- List the bus driver’s last name  the shift times, the bus number (key) 
-- and the bus type for each bus on route 43
Select EmployeeLastName, BusDriverShiftStartTime, BusDriverShiftStopTime, BusTypekey 
from Employee 
inner join BusScheduleAssignment 
on Employee.EmployeeKey  = BusScheduleAssignment.EmployeeKey
inner join BusDriverShift 
on BusScheduleAssignment.BusDriverShiftKey = BusDriverShift.BusDriverShiftKey
inner join Bus on BusScheduleAssignment.BusKey = Bus.BusKey
where BusRouteKey = 43

--Return all the positions that no employee holds.
Select PositionName, EmployeeKey from Position
left outer join EmployeePosition 
on Position.PositionKey = EmployeePosition.PositionKey
where EmployeePosition.EmployeeKey is null


--Get the employee key, first name, last name, position key for every driver (position key=1)
-- who has never been assigned to a shift. (This is hard it involves an inner join of several 
-- tables and then an outer join with BusscheduleAssignment.)

Select Employee.EmployeeKey, EmployeeFirstName, EmployeeLastName, PositionKey from Employee 
inner join EmployeePosition on Employee.EmployeeKey = EmployeePosition.EmployeeKey
left outer join BusScheduleAssignment on Employee.EmployeeKey = BusScheduleAssignment.EmployeeKey
where PositionKey = 1 and BusScheduleAssignmentKey is null 



