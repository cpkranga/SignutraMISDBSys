CREATE procedure [dbo].[spSalesManMapDetails]
--exec [spSalesManMapDetails] 0
(
	@UserId int
	
)
as

select distinct
b.ReagionId,c.ReagionName  
,b.AreaId,b.AreaName 
,d.MainTownId,d.MainTownName
,e.TownId,e.TownName  
,a.DiviCode,a.UserId,h.UserName  
from UserBrandAreaMatrix as a
left outer join AreaMst as b on b.AreaId=a.AreaId 
left outer join RegionMst as c on c.ReagionId =b.ReagionId
left outer join MainTownMst as d on d.AreaId=b.AreaId 
left outer join TownMst as e on e.MainTownId=d.MainTownId 
left outer join UserMst as h on h.UserId=a.UserId 
where a.UserId=case when @UserId=0 then a.UserId else @UserId end 



