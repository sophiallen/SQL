


# Stored Proceedures (2/21)

Ex: Register a new person in CommunityAssist
- Sub-Tasks:
  - Check that person doesn't already exist. 
  - Insert into Person
    - Create seed hash for password
  - Insert into PersonAddress
  - Insert into PersonContact
  - Ensure that either all or none of the above happen. 
  
```
create proceedure usp_Registration
@PersonLastName nvarchar(255),  -- Declaring variables to hold incoming information. 
@PersonFirstName nvarchar(255),
@PersonEmail nvarchar(255),
@PersonPassword nvarchar(20),  -- this is what we'll hash into binary, not what we'll actually store
@PersonAddressApt nvarchar(255) = null, --give default value of null, if no apt provided. 
@PersonAddressStreet nvarchar(255),
@PersonAddressCity nvarchar(255) = 'Seattle',  -- default city, if none provided. 
@PersonAddressState nvarchar(2) = 'WA', 
@PersonAddressZip nvarchar(9),
@HomePhone nvarchar(10) = null,
@WorkPhone nvarchar(10) = null
as 

Declare @seed int -- seed for the hashing function
set @seed = dbo.fx_GetSeed()  -- get a semi-random number and save it to the variable. 
Declare @pass varbinary(500)
set @pass = dbo.fx_HashPassword(@seed, @PersonPassword)  --get the hash of the password. 

insert into Person(PersonLastName, PersonFirstName, PersonEmail,
PersonPassWord, PersonEntryDate, PersonPasswordSeed)
values (@PersonLastName, @PersonFirstName, @PersonEmail, @pass, GetDate(), @seed)

declare @PersonKey int 
set @PersonKey = ident_current(Person) -- get the key of the person we just inserted into Person. 

insert into PersonAddres(PersonAddressApt, PersonAddressStreet,
PersonAddressCity, PersonAddressState, PersonAddressZip, PersonKey)
values(@PersonAddressApt, @PersonAddressStreet,
@PersonAddressCity, @PersonAddresState, @PersonAddressZip, @PersonKey)

IF Not @HomePhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
values (@HomePhone, 1, @PersonKey)
end

IF Not @WorkPhone is null
Begin
Insert into Contact(ContactNumber, ContactTypeKey, PersonKey)
values (@WorkPhone, 2, @PersonKey)
end 

```

**Notes:**
- Naming convention: start with `usp_` to indicate that it's a user stored proceedure as opposed to a system stored proceedure.
- In the above example, we didn't need to input the date or person key because those can be grabbed easily or generated by us. 
- If we don't provide a default value for a field, the stored proceedure will throw an error if that field is left blank. 


**Use the stored Proceedure**
Note that we left out several parameters that were assigned the default values of null in the stored proceedure above. 
```
exec use_Registration
@PersonLastName = 'Trent', 
@PersonFirstName= 'Reznor',
@PersonEmail = 'Trez@nor.com',
@PersonPassword = 'trezpass', 
@PersonAddressStreet '1125 Hurtless St',
@PersonAddressCity nvarchar(255) = 'Renton', 
@PersonAddressZip 98123,
@HomePhone nvarchar(10) = '2065554432'
```
Should show three rows affected: Person, PersonAddress, and Contact. 


### Ensuring that either all inserts worked, or none did.
We'll use a transactiona nd a try/catch block. 

In the above stored proceedure, we added the lines before the first insert: 
```
Begin try
Begin tran
```

And then the following after all of the inserts, to commit the changes after all the errors have been avoided. 
```
end try
commit tran
```

To actually *catch* the error, we wrote the following after `end try` and before `commit tran`: 
```
Begin catch 
rollback tran --rollback any changes
print Error_Message() -- print error message for developers
return -1
end
```

### Checking for entries that have already been added

Put before the seed declaration: 
```
if not exists
(Select PersonKey from Person where PersonEmail = @PersonEmail)  -- we use email since it's supposed to be unique
begin 
```
and then at the very end, a matching `end`
This wraps all of the code inside of the stored proceedure in an if block, so if the person doesn't exist, the normal code executes. 

At the very end, a final else to print the error: 
```
else
begin
print "Person already exists"
end
```

## Proceedure for updating information
Note that the below example ignores changing passwords. 
```
create proc usp_UpdatePersonInfo
@PersonKey int
@PersonLastName nvarchar(255), 
@PersonFirstName nvarchar(255),
@PersonEmail nvarchar(255),
@PersonAddressApt nvarchar(255) = null, 
@PersonAddressStreet nvarchar(255),
@PersonAddressCity nvarchar(255),
@PersonAddressState nvarchar(2) = 'WA', 
@PersonAddressZip nvarchar(9),
@HomePhone nvarchar(10) = null,
@WorkPhone nvarchar(10) = null

as 

begin try
begin tran
update Person
set PersonLastName = @PersonLastName. 
PersonFirstName = @PersonFirstName,
PersonEmail = @PersonEmail,
PersonAddressApt = @PersonAddressApt, 
PersonAddressStreet = @PersonAddressStreet,
PersonAddressCity = @PersonAddressCity,
PersonAddressState = @PersonAddressState,
PersonAddressZip = @PersonAddressZip
where PersonKey = @PersonKey

update Contact
Set ContactNumber = @HomePhone where 
PersonKey = @PersonKey and ContactTypeKey = 1

Update Contact 
set ContactNumber = @WorkPhone where
PersonKey = @PersonKey and ContactTypeKey = 2
commit tran

end try
begin catch
Rollback tran
print Error_Message()
end catch

```

**Example:** use a select to get PersonKey rather than passing it in as a parameter

```
Declare @PersonKey int
Select @PersonKey  = PersonKey from Person
where PersonEmail = @PersonEmail
```