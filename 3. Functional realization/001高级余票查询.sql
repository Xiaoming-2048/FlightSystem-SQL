USE FlightSystem
GO

CREATE PROC remain_of_flight_by_city_ranging_from_to
@dcity VARCHAR(10),@acity VARCHAR(10),@date DATE,@inf_price INT=0,@sup_price INT=999999,@sort CHAR(8)='ʱ������',@range_from TIME='00:00',@range_to TIME='23:59'
AS
BEGIN
IF @dcity NOT IN (SELECT city FROM airport)
BEGIN
	PRINT'û���Ըó���Ϊ���ĺ��� (��_��)'
END
ELSE
IF @acity NOT IN (SELECT city FROM airport)
BEGIN
	PRINT'û���Ըó���Ϊ�յ�ĺ��� (��_��)'
END
ELSE
IF NOT EXISTS (
	SELECT	fcompany ���չ�˾,flight.fno �����,LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,airport2.aname ��������,
			flight.dterminal ������վ¥,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,airport1.aname �������,flight.aterminal ���ﺽվ¥,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) ����ʱ��,ftype ����,sprice �۸�,COUNT(sno) ��Ʊ
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
)
BEGIN
	PRINT'û�в�ѯ��'+@dcity+'����'+@acity+'�ĺ�����Ϣ������ѡ��������ͨ���� ~(������)~'
END
ELSE
IF @date<'2019-12-29' OR @date>'2019-12-31'
BEGIN
	PRINT'û�в�ѯ��'+CONVERT(VARCHAR(4),YEAR(@date))+'��'+CONVERT(VARCHAR(2),MONTH(@date))+'��'+CONVERT(VARCHAR(2),DAY(@date))+'�յĺ�����Ϣ �r(�s-�t)�q'
END
ELSE
IF @inf_price>@sup_price
BEGIN
	PRINT'�۸�Χ���Ϸ�'
END
ELSE
IF((	SELECT MAX(sprice)
		FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
				INNER JOIN airport airport2 ON airport2.ano=flight.dano)
				INNER JOIN price ON flight.fno=price.fno)
				INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
		WHERE price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono=''
	)<@inf_price)
BEGIN
	PRINT'��������� ��û�в�ѯ���۸����'+CONVERT(VARCHAR(6),@inf_price)+'Ԫ�ĺ��ࣩ'
END
ELSE
IF ((	SELECT MIN(sprice)
		FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
				INNER JOIN airport airport2 ON airport2.ano=flight.dano)
				INNER JOIN price ON flight.fno=price.fno)
				INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
		WHERE price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono=''
	)>@sup_price)
BEGIN
	PRINT'����ɶ���� ��û�в�ѯ���۸�С��'+CONVERT(VARCHAR(6),@sup_price)+'Ԫ�ĺ��ࣩ'
END
ELSE
IF @range_from<'00:00' OR @range_from>'23:59' OR @range_to<'00:00' OR @range_to>'23:59' OR @range_from>@range_to
BEGIN
	PRINT'���ʱ�䷶Χ���Ϸ� ~(>_<)~'
END
ELSE
IF @sort='�۸�����'
BEGIN
	SELECT	fcompany ���չ�˾,flight.fno �����,LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,airport2.aname ��������,
			flight.dterminal ������վ¥,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,airport1.aname �������,flight.aterminal ���ﺽվ¥,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) ����ʱ��,ftype ����,sprice �۸�,COUNT(sno) ��Ʊ
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY sprice ASC
END
ELSE
IF @sort='�۸���'
BEGIN
	SELECT	fcompany ���չ�˾,flight.fno �����,LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,airport2.aname ��������,
			flight.dterminal ������վ¥,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,airport1.aname �������,flight.aterminal ���ﺽվ¥,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) ����ʱ��,ftype ����,sprice �۸�,COUNT(sno) ��Ʊ
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY sprice DESC
END
ELSE
IF @sort='ʱ�併��'
BEGIN
	SELECT	fcompany ���չ�˾,flight.fno �����,LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,airport2.aname ��������,
			flight.dterminal ������վ¥,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,airport1.aname �������,flight.aterminal ���ﺽվ¥,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) ����ʱ��,ftype ����,sprice �۸�,COUNT(sno) ��Ʊ
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY dtime DESC
END
ELSE
IF @sort='ʱ������'
BEGIN
	SELECT	fcompany ���չ�˾,flight.fno �����,LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,airport2.aname ��������,
			flight.dterminal ������վ¥,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,airport1.aname �������,flight.aterminal ���ﺽվ¥,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) ����ʱ��,ftype ����,sprice �۸�,COUNT(sno) ��Ʊ
	FROM	 (((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY dtime ASC
END
ELSE
IF @sort='��ʱ���'
BEGIN
	SELECT	fcompany ���չ�˾,flight.fno �����,LEFT(CONVERT(CHAR(20),dtime),5) ����ʱ��,airport2.aname ��������,
			flight.dterminal ������վ¥,LEFT(CONVERT(CHAR(20),atime),5) ����ʱ��,airport1.aname �������,flight.aterminal ���ﺽվ¥,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) ����ʱ��,ftype ����,sprice �۸�,COUNT(sno) ��Ʊ
	FROM	 (((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY ����ʱ�� ASC
END
ELSE
BEGIN
	PRINT'û�и�������ʽ (��_��|||)'
END
END
GO