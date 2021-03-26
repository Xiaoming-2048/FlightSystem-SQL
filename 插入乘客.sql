use FlightSystem
go

create proc insert_passenger @pno char(18),@pname varchar(20),@sex char(2),@ptel char(11)
as
begin
if @pno in (select pno from passenger)
print('³Ë¿ÍÒÑ´æÔÚ')
else
begin
insert passenger
values
(@pno,@pname,@sex,@ptel)
end
end
go
