
--1. Create a derived table that returns the position name as position and count of employees at that
--position. (I know that this can be done as a simple join, but do it in the format 
--of a derived table. There still will be a join in the subquery portion).

Select [Position Name], Count(EmployeeKey) [Employees] from 
(
 Select PositionName [Position Name], p.PositionKey, EmployeeKey from Position p
 inner join EmployeePosition ep on p.PositionKey = ep.PositionKey
) as Positions
group by [Position Name]
