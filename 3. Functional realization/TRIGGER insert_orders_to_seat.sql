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
				print '由于订单号为'+rtrim(@ono)+'数据有误或座位已售出，此批订单创建失败'
				rollback transaction
				return
			end
		fetch next from c_inserted into @ono,@fno,@fdate,@sno
	end
	print '成功创建'+rtrim(cast(@@cursor_rows as char(20)))+'条订单，后台数据已更新'
	close c_inserted
	deallocate c_inserted
	set nocount off
end
go