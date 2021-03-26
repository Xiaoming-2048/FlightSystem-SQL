use FlightSystem
go

EXEC sp_addumpdevice 'DISK','FSBACKUP','d:\database\flightsystem_backup.bak'
go

backup database FlightSystem to FSBACKUP
go
