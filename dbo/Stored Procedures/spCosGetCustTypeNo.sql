create procedure [dbo].[spCosGetCustTypeNo]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@CustomerNo int,
	@CustTypeNo int out
)
as 
begin
set @CustTypeNo=isnull((select isnull(TypeNo,0) from coscustomermst 
where CustomerNo=@CustomerNo),0)

end


--select * from coscustomermst
