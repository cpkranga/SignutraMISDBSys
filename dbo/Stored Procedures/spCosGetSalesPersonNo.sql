create procedure [dbo].[spCosGetSalesPersonNo]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@CustomerNo int,
	@SalesPersonNo int out
)
as 
begin
set @SalesPersonNo=isnull((select isnull(SalesPersonNo,0) from coscustomermst 
where CustomerNo=@CustomerNo),0)

end


--select * from coscustomermst
