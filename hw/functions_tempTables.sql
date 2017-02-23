--Create a temp table to show how many stops each route has. the table should have fields 
--for the route number and the number of stops. Insert into it from BusRouteStops and then 
--select from the temp table.

create Table #TempRoute (
	RouteKey int,
	RouteStops int
)

insert into #TempRoute(RouteKey, RouteStops) 
select r.BusRouteKey, Count(BusStopKey) 'Stops'
from BusRoute r inner join BusRouteStops s
on r.BusRouteKey = s.BusRouteKey
group by r.BusRouteKey;


--Do the same but using a global temp table.

create Table ##GlobalTempRoute (
	RouteKey int,
	RouteStops int
)

insert into ##GlobalTempRoute(RouteKey, RouteStops) 
select * from #TempRoute

--Create a function to create an employee email address. Every employee Email follows the 
--pattern of "firstName.lastName@metroalt.com"

create function fx_getEmail
(@firstName nvarchar(255), @lastName nvarchar(255))
returns nvarchar(255)
as
begin
return lower(@firstName) + '.' + lower(@lastName) + '@metroalt.com' 
end

go
select dbo.fx_getEmail('Sophia', 'Allen')


--Create a function to determine a two week pay check of an individual employee.

create function fx_getTwoWeekSalary
(@EmployeeID int)
returns decimal(10,2)
as
begin
declare @hourlyPay decimal
set @hourlyPay = (select EmployeeHourlyPayRate from EmployeePosition where EmployeeKey = @EmployeeID)
return cast(@hourlyPay * 80 as decimal(10,2)) -- assuming 40-hour work week, times two weeks
end

select dbo.fx_getTwoWeekSalary(5)

--Create a function to determine a hourly rate for a new employee. Take difference
--between top and bottom pay for the new employees position (say driver) and then subtract
--the difference from the maximum pay. (and yes this is very arbitrary).

create function fx_newEmployeeHourlyPayRate
(@positionKey int)
returns decimal(5,2)
as
begin

declare @topPositionPay decimal 
set @topPositionPay = (Select max(EmployeeHourlyPayRate) from EmployeePosition where PositionKey = @positionKey)

declare @minPositionPay decimal
set @minPositionPay = (Select min(EmployeeHourlyPayRate) from EmployeePosition where PositionKey =@positionKey)

return cast((@topPositionPay - @minPositionPay)/2 as decimal(5,2))

end


