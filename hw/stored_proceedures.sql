
-- 1. Create a stored procedure to enter a new employee, position and pay rate which uses 
-- the functions to create an email address and the one to determine initial pay. Also 
-- make sure that the employee does not already exist. Use the stored procedure to add a new employee.

create procedure usp_RegisterNewEmployee
@EmployeeLastName nvarchar(255),
@EmployeeFirstName nvarchar(255),
@EmployeeAddress nvarchar(255),
@EmployeeCity nvarchar(255),
@EmployeeZipCode nchar(10),
@EmployeePhone nchar(10),
@EmployeePositionKey  int
as 

declare @EmployeeEmail nvarchar(255)
set @EmployeeEmail = dbo.fx_getEmail(@EmployeeFirstName, @EmployeeLastName)

begin tran
begin try 

if not exists (Select EmployeeKey from Employee where EmployeeEmail = @EmployeeEmail)
begin 

insert into Employee(
EmployeeLastName, EmployeeFirstName, EmployeeAddress, EmployeeCity, 
EmployeeZipCode, EmployeePhone, EmployeeEmail, EmployeeHireDate) 
values (
@EmployeeLastName, @EmployeeFirstName, @EmployeeAddress, @EmployeeCity,
@EmployeeZipCode, @EmployeePhone, @EmployeeEmail, GetDate())

declare @HourlyPay decimal(5,2)
set @HourlyPay = dbo.fx_newEmployeeHourlyPayRate(@EmployeePositionKey)

declare @EmployeeKey int
set @EmployeeKey =  ident_current('Employee')

Insert into EmployeePosition(EmployeeKey, PositionKey, EmployeeHourlyPayRate, EmployeePositionDateAssigned)
values (@EmployeeKey, @EmployeePositionKey, @HourlyPay, GetDate())
 
end -- end if 

end try 

begin catch
rollback tran 
print Error_Message()
return -1
end catch

commit tran


-- 2. Create a stored procedure that allows an employee to edit their own information name, 
-- address, city, zip, not email etc.  The employee key should be one of its parameters. Use 
-- the procedure to alter one of the employees information. Add error trapping to catch any errors.


