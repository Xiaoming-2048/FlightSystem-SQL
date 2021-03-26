use FlightSystem
go

create proc delete_orders @ono char(20)
as
begin
if @ono in (select ono from orders)
begin
delete from orders
where ono=@ono
end
else
print('该订单不存在')
end
go