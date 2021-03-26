use FlightSystem
go

create function ano_to_aname(@ano char(3))
returns varchar(20)
as
begin 
	return(select aname from airport where ano=@ano)
end
go
