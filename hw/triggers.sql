-- Create a trigger to fire when an employee is assigned to a second shift in a day. 
-- Have it write to an overtime table. the Trigger should create the overtime table
-- if it doesn't exist. Add an employee for two shifts to test the trigger.

Create trigger tr_OverTime on BusScheduleAssignment
instead of insert
as 
Declare @ShiftsAssigned int
Declare @AssignmentDate date
Declare @EmployeeKey int

Select @EmployeeKey = EmployeeKey from Inserted
Select @AssignmentDate = BusScheduleAssignmentDate from Inserted

Select @ShiftsAssigned = count(BusDriverShiftKey) from 
BusScheduleAssignment where EmployeeKey = @EmployeeKey and 
BusScheduleAssignmentDate = @AssignmentDate

if (@ShiftsAssigned >= 1)
begin

if not exists
(Select name from Sys.tables where name = 'Overtime')
begin

create table Overtime
(
	OverTimeScheduleAssignmentKey int identity(1,1) primary key not null,
	BusDriverShiftKey int foreign key references BusDriverShift not null, 
	EmployeeKey int foreign key references Employee not null, 
	BusRouteKey int foreign key references BusRoute not null, 
	BusScheduleAssignmentDate date not null, 
	BusKey int foreign key references Bus not null
)
end -- end create table if not exists

insert into Overtime(OverTimeScheduleAssignmentKey, BusDriverShiftKey,
 EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey)
 Select * from Inserted

end -- end insert into overtime if driver already assigned a shift that day
else 
begin -- begin normal insert, assignment is not overtime

insert into BusScheduleAssignment(
BusDriverShiftKey, EmployeeKey, 
BusRouteKey, BusScheduleAssignmentDate, BusKey)
Select BusDriverShiftKey, EmployeeKey, BusRouteKey, BusScheduleAssignmentDate, BusKey from Inserted

end

--Testing: 
insert into BusScheduleAssignment(
BusDriverShiftKey, EmployeeKey, 
BusRouteKey, BusScheduleAssignmentDate, BusKey)
values (
1, 33, 99, getDate(), 95
)

insert into BusScheduleAssignment(
BusDriverShiftKey, EmployeeKey, 
BusRouteKey, BusScheduleAssignmentDate, BusKey)
values (
2, 33, 99, getDate(), 95
)

select * from BusScheduleAssignment order by BusScheduleAssignmentDate desc
select * from Overtime





