USE FlightSystem
GO

CREATE PROC remain_of_flight_by_city_ranging_from_to
@dcity VARCHAR(10),@acity VARCHAR(10),@date DATE,@inf_price INT=0,@sup_price INT=999999,@sort CHAR(8)='时间升序',@range_from TIME='00:00',@range_to TIME='23:59'
AS
BEGIN
IF @dcity NOT IN (SELECT city FROM airport)
BEGIN
	PRINT'没有以该城市为起点的航班 (＠_＠)'
END
ELSE
IF @acity NOT IN (SELECT city FROM airport)
BEGIN
	PRINT'没有以该城市为终点的航班 (＠_＠)'
END
ELSE
IF NOT EXISTS (
	SELECT	fcompany 航空公司,flight.fno 航班号,LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,airport2.aname 出发机场,
			flight.dterminal 出发航站楼,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,airport1.aname 到达机场,flight.aterminal 到达航站楼,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) 飞行时间,ftype 机型,sprice 价格,COUNT(sno) 余票
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
)
BEGIN
	PRINT'没有查询到'+@dcity+'飞往'+@acity+'的航班信息，请您选择其他交通工具 ~(￣▽￣)~'
END
ELSE
IF @date<'2019-12-29' OR @date>'2019-12-31'
BEGIN
	PRINT'没有查询到'+CONVERT(VARCHAR(4),YEAR(@date))+'年'+CONVERT(VARCHAR(2),MONTH(@date))+'月'+CONVERT(VARCHAR(2),DAY(@date))+'日的航班信息 ╮(╯-╰)╭'
END
ELSE
IF @inf_price>@sup_price
BEGIN
	PRINT'价格范围不合法'
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
	PRINT'土豪求包养 （没有查询到价格大于'+CONVERT(VARCHAR(6),@inf_price)+'元的航班）'
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
	PRINT'梦里啥都有 （没有查询到价格小于'+CONVERT(VARCHAR(6),@sup_price)+'元的航班）'
END
ELSE
IF @range_from<'00:00' OR @range_from>'23:59' OR @range_to<'00:00' OR @range_to>'23:59' OR @range_from>@range_to
BEGIN
	PRINT'起飞时间范围不合法 ~(>_<)~'
END
ELSE
IF @sort='价格升序'
BEGIN
	SELECT	fcompany 航空公司,flight.fno 航班号,LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,airport2.aname 出发机场,
			flight.dterminal 出发航站楼,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,airport1.aname 到达机场,flight.aterminal 到达航站楼,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) 飞行时间,ftype 机型,sprice 价格,COUNT(sno) 余票
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY sprice ASC
END
ELSE
IF @sort='价格降序'
BEGIN
	SELECT	fcompany 航空公司,flight.fno 航班号,LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,airport2.aname 出发机场,
			flight.dterminal 出发航站楼,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,airport1.aname 到达机场,flight.aterminal 到达航站楼,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) 飞行时间,ftype 机型,sprice 价格,COUNT(sno) 余票
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY sprice DESC
END
ELSE
IF @sort='时间降序'
BEGIN
	SELECT	fcompany 航空公司,flight.fno 航班号,LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,airport2.aname 出发机场,
			flight.dterminal 出发航站楼,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,airport1.aname 到达机场,flight.aterminal 到达航站楼,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) 飞行时间,ftype 机型,sprice 价格,COUNT(sno) 余票
	FROM	(((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY dtime DESC
END
ELSE
IF @sort='时间升序'
BEGIN
	SELECT	fcompany 航空公司,flight.fno 航班号,LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,airport2.aname 出发机场,
			flight.dterminal 出发航站楼,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,airport1.aname 到达机场,flight.aterminal 到达航站楼,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) 飞行时间,ftype 机型,sprice 价格,COUNT(sno) 余票
	FROM	 (((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY dtime ASC
END
ELSE
IF @sort='耗时最短'
BEGIN
	SELECT	fcompany 航空公司,flight.fno 航班号,LEFT(CONVERT(CHAR(20),dtime),5) 出发时间,airport2.aname 出发机场,
			flight.dterminal 出发航站楼,LEFT(CONVERT(CHAR(20),atime),5) 到达时间,airport1.aname 到达机场,flight.aterminal 到达航站楼,
			dbo.minute_to_hour(DATEDIFF(MINUTE,dtime,atime)) 飞行时间,ftype 机型,sprice 价格,COUNT(sno) 余票
	FROM	 (((airport airport1 INNER JOIN flight ON airport1.ano=flight.aano)
			INNER JOIN airport airport2 ON airport2.ano=flight.dano)
			INNER JOIN price ON flight.fno=price.fno)
			INNER JOIN seat ON flight.fno=seat.fno and price.fdate=seat.fdate
	GROUP BY fcompany,flight.fno,dtime,airport2.aname,flight.dterminal,atime,airport1.aname,flight.aterminal,ftype,sprice,price.fdate,airport2.city,airport1.city,ono
	HAVING price.fdate=@date AND airport2.city=@dcity AND airport1.city=@acity AND ono='' AND dtime>=@range_from AND dtime<=@range_to
	ORDER BY 飞行时间 ASC
END
ELSE
BEGIN
	PRINT'没有该种排序方式 (￣_￣|||)'
END
END
GO