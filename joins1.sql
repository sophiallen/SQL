-- Create a cross join between employees and bus routes to show all possible combinations 
-- of routes and drivers (better use position to distinguish only drivers this involves a
-- cross join and an inner join. I will accept either)

select EmployeeFirstName, EmployeeLastName, BusRouteKey from Employee 
inner join EmployeePosition on Employee.EmployeeKey = EmployeePosition.EmployeeKey
inner join Position on EmployeePosition.PositionKey = Position.PositionKey
cross join BusRoute 
where PositionName = 'Driver'


-- List all the bus type details for each bus assigned to bus barn 3
Select * from Bus inner join Bustype 
on Bus.BusTypekey = BusType.BusTypeKey
where Bus.BusBarnKey = 3


