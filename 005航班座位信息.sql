use FlightSystem
go

create proc seat_details @fno char(10),@fdate date
as
begin
	if not exists(select 1 from seat where fno=@fno and fdate=@fdate)
	print 'û�ҵ���Ӧ���ڵĺ���'
	else
	begin
		declare @sno char(3),@ono char(20),@msg varchar(50)
		print ('����'+cast(@fdate as varchar(10))+'	����'+@fno+'	����λ�۳���Ϣ���£�')
		print ('��λ��'+'			�۳����')
		declare c_seat cursor forward_only static
		for select sno,ono from seat where fno=@fno and fdate=@fdate
		open c_seat
		fetch next from c_seat into @sno,@ono
		while(@@FETCH_STATUS=0)
		begin
			if @ono=''
			print (@sno+'				δ�۳�')
			else
			print (@sno+'				���۳�')
			fetch next from c_seat into @sno,@ono
		end
		close c_seat
		deallocate c_seat
	end
end
go