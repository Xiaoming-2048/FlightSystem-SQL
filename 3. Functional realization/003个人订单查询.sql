use FlightSystem
go

create proc person_orders @pno char(18)
as
select ono 订单号,a.fno 航班号,sno 座位号,bprice 购买价格,fcompany 航空公司,ftype 机型,fdate 起飞日期,
		LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,
		dbo.minute_to_hour(datediff(minute,dtime,atime)) 飞行时间,
		dbo.ano_to_aname(dano) 出发机场,dterminal 出发航站楼,
		dbo.ano_to_aname(aano) 到达机场,aterminal 到达航站楼
	from orders a inner join flight b on a.fno=b.fno 
	where pno=@pno
go
