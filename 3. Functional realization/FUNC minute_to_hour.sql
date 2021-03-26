USE FlightSystem
GO

CREATE FUNCTION minute_to_hour(@minutes INT)
RETURNS VARCHAR(16)
AS
BEGIN
	DECLARE @hour INT
	DECLARE @minute INT
	DECLARE @result VARCHAR(16)
	IF @minutes<=0
	BEGIN
		SET @minutes=@minutes+60*24
		SET @hour=@minutes/60
		SET @minute=@minutes%60
		SET @result='(+1) '+CONVERT(VARCHAR(2),@hour)+'小时'+CONVERT(CHAR(2),@minute)+'分'
	END
	ELSE
	BEGIN
		SET @hour=@minutes/60
		SET @minute=@minutes%60
		SET @result=CONVERT(VARCHAR(2),@hour)+'小时'+CONVERT(CHAR(2),@minute)+'分'
	END
RETURN @result
END