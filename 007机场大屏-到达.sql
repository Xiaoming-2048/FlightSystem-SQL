use FlightSystem
go

create proc airport_screen_arrival @ano char(10),@fdate datetime
as
begin
select status.fno 航班号,left(convert(varchar(100),status.atime),5) 计划到达,left(convert(varchar(100),status.atime_real),5) 实际到达,flight.aterminal 航站楼,
airport.city 出发城市,aname 出发机场,rtrim(astatus)+astatus_time 到达状态
from status inner join flight on status.fno=flight.fno inner join airport on airport.ano=flight.dano
where flight.aano=@ano and status.fdate=@fdate
order by flight.atime asc
end
go