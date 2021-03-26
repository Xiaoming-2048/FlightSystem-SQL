use FlightSystem
go
create trigger insert_orders_to_seat
	on orders for insert
as
begin
	set nocount on
	declare @ono char(20),@fno char(10),@fdate date,@sno char(3)
	declare c_inserted cursor forward_only static
		for select ono,fno,fdate,sno from inserted
	open c_inserted
	fetch next from c_inserted into @ono,@fno,@fdate,@sno
	while(@@fetch_status=0)
	begin
		if (select ono from seat where fno=@fno and fdate=@fdate and sno=@sno)=''
			update seat set ono=@ono where fno=@fno and fdate=@fdate and sno=@sno
		else
			begin
				print '���ڶ�����Ϊ'+rtrim(@ono)+'�����������λ���۳���������������ʧ��'
				rollback transaction
				return
			end
		fetch next from c_inserted into @ono,@fno,@fdate,@sno
	end
	print '�ɹ�����'+rtrim(cast(@@cursor_rows as char(20)))+'����������̨�����Ѹ���'
	close c_inserted
	deallocate c_inserted
	set nocount off
end
go