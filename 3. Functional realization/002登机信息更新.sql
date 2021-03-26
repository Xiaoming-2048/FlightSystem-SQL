USE FlightSystem
GO

CREATE PROC update_info_of_boarding
@ono CHAR(20)
AS
BEGIN
IF NOT EXISTS(SELECT* FROM orders WHERE ono=@ono)
BEGIN
	PRINT'订单号错误 :('
END
ELSE
IF (SELECT aboard FROM orders WHERE ono=@ono)='已登机'
BEGIN
	PRINT '订单号为'+RTRIM(@ono)+'的乘客已登机,无需修改 (*^_^*)'
END
ELSE
BEGIN
	UPDATE orders
	SET aboard='已登机'
	WHERE ono=@ono
	PRINT '已将订单号为'+RTRIM(@ono)+'的乘客登机状态更改为“已登机” (*^_^*)'
END
END
GO