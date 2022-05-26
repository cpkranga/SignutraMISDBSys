create procedure [dbo].[spCosGetTownNo]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@CustomerNo int,
	@TownNo int out
)
as 
begin
set @TownNo=isnull((select isnull(TownNo,0) from coscustomermst 
where CustomerNo=@CustomerNo),0)

end


--select * from coscustomermst
