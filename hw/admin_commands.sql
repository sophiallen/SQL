--Create a Schema called "ManagementSchema."
create schema ManagementSchema

go 

--Create a view owned by the schema that shows the annual ridership.
create view ManagementSchema.RidershipInfo
Select Year(BusScheduleAssignmentDate) as 'Year', sum(Riders) as 'Annual Total', avg(Riders) as 'Annual Average',
(Select sum(Riders) from Ridership) as 'Total',
Cast((Sum(Riders) * 1.0)/(Select sum(Riders) from Ridership) * 100 as decimal(10,2))  as 'Percent'
from Ridership inner join BusScheduleAssignment bsa
on Ridership.BusScheduleAssigmentKey = bsa.BusScheduleAssignmentKey
group by Year(bsa.BusScheduleAssignmentDate)
--Note: I re-used the query from my Subqueries homework assignment. 

go 

--Create a view owned by the schema that shows the employee information including their position and pay rate.
create view ManagementSchema.EmployeeInfo
as
Select em.EmployeeKey, EmployeeFirstName, EmployeeLastName, EmployeeEmail, PositionName, EmployeeHireDate, EmployeeHourlyPayRate
from Employee em 
inner join EmployeePosition ep
on em.EmployeeKey = ep.EmployeeKey
inner join Position p 
on ep.PositionKey = p.PositionKey

go


--Create a role ManagementRole.
Create role ManagementRole

--Give the ManagementRole select permissions on the ManagementSchema and Exec permissions on the new employee stored procedure we created earlier.
Grant Select on schema::ManagementSchema to ManagementRole
Grant exec on dbo.usp_RegisterNewEmployee to ManagementRole

--Create a new login for one of the employees who holds the manager position.
Create login ManagersLogin with password = 'P@ssw0rd1'

--Create a new user for that login.
Create user ManagerLogin for login ManagersLogin

--Add that user to the Role.
Alter role ManagementRole add member ManagerLogin

--Login to the database as the new User, (Remember that SQL server authentication must be enabled for this to work.)
--Run the query to view the annual ridership. Does it work? 
-- >> Yes

--Try to select from the table Employees. Can you do it?
-- >> No, "SELECT permission denied"

--Back up the database MetroAlt.
backup database MetroAlt to disk='C:\Backups\MetroAlt.bak'
--Result: 
-->> Processed 3080 pages for database 'MetroAlt', file 'MetroAlt' on file 1.
-->> Processed 2 pages for database 'MetroAlt', file 'MetroAlt_log' on file 1.
-->> BACKUP DATABASE successfully processed 3082 pages in 0.854 seconds (28.187 MB/sec).
