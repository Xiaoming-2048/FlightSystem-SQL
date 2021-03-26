use FlightSystem
go

create proc airport_screen_departure @ano char(10),@fdate datetime
as
begin
select status.fno 航班号,left(convert(varchar(100),status.dtime),5) 计划出发,left(convert(varchar(100),status.dtime),5) 实际出发,flight.dterminal 航站楼,
airport.city 到达城市,aname 到达机场,rtrim(dstatus)+dstatus_time 出发状态
from status inner join flight on status.fno=flight.fno inner join airport on airport.ano=flight.aano
where flight.dano=@ano and status.fdate=@fdate
order by flight.dtime asc
end
go

