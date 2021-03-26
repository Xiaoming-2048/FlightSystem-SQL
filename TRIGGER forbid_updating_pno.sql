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
	PRINT '��ֹ�޸ĳ˿�֤������ (>_<)'
	ROLLBACK TRANSACTION
END
END