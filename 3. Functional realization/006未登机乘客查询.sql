USE FlightSystem
GO

CREATE PROC passenger_havent_board
@fno CHAR(10),@fdate DATE
AS
BEGIN
SELECT p.pno,ono,pname,aboard
FROM passenger p INNER JOIN orders o
ON p.pno=o.pno
WHERE fno=@fno and fdate=@fdate and aboard='Î´µÇ»ú'
END
GO