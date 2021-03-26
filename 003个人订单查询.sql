use FlightSystem
go

create proc person_orders @pno char(18)
as
select ono ������,a.fno �����,sno ��λ��,bprice ����۸�,fcompany ���չ�˾,ftype ����,fdate �������,
		LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,
		dbo.minute_to_hour(datediff(minute,dtime,atime)) ����ʱ��,
		dbo.ano_to_aname(dano) ��������,dterminal ������վ¥,
		dbo.ano_to_aname(aano) �������,aterminal ���ﺽվ¥
	from orders a inner join flight b on a.fno=b.fno 
	where pno=@pno
go
