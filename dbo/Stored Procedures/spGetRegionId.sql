CREATE procedure [dbo].[spGetRegionId]
/*
declare @RegionId int
exec [spGetRegionId] 1,'B002',@RegionId out
select @TownId
*/
(
	@DistributorId int,
	@DistTownCode varchar(20),
	@RegionId int out
)
as 
begin

set @RegionId=isnull((select top 1 ReagionId from RegionMst where ReagionId in
(select ReagionId from AreaMst where AreaId in 
(select AreaId from MainTownMst where MainTownId in 
	(select MainTownId from TownMst where TownId in
	(select TownId from DistributorTownMatrix where DistTownCode=@DistTownCode)	)))
),0)

end
