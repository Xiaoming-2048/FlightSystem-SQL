USE FlightSystem
GO

CREATE PROC update_info_of_boarding
@ono CHAR(20)
AS
BEGIN
IF NOT EXISTS(SELECT* FROM orders WHERE ono=@ono)
BEGIN
	PRINT'�����Ŵ��� :('
END
ELSE
IF (SELECT aboard FROM orders WHERE ono=@ono)='�ѵǻ�'
BEGIN
	PRINT '������Ϊ'+RTRIM(@ono)+'�ĳ˿��ѵǻ�,�����޸� (*^_^*)'
END
ELSE
BEGIN
	UPDATE orders
	SET aboard='�ѵǻ�'
	WHERE ono=@ono
	PRINT '�ѽ�������Ϊ'+RTRIM(@ono)+'�ĳ˿͵ǻ�״̬����Ϊ���ѵǻ��� (*^_^*)'
END
END
GO