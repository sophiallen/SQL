

Notes on Selects for Selects2 hw:

- Aliasing extracts data from a column and displays it with the alias specified. 
  - Select Year(GrantRequestDate) as [Year], GrantRequestAmount from GrantRequest
  - Select Month(GrantRequestDate) as [Month], GrantRequestAmount from GrantRequest
  - Select Day(GrantRequestDate) as [Day], GrantRequestAmount from GrantRequest
  - Select DatePart(Minute, GrantRequestDate) from GrantRequest 
  
  
