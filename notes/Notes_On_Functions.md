
# Temporary Tables and Functions (2/14)

##Temp Tables
- Used for testing potentially dangerous commands, or for restructuring. Restructuring often requires dropping tables before re-creating them, but you can  use temp tables to save the data that you want before dropping. 
- Temp tables only last until you close your session, and only your current session can query it. 

**Creating temp Tables:**
Start temp table names with ```#``` to indicate the table is temporary
*In the below example, matching the column names to the Person table doesn't matter, but data types do.* 
```
Create Table #TempPerson 
{
  PersonKey int,
  PersonLastName nvarchar(255),
  PersonFirstName nvarchar(255),
  PersonEmail nvarchar(255)
}
```

Populate the temp table with data from another:
```
insert into #TempPerson(PersonKey, PersonLastName, PersonFirstname, PersonEmail)
select PersonKey, PersonLastName, PersonFirstName, PersonEmail from Person
```

**Querying temp tables across sessions**
You can make a temp table global (accessible by more than one session at a time) by adding an extra hash mark to its name, signifying that it is a global temp table. Once all the sessions connected to the temp table are closed, the temp table will disappear. 
```
Create Table ##GlobalTempPerson 
{
  PersonKey int,
  PersonLastName nvarchar(255),
  PersonFirstName nvarchar(255),
  PersonEmail nvarchar(255)
}
```


##Functions

We've already done table-valued functions, today we'll do scalar functions. To the best of Steve's knowledge, the only way to write aggregate functions is to write them in c#/c. 

**Example: ** Function that cubes a number:
```
create function fx_cube  -- function name
( @number int)           -- arguments and their data types
returns in               -- return type
as 
Begin
  return @number * @number * @number
End
```

The keywork `as` begins the body of the function, which is wrapped in `begin`  and `end`. 

Alternative, using a variable declared inside of the function: 
```
create function fx_cube  -- function name
( @number int)           -- arguments and their data types
returns in               -- return type
as 
Begin
  declare @cube int
  set @cube = @number * @number * @number
  return @cube
End
```

You can view functions you've created in the programmability directory of your db in the Object Explorer. 

It's often a good idea to check to see if the function you're about to write already exists in the programmability directory before you write it. 

**Call your function: ***
```
 Select dbo.fx_cube(7)
```

**Example:** function that takes a multi-line address and changes to one-line
```
Create function fx_OneLineAddress
(@apartment nvarchar(255), @street nvarchar(255), @city nvarchar(255), @state nchar(2), @zip nchar(9))
returns nvarchar(255)
as
begin
  declare @Address nvarchar(255)
  if @apartment is null 
    begin 
      set @Address = @street + ', ' + @city + ', ' + @state + ', '  + @zip
    end
   else 
     begin 
       set @Address = @street + ' ' + @apartment +  ', ' + @city + ', ' + @state + ', '  + @zip
     end
  
  return 
end
```
