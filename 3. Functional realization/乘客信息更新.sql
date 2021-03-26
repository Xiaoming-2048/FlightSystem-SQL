use FlightSystem
go

create proc update_passenger @pno char(18),@pname varchar(20),@sex char(2),@ptel char(11)
as
begin
if @pno in (select pno from passenger)
begin
update passenger
set pname=@pname,sex=@sex,ptel=@ptel
where pno=@pno
end
else
print('该乘客不存在')
end
go
