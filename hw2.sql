/*
HW2: Selects One
Sophia Allen
*/

Use MetroAlt

-- 1. Return all the employees
Select * from Employee

-- 2. Return only the last name, first name and emails for all employes. 
Select EmployeeLastName, EmployeeFirstName from Employee

-- 3. Return all employees sorted by last name alpabetically
Select * from Employee order by EmployeeLastName 


-- 4. Sort by hire date, most recent first. 
Select * from Employee order by EmployeeHireDate

-- 5. Select all employees living in Seattle
Select * from Employee where EmployeeCity = 'Seattle'

-- 6. Lost all employees not in Seattle
Select * from Employee where EmployeeCity != 'Seattle'

--7. Only employees without phones
Select * from Employee where EmployeePhone is null

-- 8. List only employees who have phones 
Select * from Employee where EmployeePhone is not null

-- 9. Employees whose last name starts with C
Select * from Employee where EmployeeLastName like 'C%'


-- 10. List all the employee keys and their wages sorted by pay from highest to lowest
Select EmployeeKey, EmployeeHourlyPayRate from EmployeePosition order by EmployeeHourlyPayRate desc

-- 11. List all the employee keys and their hourly wage for those with PositionKey equal to 2 (mechanics)
Select EmployeeKey, EmployeeHourlyPayRate from EmployeePosition where EmployeePosition.PositionKey = 2

-- 12. Return the top 10 of the query for question 11
Select top 10 EmployeeKey, EmployeeHourlyPayRate from EmployeePosition where EmployeePosition.PositionKey = 2

-- 13. Using the same query offset by 20 and list 10
Select EmployeeKey, EmployeeHourlyPayRate from EmployeePosition
 where EmployeePosition.PositionKey = 2 
 order by EmployeeKey offset 20 rows 
 fetch next 10 rows only

-- 14. Using BusScheduleAssignment, Return the busdriverKey and the busrouteKey but remove all duplicates
Select distinct EmployeeKey, BusRouteKey from BusScheduleAssignment

