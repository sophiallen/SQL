## Querying a subquery (derived tables)

**Example One** Getting info for people whose city is Bellevue
```
select PersonKey, [First], [Last], [First], City
from (
select p.PersonKey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
from Person p
inner join PersonAddress pa 
on p.PersonKey  = pa.PersonKey)
) as Residents 
where City = 'Bellevue'
```

**Example Two:** Getting the number of requests by type for each month. 
``` 
Select RequestMonth, GrantTypeName, Count(GrantTypeName) as [Count]
from
(Select Month(GrantRequestDate) RequestMonth, GrantTypeName
 from GrantRequest gr
 inner join gt 
 on gt.GrantTypeKey = gr.GrantTypeKey) as GrantTypeCounts
group by RequestMonth, GrantTypeName
```


## Common Table Expressions (CTE)
Similar to using subqueries, different syntactic structure but does the exact same thing. 
This way defines the table expression (subquery) before running outer query. It's considered cleaner, and is
generally preferred to using subqueries as above. 

**Example One, revised:**
``` 
with Residents as 
(
Select p.PersonKey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
from Person p
inner join PersonAddress pa 
on p.PersonKey  = pa.PersonKey
) 
Select PersonKey, [First], [Last], [First], City From Residents where City = 'Kent'
```
*Side Note: 'with' can also be used to force indexing, though it's hacky*

**Example Two, revised:**
```
with GrantTypeCounts as 
(
Select Month(GrantRequestDate) RequestMonth, GrantTypeName [Grant Type Name]
 from GrantRequest gr
 inner join gt 
 on gt.GrantTypeKey = gr.GrantTypeKey
)
Select RequestMonth, [Grant Type Name], Count([Grant Type Name) as [Count] 
from GrantCount
Group by RequestMonth, [Grant Type Name]
```

- CTEs are really useful when you have really complex sets of queries, as CTEs allow you to add more syntactic/organizational structure. 

## Using variables
Variables in SQL always start with an ```@```, and must always be declared before being set. Setting can be done with a value (as below) or a ```Select``` to dynamically assign value with query results. 
```
Declare @City nvarchar(255)
Set @City 'Bellevue'

Select Distinct PersonKey, [First], [Last], [First], City
from 
(
Select p.PersonKey, PersonLastName [Last], PersonFirstName [First], PersonAddressCity City
from Person p
inner join PersonAddress pa 
on p.PersonKey  = pa.PersonKey)
) as Residents 
where City = @City
```

## Creating & Using Views
In essence, views are stored queries. 
- Views always have an ```as```, just like functions and stored proceedures. The ```as``` keyword is used to assign value. 
- Be wary of batches, it's a good idea to have a ```go``` statement or semicolon to mark end of the code. 
- Views only display aliases, and obscure the underlying tables and columns from users who only have access to views. 

**Example:** create view that lists essential employee information. 
```
create view vw_Employees
As 
Select 
PersonLastName LastName, PersonFirstName FirstName, 
EmployeeHireDate [Hire Date], EmployeeAnnualSalary Salary,  
PositionName [Position]
from Person p
inner join Employee e 
on p.PersonKey = e.PersonKey
inner join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position pos
on ep.PositonKey = pos.PositionKey;
```

*After running and refreshing the db explorer, the 'views' folder should have your new view displayed.*

- Run your view by querying:```Select * from vw_Employees```

### Notes on views 
- Inserting/Updating through views is only possible if there are no aliases, joins, or subqueries. In general, it's not a great idea. 
- You are not allowed inside of a view to use ```order by```. When *running* the view you can order the results (ex: ```Select * from vw_Employees order by LastName```), but not in the definition of the view itself. 

### SchemaBinding
Creating a view with schemabinding locks the underlying table so that it cannot be altered unless the view has been dropped. Schemabinding helps prevent broken views. 
```
alter view vw_Employees with schemabinding
As 
Select 
PersonLastName LastName, PersonFirstName FirstName, 
EmployeeHireDate [Hire Date], EmployeeAnnualSalary Salary,  
PositionName [Position]
from dbo.Person p
inner join dbo.Employee e 
on p.PersonKey = e.PersonKey
inner join dbo.EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join dbo.Position pos
on ep.PositonKey = pos.PositionKey;
```

