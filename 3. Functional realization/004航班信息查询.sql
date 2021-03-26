use FlightSystem
go

create proc info_flight_with_fno 
@fno char(10)
as
begin
if @fno in (select fno from flight)
begin
select fno 航班号,fcompany 航空公司,ftype 机型,dtime 出发时间,b.aname 出发机场,
b.city 出发城市,dterminal 出发航站楼,atime 到达时间,c.aname 到达机场,c.city 到达城市,
aterminal 到达航站楼,dbo.minute_to_hour(datediff(MINUTE,dtime,atime)) 飞行时间
from flight a inner join airport b on a.dano=b.ano
inner join airport c on a.aano=c.ano and fno=@fno
end
else
print('很抱歉，没有为您找到符合条件的航班信息')
end
go