CREATE procedure spGetProductId
/*
declare @ProductId int
exec spGetProductId 1,'MANSV200',@ProductId out
select @ProductId
*/
(
	@DistributorId int,
	@DistProductCode varchar(20),
	@ProductId int out
)
as 
begin
set @ProductId=isnull((select isnull(ProductId,0) from DistProductMatrix 
where DistId=@DistributorId
and DistProductCode=@DistProductCode),0)

end
