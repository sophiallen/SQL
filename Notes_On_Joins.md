

#Notes on Joins (1/17/17)

##Cross Joins: 
Cross Joins return possible combination of matches. 
- EX: ``` Select PersonLastName, DonationAmount from Person, Donation ```  <- Every possible person is connected to every possible donation amount. 
- Sometimes used as a stress test. 
- Can also be written: Select PersonLastName, DonationAmount from Person Cross Join Donation


##Inner Joins 
**Old syntax**: common but dangerous because if a relationship is forgotten, it can lead to an implied cross join. 
```
Select PersonLastName, PersonEmail, ContactNumber, DonationAmount 
FROM Person, Contact, Donation 
WHERE Person.PersonKey = Contact.PersonKey
and Person.PersonKey = Donation.PersonKey
```

**New Syntax**: Safer because forgotten relationships will throw errors

*Example One*: viewing information of all people who have made donations
```
Select PersonLastName, PersonEmail, ContactNumber, DonationAmount
from Person 
inner Join Contact 
on Person.PersonKey = Contact.PersonKey
inner Join Dontaion 
on Person.PersonKey = Donation.PersonKey
where ContactTypeKey = 1
```
*Note:* inner joins only return matching information. For example, the above will ignore people who have not made donations. 

*Example 2:* Combining inner joins and aggregate functions to create a summary
```
Select Year(GrantRequestDate) [Year], GrantTypeName, Sum(GrantRequestAmount) as Request, 
Sum(GrantAllocationAmount) as Granted, Sum(GrantAllocationAmount)/sum(GrantRequestAmount) as Percentage
From GrantRequest gr
INNER JOIN GranteType gt
ON gr.GrantTypeKey = gt.GrantTypeKey
INNER JOIN GrantReview gv
ON gv.GrantRequestKey = gr.GrantRequestKey
GROUP BY Year(GrantRequestDate), GrantTypeName
ORDER BY Year(GrantRequestDate)
```

##Outer Joins
This type of join only shows matches on one side, and shows full data on the other. 
Left/Right specifies whether the first or second table named will display full data.
* Good for finding mis-matches, ex: customers that have not made purchases, etc. 

```
Select GrantTypeName, GrantRequest.GrantTypeKey
From GrantType
Left Outer Join GrantRequest 
on GrantType.GrantTypeKey = GrantRequest.GrantRequestKey
```


*Example:* Find ContactType that has no ContactTypeKey
```
Select ContactTypeName, Contact.ContactTypeKey
from ContactType
left outer Join Contact
on ContactType.ContactTypeKey = Contact.ContactTypeKey
where Contact.ContactTypeKey is NULL
```


##Full Joins: 
Returns everything from both tables, whether they match or not. 
```
Select Distinct ContactTypeName, Contact.ContactTypeKey
from ContactType
Full Join Contact
on ContactType.ContactTypeKey = Contact.ContactTypeKey
where Contact.ContactTypeKey is NULL
```

