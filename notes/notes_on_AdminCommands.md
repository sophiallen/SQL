
# Administrative Commands (3/7/2017)
<br/>
## Logins and Users
A few notes: 
- You can use windows login to authenticate users on windows machines. Encrypted Keys and certificates are other methods of authentication. 
- Typically, after creating a login via sql server, that login is given public access to the server, but not to the databases. 

<br/>

**Example:** Create a login with a default database. 
```
Create login EmployeesLogin with password = 'P@ssw0rd1', default_database=Community_Assist
```
*After creation, you'll be able to see it in the server-level security folder.* 

**Example:** Create an individual login mapped to the group login we created. 
```
Create user EmployeeLogin for login EmployeesLogin 
```


## Schema
In this context, schema refers to a collection of objects and its owner. 
By creating a schema, you can group together objects to make permissions easier. For example, below we created several views and assigned them to the EmployeeSchema, so that employees can be given permission to those standard tasks. 

```
Create schema EmployeeSchema 

go

Create view EmployeeSchema.EmployeeInfo
as
Select PersonLastName, PersonFirstName, EmployeeHireDate,
PersonEmail, EmployeeAnnualSalary, PositionName
from Person p 
inner join Employee e on p.PersonKey = e.PersonKey
inner join EmployeePosition ep on e.EmployeeKey = ep.EmployeeKey
inner join Position pos on ep.PositionKey = pos.PositionKey

//Created another view
```

## Roles & Permissions
Roles are groupings of permissions. It is much much better, and easier to maintain, to create roles and assign users to roles rather than giving individual users direct permissions. 

```
Create role EmployeeRole

Grant Select on schema::EmployeeSchema to EmployeeRole

Grant Insert, update on GrantReview to EmployeeRole 

Grant select on GrantType to EmployeeRole

Alter role EmployeeRole add member EmployeeLogin
```

*Notes:* 
- it is possible to deny permissions, but that is not standard because it's cleaner simply not to give that user the permission in the first place.
- There's such a thing as a `with grant` that allows a user to temporarily be granted higher permissions, for example by a stored procedure. 
- There is a stored procedure for adding members to roles, but you can also do it with a script. 
- server->properties->security switch from Windows Authentication mode to Sql Server and Windows Auth mode. You must then re-start the server. 

## Backup database
We took the following steps: 
1. Created a folder in the c: drive called Backups. Note: Never put your backups on the same drive as your database, same goes for your logs. That way if your disk gets corrupted you won't have lost everything. 
2. `Backup Database Community_Assist to disk='C:\Backups\Community_Assist.bak`

The log can also be backed up, more examples can be found in Steve's blog: www.congeritc.blogspot.com


