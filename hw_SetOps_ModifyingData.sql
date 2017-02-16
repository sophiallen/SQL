use MetroAlt;

--Create a Union between Person and PersonAddress in Community assist and Employee in MetroAlt. You will need to 
-- fully qualify the tables in the CommunityAssist part of the query: CommunityAssist.dbo.Person etc.

Select EmployeeLastName, EmployeeFirstName, EmployeeAddress, EmployeeCity from Employee
union 
Select PersonLastName, PersonFirstName, PersonAddressStreet, PersonAddressCity
from Community_Assist.dbo.Person p
inner join Community_Assist.dbo.PersonAddress pa
on p.PersonKey = pa.PersonKey


--Do an intersect between the PersonAddress and Employee that returns the cities that are in both.

Select EmployeeCity from Employee
intersect 
Select PersonAddressCity from Community_Assist.dbo.PersonAddress


--Do an except between PersonAddress and Employee that returns the cities that are not in both. 

Select EmployeeCity from Employee
except
Select PersonAddressCity from Community_Assist.dbo.PersonAddress


-- Using the Data Tables we made in Assignment 1, insert the following services into BusService: General Maintenance, 
-- Brake service, hydraulic maintenance, and Mechanical Repair. You can add descriptions if you like. Next add entries 
-- into the Maintenance table for busses 12 and 24. You can use today’s date. For the details on 12 add General Maintenance 
-- and Brake Service, for 24 just General Maintenance. You can use employees 60 and 69 they are both mechanics.

insert into BusService(BusServiceName) 
values ('General Maintenance'), ('Brake Service'),('Hydraulic Maintenance'),('Mechanical Repair')

insert into Maintenance(MaintenanceDate, BusKey) 
values (GetDate(), 12), (GetDate(), 24)

insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNotes) 
values 
(1, 60, 1, 'Needs brake service'), 
(1, 69, 2, 'fixed rear-left brake pad'),
(2, 60, 1, 'Looks Good') 


-- Create a table that has the same structure as Employee, name it Drivers. Use the Select form of an insert to copy 
-- all the employees whose position is driver (1) into the new table.

insert into Driver(DriverLastName, DriverFirstName, DriverAddress, DriverCity,
 DriverZipCode, DriverPhone, DriverEmail, DriverHireDate) 
Select EmployeeLastName, EmployeeFirstName, EmployeeAddress, EmployeeCity,
 EmployeeZipCode, EmployeePhone, EmployeeEmail, EmployeeHireDate
 from Employee inner join EmployeePosition on Employee.EmployeeKey = EmployeePosition.EmployeeKey
 where EmployeePosition.PositionKey = 1

-- Edit the record for Bob Carpenter (Key 3) so that his first name is Robert and is City is Bellevue
begin tran

update Employee
set EmployeeFirstName = 'Robert', 
EmployeeCity = 'Bellevue'
where EmployeeKey = 3

commit tran

-- Give everyone a 3% Cost of Living raise.

begin tran
update EmployeePosition
set EmployeeHourlyPayRate = EmployeeHourlyPayRate * 1.03
commit tran

-- Delete the position Detailer
begin tran
delete from Position
where PositionName = 'Detailer'
commit tran
