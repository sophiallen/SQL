
# Set Operators, Modifying Data, and Windows Functions (2/9/17)

##Set Operators
Set operators are similar to mathematical set operations: union, combination, etc. 


### Union: Both data sets combined together. 
- Useful for things like creating mailing lists, etc. 
- Union, as a set operator, has been around much longer than the others. 

Example: Get a list of all employees from both the Community_Assist and MetroAlt databases. 
```
Select PersonFirstName, PersonLastName, EmployeeHireDate
from Person p
inner join Employee e 
on p.PersonKey = e.PersonKey
union 
Select EmployeeFirstName, EmployeeLastName, EmployeeHireDate
from MetroAlt.dbo.Employee 
```

Unions must **match like to like** (ex: in the above, it's matching firstname, lastname, hiredate). 

Trying to do the same thing using an inner join, like below, would result in an error. The below causes the hiredates from MetroAlt to get tied to the employee from Community_Assist, which is worthless data. **It's an illegitimate join.** The union above gets the correct, desired results. 
```
Select PersonFirstName, PersonLastName, EmpoyeeHireDate, e.EmployeeHireDate
From Person p 
inner Join MetroAlt.dbo.Employee e
on p.PersonKey = e.EmployeeKey 
```

### Intersect: Only the data that is both data sets. 

Example: List the cities that both Community_Assist employees and MetroAlt employees live in. 
```
Select PersonAddressCity from PersonAddress
intersect 
Select EmployeeCity from MetroAlt.dbo.Employee
```

### Except: Only the data that is in the first set but not in the second. 

Exmple: Select all the cities where people live in the Community_Assist db that are not in MetroAlt. 
```
Select PersonAddressCity from PersonAddress
except 
Select EmployeeCity, MetroAlt.dbo.Employee
```

- Note: reversing the order (putting MetroAlt's select statement first) would result in different data. 
- ```Except``` is similar to a left outer join, but is syntactically simpler. 

### Ranking functions

Show various ranking functions side-by-side. 
```
Select GrantRequestKey, GrantTypeKey, GrantRequestAmount, 
row_Number() over (order by GrantRequestAmount desc) as [Row Number], -- row number according to given order by
Rank() over (order by GrantRequestAmount desc) as [Requested Amount Rank], -- absolute ranking
Dense_Rank() over (order by GrantRequestAmount desc) as [Dense Rank], -- 
Ntile(10) over (order by GrantRequestAmount desc) as [NTile(10)]
from GrantRequest order by GrantRequestAmount desc
```

### Windows Partition Functions 
These essentially allow you to use aggregate functions and group them inline. A little simpler sometimes than using aggregates and group by. 

Show total request amount for all types, by year, and by grant type. 
```
Select distinct Year(GrantRequestDate) as [Year], GrantTypeKey, 
sum(GrantRequestAmount) over () as [Total Request Amounts], -- over everything
sum(GrantRequestAmount) over (Partition by Year(GrantRequestDate)) as [Amount Per Year]
sum(GrantRequestAmount) over (Partition by GrantTypeKey) as [Total per GrantType]
from GrantRequest order by GrantTypeKey
```

### Pivot Tables
These are possible with SQL server, but it's probably simpler to just export to excel. Steve didn't have the right info to demo today. 

### Insert, Update, and Delete

**Inserting new data:** 
```
Insert into Person(PersonLastName, PersonFirstName, PersonEmail, PersonEntryDate)
Values('James', 'Jesse', 'jjames@scc.org', GetDate())
Insert into PersonAddress(PersonAddressApt, PersonAddressStreet, 
PersonAddressCity, PersonAddressState, PersonAddressZip, PersonKey)
Values(Null, '1788 Cactus ln', 'Kent', 'WA', '98111', ident_current('Person'))
```
Notes: 
- You can't insert into the identity column (which is auto-numbered)
- ident_current([table name]) returns the most recent identity inserted into that table. In the case of the above, the newly created person's PersonKey will be returned. 


**Updating Data**
```
begin tran -- start a new transaction (so changes can be rolled back)

Update Person
Set PersonFirstName = 'Jesse', 
PersonEmail="jessyJames@scc.org'
Where PersonKey = ident_current('Person')
```
Note: Transactions lock the table until you either commit the changes and end the transaction(```commit tran```), or roll it back (```Rollback tran```). This is a problem for other people trying to work on the same table. 

**Deleting Data**
```
begin tran 
Delete from PersonAddress
where PersonKey = ident_current('PersonAdress')
```

Note: Parent rows (those with data that is used as a foreign key in another table) cannot be deleted unless the data that references that parent (its "children") are first deleted. 

