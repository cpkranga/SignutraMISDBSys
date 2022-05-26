CREATE procedure [dbo].[spYearlySalesUnitSMQuarterWise]
--exec [spYearlySalesUnitSMQuarterWise] 1,2019
(
	@Distributor int,
	@Year int
	
	
)
as
select h.UserName as SMName
,c.UnitCode 
,sum(isnull((case when month(a.SalesFromDate) in (1,2,3) then a.NetTotQty end),'0')) as '1-QtrQty'
,sum(isnull((case when month(a.SalesFromDate)in (1,2,3) then a.NetTotValues end),'0')) as '1-QtrVal'
,sum(isnull((case when month(a.SalesFromDate)in (4,5,6) then a.NetTotQty end),'0')) as '2-QtrQty'
,sum(isnull((case when month(a.SalesFromDate)in (4,5,6) then a.NetTotValues end),'0')) as '2-QtrVal'
,sum(isnull((case when month(a.SalesFromDate)in (7,8,9) then a.NetTotQty end),'0')) as '3-QtrQty'
,sum(isnull((case when month(a.SalesFromDate)in (7,8,9) then a.NetTotValues end),'0')) as '3-QtrVal'
,sum(isnull((case when month(a.SalesFromDate)in (10,11,12) then a.NetTotQty end),'0')) as '4-QtrQty'
,sum(isnull((case when month(a.SalesFromDate)in (10,11,12) then a.NetTotValues end),'0')) as '4-QtrVal'
,sum(a.NetTotQty) as YTDNetTotQty,sum(a.NetTotValues) as YTDNetTotValues
from dailysales as a 
inner join DistributorMst as b on b.DistributorId=a.DistributorId 
inner join ProductMst as c on c.ProductId=a.ProductId 
left outer join TownMst as d on d.TownId=a.TownId 
left outer join MainTownMst as e on e.MainTownId=d.MainTownId  
left outer join AreaMst as f on f.AreaId=e.AreaId 
left outer join RegionMst as g on g.ReagionId =f.ReagionId
inner join UserMst as h on h.UserId=a.SalesManId  
left outer join BrandMst as i on i.BrandCode=c.BrandCode
left outer join Categorymst as j on j.catcode=c.CatCode 
left outer join (select distinct AreaId,UserId,BrandCode,divicode from UserBrandAreaMatrix) as k 
on k.AreaId=f.AreaId and k.BrandCode=c.BrandCode and k.UserId=a.SalesManId 
where a.DistributorId=@Distributor
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')  -- without north and east primary sales 
and Year(salesfromdate)=@Year and year(salestodate)=@Year
group by h.UserName 
,c.UnitCode 
