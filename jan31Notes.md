# Querying a subquery

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


``` 
Select RequestMonth, GrantTypeName, Count(GrantTypeName) as [Count]
from
(Select Month(GrantRequestDate) RequestMonth, GrantTypeName
 from GrantRequest gr
 inner join gt 
 on gt.GrantTypeKey = gr.GrantTypeKey) as GrantTypeCounts
group by RequestMonth, GrantTypeName

```
