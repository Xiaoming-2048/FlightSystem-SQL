use FlightSystem
go

create proc airport_screen_arrival @ano char(10),@fdate datetime
as
begin
select status.fno �����,left(convert(varchar(100),status.atime),5) �ƻ�����,left(convert(varchar(100),status.atime_real),5) ʵ�ʵ���,flight.aterminal ��վ¥,
airport.city ��������,aname ��������,rtrim(astatus)+astatus_time ����״̬
from status inner join flight on status.fno=flight.fno inner join airport on airport.ano=flight.dano
where flight.aano=@ano and status.fdate=@fdate
order by flight.atime asc
end
go