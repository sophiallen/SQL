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


--2. Use only subqueries to do this. Return the key, last name and
-- first name of every employee who has the position name “manager.”

Select EmployeeKey, EmployeeLastName, EmployeeFirstName 
from Employee 
Where EmployeeKey in (
Select EmployeeKey from EmployeePosition 
where PositionKey = (
Select PositionKey from Position where PositionName = 'Manager'))


-- Current progress on Q3:
Select Year(BusScheduleAssignmentDate) as 'Year',
(Select sum(Riders) from Ridership) as 'Total',
 avg(Riders) as 'Annual Average Ridership'
from Ridership 
inner join BusScheduleAssignment bsa
on Ridership.BusScheduleAssigmentKey = bsa.BusScheduleAssignmentKey
group by Year(bsa.BusScheduleAssignmentDate)
