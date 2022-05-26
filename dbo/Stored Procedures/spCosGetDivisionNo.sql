CREATE procedure [dbo].[spCosGetDivisionNo]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@MaterialNo int,
	@DivisionNo int out
)
as 
begin
set @DivisionNo=isnull((select top 1 isnull(DivisionNo,0) from CosMaterialMst
where MaterialNo=@MaterialNo),0)

end

