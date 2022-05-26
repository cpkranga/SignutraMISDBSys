create procedure [dbo].[spCosGetCustGroupNo]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@CustomerNo int,
	@CustGroupNo int out
)
as 
begin
set @CustGroupNo=isnull((select isnull(GroupNo,0) from coscustomermst 
where CustomerNo=@CustomerNo),0)

end


--select * from coscustomermst
