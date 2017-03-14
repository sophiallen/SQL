
# XML (3/14):


A few rules of xml:
- Everything has an opening and closing tag
- Xml is case-sensitive. 
- Some special words are reserved
- Every element has one root. (Tree structure)
- Recommended to use namespacing. (As seen in the xmlns="http://pseudo/link/to/xmlfile") 

Performance note:
- The entire document must be processed in order to construct the tree, so large documents can take a long time. 

```
create xml schema collection MaintenanceNotesSchema as 
'<?xml version="1.0" encoding="utf-8"?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified" 
           targetNamespace="http://www.metroalt.com/maintenancenote" 
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="maintenancenote">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="title" />
        <xs:element name="note">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="p" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="followup" />
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'

Alter table MaintenanceDetail
drop column MaintenanceNotes

Alter table MaintenanceDetail
add MaintenanceNotes xml(MaintenanceNotesSchema)

insert into Maintenance(MaintenanceDate, BusKey) 
values (GetDate(), 1)

insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNotes)
values (ident_current(Maintenance), 66, 1, 
'<?xml version="1.0" encoding="utf-8"?>
<maintenancenote xmlns="http://www.metroalt.com/maintenancenote">
  <title>Wear and Tear on Hydralic units</title>
<note>
  <p>The hydralic units are showing signs of stress</p>
  <p>I recommend the replacement of the units</p>
</note>
  <followup>Schedule replacement for June 2016</followup>
</maintenancenote>')


insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNotes)
values (ident_current(Maintenance), 66, 2, 
'<?xml version="1.0" encoding="utf-8"?>
<maintenancenote xmlns="http://www.metroalt.com/maintenancenote">
  <title>Filter Check</title>
<note>
  <p>Fuel filter looks clean.</p>
  <p>Air filter needs replacing. </p>
</note>
  <followup>Order new air filter. </followup>
</maintenancenote>')

insert into MaintenanceDetail(MaintenanceKey, EmployeeKey, BusServiceKey, MaintenanceNotes)
values (ident_current(Maintenance), 66, 3, 
'<?xml version="1.0" encoding="utf-8"?>
<maintenancenote xmlns="http://www.metroalt.com/maintenancenote">
  <title>Replace head gasket</title>
<note>
  <p>Replaced cracked head gasket.</p>
</note>
  <followup>Watch oil levels.</followup>
</maintenancenote>')


select top 10 EmployeesLastName, EmployeeFirstName, EmployeeEmail from Employee
for xml raw('employee'), elements, root('Employees')
-- right click the results that are displayed in the console to view the xml
```

**Notes**
- When you select xml raw, sql server returns all of the xml data as attributes.
- By specifying `xml raw, elements` sql server returns the data as elements instead of attributes. 
- Specifying `root('RootName')` will wrap the rows returned in a parent element, thus creating a complete and valid xml file. 
- Specifying `raw('RowName')` will rename the row elements to whatever name you give it. 
- Saying `auto` instead of raw allows for deeper embedding. 

**Querying Xml using XQuery**
```
Select MaintenanceKey, EmployeeKey, BusServiceKey, 
MaintenanceNotes.query('declare namespace mn="http://www.metroalt.com/maintenancenote";
//mn:maintenanceNotes/mn:note/*') as comments from MaintenanceDetail
```
