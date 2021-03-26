use FlightSystem
go

create proc airport_screen_departure @ano char(10),@fdate datetime
as
begin
select status.fno �����,left(convert(varchar(100),status.dtime),5) �ƻ�����,left(convert(varchar(100),status.dtime),5) ʵ�ʳ���,flight.dterminal ��վ¥,
airport.city �������,aname �������,rtrim(dstatus)+dstatus_time ����״̬
from status inner join flight on status.fno=flight.fno inner join airport on airport.ano=flight.aano
where flight.dano=@ano and status.fdate=@fdate
order by flight.dtime asc
end
go

