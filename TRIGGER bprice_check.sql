use FlightSystem
go
create trigger bprice_check on orders
for insert
as
begin
	declare c_inserted cursor for select ono,fno,fdate,bprice from inserted
	declare @ono char(20),@fno char(10),@fdate date,@bprice int
	open c_inserted
	fetch next from c_inserted into @ono,@fno,@fdate,@bprice
	while @@fetch_status=0
	begin
		if @bprice!=(select sprice from price where fno=@fno and fdate=@fdate)
		begin
			print ('由于订单号为'+rtrim(@ono)+'的订单购买价格与后台机票价格不同，本批订单插入失败')
			rollback transaction
			return
		end
		fetch next from c_inserted into @ono,@fno,@fdate,@bprice
	end
	close c_inserted
	deallocate c_inserted
end
go

--设定Trigger顺序
exec sp_settriggerorder 'bprice_check','first','insert'
go