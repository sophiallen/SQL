# SubQueries (1/24/2017)

Subqueries are sometimes more efficient that joins, although SQL server has an optimization engine that's pretty tough to beat. 

We clicked ```use actual execution plan ``` and ```include client statistics``` in the toolbar before running a query to view more data about what's going on under the hood of the query. 

### Basic Subqueries
**Example:** Select Max donation amount, and the person who made the donation. 
```
select DonationKey, DonationAmount, PersonKey 
from Donation
where DonationKey = (Select max(DonationAmount) from Donation)
```
- Without subqueries, we'd have to group by donation key, and then we'd get the max donations for each donor -- not the overall max donation, and have to sort all of the results to get what we really wanted. 

**Example:** What types of grants has no one ever asked for? 
```
select GrantTypeName from GrantType 
where GrantTypeKey not in (Select GrantTypeKey from GrantRequest)
```

A few Notes: 
- It's important that you're looking for the same thing (or type of thing) in both the main and subqueries. Otherwise the results are basically meaningless. For example, looking for grant types where not in people from grantRequest --> nonsensical. 
- The above example can be achieved with an outer join, but the subquery is sometimes easier and clearer. 

**Example:** get info of all employees (excludes donors and grant recipients). Runs faster than the same query written using joins. 
```
Select PersonLastName, PersonFirstName, PersonEmail
from Person 
where PersonKey in (Select PersonKey from Employee)
```

### More Advanced Uses:

**Subqueries can be chained together:** ex: get the names of employees who denied grant requests. 
```
Select PersonFirstName, PersonLastName
from Person where PersonKey in (Select PersonKey from Employee 
where EmployeeKey in (Select EmployeeKey from GrantReview
where GrantRequestStatus = 'Denied'))
```
 
**Subqueries can be used the select clause:** Example: get total of all grants and subtotal for each granttype
```
Select GrantTypeName, Sum(GrantRequestAmount) as Subtotal, 
Sum(GrantRequestAmount)/(Select sum(GrantRequestAmount) from GrantRequest) as 'Percentage of Total'
from GrantRequest gr 
inner join GrantType gt
on gr.GrantTypeKey = gt.GrantTypeKey
Group by GrantTypeName
```

### Correlated Subqueries
Similar to recursive functions, have the same advantages and disadvantages. 

**Example:** Compare grant allocations where certain allocations are abover a certain amount, but only comparing between grants of the same type. (Would show unusually large food donations, rent donations, etc) Avoid these if you can, due to processing costs. 
```
Select GrantTypeKey, GrantRequestAmount 
from GrantRequest gr1
where GrantRequestAmount > (
Select avg(GrantRequestAmount)
from GrantRequest gr2 
where gr1.GrantTypeKey = gr2.GrantTypeKey)
```
*Notes:*
- Aliasing is very important here!
- Recursivity comes from the inner query referencing the outer query (thus the overall query references itself)


