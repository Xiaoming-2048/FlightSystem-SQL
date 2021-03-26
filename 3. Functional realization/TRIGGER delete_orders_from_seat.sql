use FlightSystem
go
create trigger delete_orders_from_seat
	on orders for delete
as
begin
	set nocount on
	declare @fno char(10),@fdate date,@sno char(3)
	declare c_deleted cursor forward_only static
		for select fno,fdate,sno from deleted
	open c_deleted
	fetch next from c_deleted into @fno,@fdate,@sno
	while(@@fetch_status=0)
	begin
		update seat set ono='' where fno=@fno and fdate=@fdate and sno=@sno
		fetch next from c_deleted into @fno,@fdate,@sno
	end
	print '成功删除'+rtrim(cast(@@cursor_rows as char(20)))+'条订单,后台数据已更新'
	close c_deleted
	deallocate c_deleted
	set nocount off
end
go