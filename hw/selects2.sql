use MetroAlt;


-- List the years in which employees were hired, sort by year and then last name. 
Select  Year(EmployeeHireDate) [Year  Hired], EmployeeLastName from Employee order by Year(EmployeeHireDate), EmployeeLastName 


-- What is the difference in Months between the first employee hired and the last one.
Select DATEDIFF(month, 1995-01-06, 2014-12-16) as Months

-- Output the employee phone number so it looks like (206)555-1234.
Select '('  + substring(employeePhone, 0,4) + ') '
 + substring(employeePhone, 3, 3) 
 + '-' + substring(employeePhone, 6,4)
 as 'Phone Number' from Employee 

-- Output the employee hourly wage so it looks like $45.00 (EmployeePosition).
Select format(EmployeeHourlyPayRate, '$##0.00') as Wage from EmployeePosition

-- List only the employees who were hired between 2013 and 2015.
Select * from Employee where DATEPART(year, EmployeeHireDate) >= 2013
 and datepart(year, employeeHireDate) <= 2015 order by EmployeeHireDate

-- Output the position, the hourly wage and the hourly wage multiplied by 40 to see what a weekly wage might look like.
Select PositionName,
 format(EmployeeHourlyPayRate, '$##0.00') as 'Hourly Wage',
 format(EmployeeHourlyPayRate*40, '$#,##0.00') as 'Weekly wages'
 from EmployeePosition inner join Position 
 on EmployeePosition.PositionKey = Position.PositionKey
 order by [Hourly Wage] 

-- What is the highest hourly pay rate (EmployeePosition)?
-- $70.00

-- What is the lowest hourly pay rate?
-- $21.00

-- What is the average hourly pay rate?
Select avg(EmployeeHourlyPayRate) as 'Average Hourly Pay' from EmployeePosition
-- $39.89

-- What is the average pay rate by position?
Select PositionName, avg(EmployeeHourlyPayRate) as 'Average Hourly Pay' 
 from EmployeePosition inner join Position 
 on EmployeePosition.PositionKey = Position.PositionKey
 group by PositionName

-- Provide a count of how many employees were hired each year and each month of the year.
Select DatePart(year, EmployeeHireDate) [Year], 
DatePart(month, EmployeeHireDate) [Month], 
Count(EmployeeKey) [Employees Hired]
from Employee 
group by DatePart(year, EmployeeHireDate), DatePart(month, EmployeeHireDate)
order by Year asc

-- Do the query 11 again but with a case structure to output the months as words.
-- Note: I looked up the month name conversion online, but I think I understand what's happening. 

Select DatePart(year, EmployeeHireDate) [Year], 
DateName(month , DateAdd(month , DatePart(month, EmployeeHireDate), 0 ) - 1 )[Month], 
Count(EmployeeKey) [Employees Hired]
from Employee 
group by DatePart(year, EmployeeHireDate), DatePart(month, EmployeeHireDate)
order by Year asc


-- Return which positions average more than $50 an hour.
Select PositionName
from EmployeePosition inner join Position 
on EmployeePosition.PositionKey = Position.PositionKey
group by PositionName
having avg(EmployeeHourlyPayRate) > 50; --(Result: Accountant, Lawyer, Manager)
 
-- List the total number of riders on Metroalt busses (RiderShip).
select sum(Riders) from Ridership -- result: 23154666

-- List all the tables in the metroAlt databases (system views).
select name from sys.tables

-- List all the databases on server.
select name from sys.databases

