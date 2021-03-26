use FlightSystem
go

create proc info_flight_with_fno 
@fno char(10)
as
begin
if @fno in (select fno from flight)
begin
select fno �����,fcompany ���չ�˾,ftype ����,dtime ����ʱ��,b.aname ��������,
b.city ��������,dterminal ������վ¥,atime ����ʱ��,c.aname �������,c.city �������,
aterminal ���ﺽվ¥,dbo.minute_to_hour(datediff(MINUTE,dtime,atime)) ����ʱ��
from flight a inner join airport b on a.dano=b.ano
inner join airport c on a.aano=c.ano and fno=@fno
end
else
print('�ܱ�Ǹ��û��Ϊ���ҵ����������ĺ�����Ϣ')
end
go