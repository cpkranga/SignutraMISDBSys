CREATE procedure [dbo].spYearlySalesBrandProdMonthWise
--exec spYearlySalesBrandProdMonthWise 1,2020
(
	@Distributor int,
	@Year int
	
	
)
as
select c.BrandCode,i.BrandName 
,c.ProductCode,c.ProductName
,sum(isnull((case when month(a.SalesFromDate)=1 then a.NetTotQty end),'0')) as 'JanNetQty'
,sum(isnull((case when month(a.SalesFromDate)=1 then a.NetTotValues end),'0')) as 'JanNetVal'
,sum(isnull((case when month(a.SalesFromDate)=2 then a.NetTotQty end),'0')) as 'FebNetQty'
,sum(isnull((case when month(a.SalesFromDate)=2 then a.NetTotValues end),'0')) as 'FebNetVal'
,sum(isnull((case when month(a.SalesFromDate)=3 then a.NetTotQty end),'0')) as 'MarNetQty'
,sum(isnull((case when month(a.SalesFromDate)=3 then a.NetTotValues end),'0')) as 'MarNetVal'
,sum(isnull((case when month(a.SalesFromDate)=4 then a.NetTotQty end),'0')) as 'AprNetQty'
,sum(isnull((case when month(a.SalesFromDate)=4 then a.NetTotValues end),'0')) as 'AprNetVal'
,sum(isnull((case when month(a.SalesFromDate)=5 then a.NetTotQty end),'0')) as 'MayNetQty'
,sum(isnull((case when month(a.SalesFromDate)=5 then a.NetTotValues end),'0')) as 'MayNetVal'
,sum(isnull((case when month(a.SalesFromDate)=6 then a.NetTotQty end),'0')) as 'JunNetQty'
,sum(isnull((case when month(a.SalesFromDate)=6 then a.NetTotValues end),'0')) as 'JunNetVal'
,sum(isnull((case when month(a.SalesFromDate)=7 then a.NetTotQty end),'0')) as 'JulNetQty'
,sum(isnull((case when month(a.SalesFromDate)=7 then a.NetTotValues end),'0')) as 'JulNetVal'
,sum(isnull((case when month(a.SalesFromDate)=8 then a.NetTotQty end),'0')) as 'AugNetQty'
,sum(isnull((case when month(a.SalesFromDate)=8 then a.NetTotValues end),'0')) as 'AugNetVal'
,sum(isnull((case when month(a.SalesFromDate)=9 then a.NetTotQty end),'0')) as 'SepNetQty'
,sum(isnull((case when month(a.SalesFromDate)=9 then a.NetTotValues end),'0')) as 'SepNetVal'
,sum(isnull((case when month(a.SalesFromDate)=10 then a.NetTotQty end),'0')) as 'OctNetQty'
,sum(isnull((case when month(a.SalesFromDate)=10 then a.NetTotValues end),'0')) as 'OctNetVal'
,sum(isnull((case when month(a.SalesFromDate)=11 then a.NetTotQty end),'0')) as 'NovNetQty'
,sum(isnull((case when month(a.SalesFromDate)=11 then a.NetTotValues end),'0')) as 'NovNetVal'
,sum(isnull((case when month(a.SalesFromDate)=12 then a.NetTotQty end),'0')) as 'DecNetQty'
,sum(isnull((case when month(a.SalesFromDate)=12 then a.NetTotValues end),'0')) as 'DecNetVal'
,sum(a.NetTotQty * c.UnitFactor) as YTDNetTotQty,sum(a.NetTotValues) as YTDNetTotValues
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
group by c.BrandCode,i.BrandName 
,c.ProductCode,c.ProductName
