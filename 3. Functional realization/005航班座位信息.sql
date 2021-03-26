use FlightSystem
go

create proc seat_details @fno char(10),@fdate date
as
begin
	if not exists(select 1 from seat where fno=@fno and fdate=@fdate)
	print '没找到对应日期的航班'
	else
	begin
		declare @sno char(3),@ono char(20),@msg varchar(50)
		print ('日期'+cast(@fdate as varchar(10))+'	航班'+@fno+'	的座位售出信息如下：')
		print ('座位号'+'			售出情况')
		declare c_seat cursor forward_only static
		for select sno,ono from seat where fno=@fno and fdate=@fdate
		open c_seat
		fetch next from c_seat into @sno,@ono
		while(@@FETCH_STATUS=0)
		begin
			if @ono=''
			print (@sno+'				未售出')
			else
			print (@sno+'				已售出')
			fetch next from c_seat into @sno,@ono
		end
		close c_seat
		deallocate c_seat
	end
end
go