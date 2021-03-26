USE FlightSystem
GO

CREATE TRIGGER forbid_updating_pno
ON passenger
FOR UPDATE
AS
BEGIN
IF NOT EXISTS
(
SELECT*
FROM inserted
WHERE inserted.pno
IN (SELECT pno
FROM deleted)
)
BEGIN
	PRINT '禁止修改乘客证件号码 (>_<)'
	ROLLBACK TRANSACTION
END
END