-- 1. Return the employee key, last name and first name, position name and hourly rate 
-- for those employees receiving the maximum pay rate

Select em.EmployeeKey, EmployeeFirstName, EmployeeLastName, PositionName, EmployeeHourlyPayRate
from Employee em 
inner join EmployeePosition ep
on em.EmployeeKey = ep.EmployeeKey
inner join Position p 
on ep.PositionKey = p.PositionKey
where EmployeeHourlyPayRate in 
(Select Max(EmployeeHourlyPayRate) from EmployeePosition)


-- 2. Use only subqueries to do this. Return the key, last name and
-- first name of every employee who has the position name “manager.”

Select EmployeeKey, EmployeeLastName, EmployeeFirstName 
from Employee 
Where EmployeeKey in (
Select EmployeeKey from EmployeePosition 
where PositionKey = (
Select PositionKey from Position where PositionName = 'Manager'))


-- 3. Query the yearly ridership totals, averages, and percentage of total ridership for all years. 
Select Year(BusScheduleAssignmentDate) as 'Year', sum(Riders) as 'Annual Total', avg(Riders) as 'Annual Average',
(Select sum(Riders) from Ridership) as 'Total',
Cast((Sum(Riders) * 1.0)/(Select sum(Riders) from Ridership) * 100 as decimal(10,2))  as 'Percent'
from Ridership inner join BusScheduleAssignment bsa
on Ridership.BusScheduleAssigmentKey = bsa.BusScheduleAssignmentKey
group by Year(bsa.BusScheduleAssignmentDate)
order by Year(bsa.BusScheduleAssignmentDate)

-- 4. Create a new table called EmployeeZ, and insert all employees who have last names starting with Z. 
Insert into EmployeeZ
Select EmployeeLastName, EmployeeFirstName, EmployeeEmail from Employee
where EmployeeLastName like 'Z%'


-- 5. Return the position key, the employee key and the hourly pay rate for
-- those employees who are receiving the highest pay in their positions. Order it by position key.
Select PositionKey, Employee.EmployeeKey, EmployeeHourlyPayRate
from Employee inner join EmployeePosition ep1
on Employee.EmployeeKey = ep1.EmployeeKey
where EmployeeHourlyPayRate = (
Select max(EmployeeHourlyPayRate) from EmployeePosition ep2
where ep1.PositionKey = ep2.PositionKey) 
order by PositionKey
