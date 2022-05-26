CREATE procedure [dbo].[spCosGetSalesType]
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@PlantCode varchar(4),
	@SalesType varchar(1) out
)
as 
begin
set @SalesType=isnull((select top 1 isnull(plantsalestypecode,'0') from cosplantmst 
where PlantCode=@PlantCode),'0')

end

