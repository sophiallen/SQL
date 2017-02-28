

# Triggers (2/28)
Triggers are similar to stored procedures, but are used when an event (like update or delete) happens. 

- Often used to enforce business rules. 
- You must be careful with creating them, since triggers can set off events that set off other triggers, leading to big cascades. 



###Example One:
*Create a trigger that enforces the maximum amount that can be requested whenever someone tries to insert a new grant request.*
```
Create trigger tr_OneTimeMaximum on GrantRequest
instead of insert
as 
Declare @oneTimeMax money
Declare @grantType int
Declare @requestAmount money

Select @grantType = GrantTypeKey from Inserted
Select @requestAmount = GrantRequestAmount from Inserted
Select @oneTimeMax = GrantTypeMaximum from Granttype where GrantTypeKey = @grantType

if @requestAmount <= @oneTimeMax --if request is within allowed maximum, 
begin 
insert into GrantRequest(GrantRequestDate, PersonKey, GrantTypeKey,  --insert it into the GrantRequest table
GrantRequestExplanation, GrantRequestAmount)
Select GrantRequestDate, PersonKey, GrantTypeKey, GrantRequestExplanation, GrantRequestAmount
from Inserted
end

else -- else, if not within allowed max
begin 

if not exists  --check to see if there's a dump table...
(Select name from sys.Tables where name = 'DumpTable')
begin 
create table DumpTable  --...and create one if it doesn't exist. 
(
	GrantRequestDate Datetime,
	PersonKey int,
	GrantTypeKey int,
	GrantRequestExplanation nvarchar(255),
	GrantRequestAmount money
)
end
 --then insert the request into the dump table instead of the requests table. 
insert into DumpTable(GrantRequestDate, PersonKey, GrantTypeKey, 
GrantRequestExplanation, GrantRequestAmount)
Select GrantRequestDate, PersonKey, GrantTypeKey, GrantRequestExplanation, GrantRequestAmount
from Inserted

end

```

- `Instead of insert` intercepts the change a user tries to make, then can check and make changes to it `before` the actual insert happens. 
- Note that triggers cannot take parameters, since they fire automatically on events. 
- `Inserted` is a temp table that holds the values about to be inserted. There is also a temp table for things like `deleted`. 
- `DumpTable` is a temp table we created to record attempted requests that were not allowed.

<br/>

###Example Two:
*Check donation amounts after insertion, autmatically confirm those less than 1000.* 
```
Create trigger tr_testInsert on Donation
after insert 
as 
Declare @Confirm UniqueIdentifier
Declare @Amount money
Select @Amount = DonationAmount from Inserted
if @Amount <= 1000
Begin 

Declare @Id int = ident_current('Donation')
Update Donation
set DonationConfirmation = @confirm
where DonationKey = @Id
end

```

**Notes:**
- Generally, triggers are lightweight enough not to impact performance. However, if triggers fire triggers, they can slow things down. 




