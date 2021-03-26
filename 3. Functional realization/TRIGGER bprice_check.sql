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
			print ('���ڶ�����Ϊ'+rtrim(@ono)+'�Ķ�������۸����̨��Ʊ�۸�ͬ��������������ʧ��')
			rollback transaction
			return
		end
		fetch next from c_inserted into @ono,@fno,@fdate,@bprice
	end
	close c_inserted
	deallocate c_inserted
end
go

--�趨Trigger˳��
exec sp_settriggerorder 'bprice_check','first','insert'
go