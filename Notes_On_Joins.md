

#Notes on Joins (1/17/17)

##Cross Joins: Matches every possible combination 
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

##Full Joins: 

