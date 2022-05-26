CREATE procedure [dbo].[spCosGetMaterialGroupCode]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@MaterialNo int,
	@MaterialGroupCode varchar(2) out
)
as 
begin
set @MaterialGroupCode=isnull((select top 1 isnull(GroupCode,'0') from CosMaterialMst 
where MaterialNo=@MaterialNo),'0')

end

--select * from coscategorymst