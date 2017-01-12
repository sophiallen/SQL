

#Notes on Selects (1/12):

### Aliasing extracts data from a column and displays it with the alias specified. 
  - Select Year(GrantRequestDate) as [Year], GrantRequestAmount from GrantRequest
  - Select Month(GrantRequestDate) as [Month], GrantRequestAmount from GrantRequest
  - Select Day(GrantRequestDate) as [Day], GrantRequestAmount from GrantRequest
  - Select DatePart(Minute, GrantRequestDate) from GrantRequest 
  - Select DatePart(Second, GrantRequestDate) from GrantRequest 

 Using built in function, gets the difference between starting and ending dates. 
  - Select DateDiff(Day, GetDate(), '3-23-2017') // 70 days

### Calculations & Casting
- Calculate 10% of donation amount and label as Operations, calculate 90% and label as Charity, based on the donation column 
  - Select DonationAmount * .10 Operations, DonationAmount * .90 Charity from donation
  
- You can look up more functions in the "Programmability" sub-directory of your db.

- Casting (important in cases where integer division would result in inaccuracy)
  - Select DonationAmount cast(DonationAmoun as decimal(10,2) * .10 Operations
  - Note: decimal(10,2) is formatting: how many decimals to left and right of period. 
  
### Formatting: 
  - Turn donation amounts to dollars: 
    - Select format('$ #,##0.00') as Amount from Donation
  - Note: format only works on numbers. Things like phone numbers (which are often recorded as strings) won't work with format like the above example. 


- Using a variable in formatting social security number example
  - Note: SQL does not use 0-indexing.  
Declare @SocialSec as nchar(9)
Set @SocialSec = '555444333'
Select SUBSTRING(@SocialSec, 1, 3) + '-' + SUBSTRING(@SocialSec, 4, 2) + '-' + SUBSTRING(@SocialSec, 6, 4) as SSNumber

### Aggregate Functions vs. Scalar
- The above are scalar functions (they operate row-by-row). Aggregate functions operate on groups of rows. 

- Example Aggregate functions: 
  - Select sum(donationAmount) as total from Donation
  - Select avg(donationAmount) as Averate from Donation
  - Select min(donationAmount) as Smallest from Donation
  - Select max(donationAmount) as Largest from Donation
    - Min and max will work on dates, and maybe strings (will return highest ASCII value). But avg and sum probably don't. 
  - Select Max(PersonLastName) as highest from Person
  
- You can't mix scalar and aggregate unless you group your rows. 
  - Select GrantTypeKey, format(avg(GrantRequestAmount), '$ ###0.0') as Average from GrantRequest //won't work by itself. 
  - Group by GrantTypeKey
  
### Having vs. Where
- Useful Examples: 
 Select GrantTypeKey, format(avg(GrantRequestAmount), '$ ###0.0') as Average
 format(sum(GrantRequestAmount), '$ ###0.0')  as Total
 from GrantRequest
 Where GrantTypeKey not GrantTypeKey = 2
 Group by GrantTypeKey
 Having Avg(GrantRequestAmount) > 400
 
 - 'Having' always goes *after* group by, 'where' always goes *before*. 
 - In not-ing an expression, you can use the keyword not (standard for SQL), or !=, or <>
 
 
### MetaDetails
 - You can query metadetail thus: 
   - Select name from sys.Tables   // retrieves the names of all the tables.
   - Select * from sys.Tables    // retrieves other data like object inheritance and shema info
   - Select * from sys.Tables where Object_id = [id here]  
   - Select * from sys.databases
   - If you go in the the views sub-folder, there's a ton of more things to try. 
 
