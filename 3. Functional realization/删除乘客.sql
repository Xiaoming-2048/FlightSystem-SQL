use FlightSystem
go

create proc delete_passenger @pno char(18)
as 
begin
if @pno in (select pno from passenger)
begin
delete from passenger
where pno=@pno
end
else
print('该乘客不存在')
end
go