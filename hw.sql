
/*Homework One: Creating Tables
 Sophia Allen 1/10/2017
*/


Use MetroAlt

/*1.  BusService: 
BusServiceKey int identity primary key
BusServiceName variable character, required
BusServiceDescription variable character*/

Create table BusService(
	BusServiceKey int identity(1,1) primary key,
	BusServiceName nvarchar(255) not null,
	BusServiceDescription nvarchar(255)
)

/*2. Maintenance: 
MaintenanceKey int, an identity, primary key
MainenanceDate Date, required
Buskey int foreign key related to Bus, required
*/

Create table Maintenance(
	MaintenanceKey int identity(1,1) primary key,
	MaintenanceDate datetime not null,
	Maintenance int not null foreign key references BusService(BusServiceKey)
)

/* 3. MaintenanceDetail
MaintenanceDetailKey int identity 
Maintenancekey int  required
EmployeeKey int  required
BusServiceKey int  required
MaintenanceNotes  variable character
*/


Create table MaintenanceDetail(
	MaintenanceDetailKey int identity(1,1),
	MaintenanceKey int not null,
	EmployeeKey int not null, 
	BusServiceKey int not null, 
	MaintenanceNotes nvarchar(255)
)

-- Use alter table to add a primary key constraint to Maintenance detail setting MaintenanceDetailKey as the primary key
Alter table MaintenanceDetail 
Add constraint PK_MaintenanceDetail primary key (MaintenanceDetailKey)

-- Use alter table to set MaintenceKey as a foreign key
Alter table MaintenanceDetail
Add constraint FK_Maintenance foreign key(MaintenanceKey) references Maintenance(MaintenanceKey)

-- Use alter table to set EmployeeKey as a foreign key
Alter table MaintenanceDetail
Add constraint FK_Employee foreign key(EmployeeKey) references Employee(EmployeeKey)

-- Use alter table to set BusServiceKey as a foreign key
Alter table MaintenanceDetail
Add constraint FK_BusService foreign key(BusServiceKey) references BusService(BusServiceKey)

-- Add a column to BusType named BusTypeAccessible. Its data type should be bit 0 for no and 1 for yes.
Alter table BusType
Add BusTypeAccessible bit

-- Use alter table to Add a constraint to email in the Employee table to make sure each email is unique
Alter table Employee
Add constraint uq_Email unique(EmployeeEmail)
