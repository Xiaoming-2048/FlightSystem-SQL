use FlightSystem
go

create proc insert_orders @ono char(20),@fno char(10),@fdate date,@sno char(3),@bprice int,@pno char(18)
as
begin
if @ono not in (select ono from orders)
begin
insert orders 
(ono,fno,fdate,sno,bprice,pno)
values
(@ono,@fno,@fdate,@sno,@bprice,@pno)
end
else
begin
print('订单号已经存在')
end
end
go