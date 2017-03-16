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
--Try to select from the table Employees. Can you do it?
--Back up the database MetroAlt.
