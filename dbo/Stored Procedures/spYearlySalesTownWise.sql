create procedure [dbo].spYearlySalesTownWise
--exec spYearlySalesTownWise 1,2020
(
	@Distributor int,
	@Year int
	
	
)
as
select 
d.MainTownId,e.MainTownName 

,sum(isnull((case when month(a.SalesFromDate)=1 then a.RetTotQty  end),'0')) as 'JanRetQty'
,sum(isnull((case when month(a.SalesFromDate)=1 then a.RetTotValue end),'0')) as 'JanRetVal'
,sum(isnull((case when month(a.SalesFromDate)=1 then a.NetTotQty end),'0')) as 'JanNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=1 then a.NetTotValues end),'0')) as 'JanNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=2 then a.RetTotQty end),'0')) as 'FebRetQty'
,sum(isnull((case when month(a.SalesFromDate)=2 then a.RetTotValue end),'0')) as 'FebRetVal'
,sum(isnull((case when month(a.SalesFromDate)=2 then a.NetTotQty end),'0')) as 'FebNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=2 then a.NetTotValues end),'0')) as 'FebNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=3 then a.RetTotQty end),'0')) as 'MarRetQty'
,sum(isnull((case when month(a.SalesFromDate)=3 then a.RetTotValue end),'0')) as 'MarRetVal'
,sum(isnull((case when month(a.SalesFromDate)=3 then a.NetTotQty end),'0')) as 'MarNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=3 then a.NetTotValues end),'0')) as 'MarNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=4 then a.RetTotQty end),'0')) as 'AprRetQty'
,sum(isnull((case when month(a.SalesFromDate)=4 then a.RetTotValue end),'0')) as 'AprRetVal'
,sum(isnull((case when month(a.SalesFromDate)=4 then a.NetTotQty end),'0')) as 'AprNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=4 then a.NetTotValues end),'0')) as 'AprNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=5 then a.RetTotQty end),'0')) as 'MayRetQty'
,sum(isnull((case when month(a.SalesFromDate)=5 then a.RetTotValue end),'0')) as 'MayRetVal'
,sum(isnull((case when month(a.SalesFromDate)=5 then a.NetTotQty end),'0')) as 'MayNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=5 then a.NetTotValues end),'0')) as 'MayNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=6 then a.RetTotQty end),'0')) as 'JunRetQty'
,sum(isnull((case when month(a.SalesFromDate)=6 then a.RetTotValue end),'0')) as 'JunRetVal'
,sum(isnull((case when month(a.SalesFromDate)=6 then a.NetTotQty end),'0')) as 'JunNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=6 then a.NetTotValues end),'0')) as 'JunNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=7 then a.RetTotQty end),'0')) as 'JulRetQty'
,sum(isnull((case when month(a.SalesFromDate)=7 then a.RetTotValue end),'0')) as 'JulRetVal'
,sum(isnull((case when month(a.SalesFromDate)=7 then a.NetTotQty end),'0')) as 'JulNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=7 then a.NetTotValues end),'0')) as 'JulNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=8 then a.RetTotQty end),'0')) as 'AugRetQty'
,sum(isnull((case when month(a.SalesFromDate)=8 then a.RetTotValue end),'0')) as 'AugRetVal'
,sum(isnull((case when month(a.SalesFromDate)=8 then a.NetTotQty end),'0')) as 'AugNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=8 then a.NetTotValues end),'0')) as 'AugNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=9 then a.RetTotQty end),'0')) as 'SepRetQty'
,sum(isnull((case when month(a.SalesFromDate)=9 then a.RetTotValue end),'0')) as 'SepRetVal'
,sum(isnull((case when month(a.SalesFromDate)=9 then a.NetTotQty end),'0')) as 'SepNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=9 then a.NetTotValues end),'0')) as 'SepNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=10 then a.RetTotQty end),'0')) as 'OctRetQty'
,sum(isnull((case when month(a.SalesFromDate)=10 then a.RetTotValue end),'0')) as 'OctRetVal'
,sum(isnull((case when month(a.SalesFromDate)=10 then a.NetTotQty end),'0')) as 'OctNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=10 then a.NetTotValues end),'0')) as 'OctNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=11 then a.RetTotQty end),'0')) as 'NovRetQty'
,sum(isnull((case when month(a.SalesFromDate)=11 then a.RetTotValue end),'0')) as 'NovRetVal'
,sum(isnull((case when month(a.SalesFromDate)=11 then a.NetTotQty end),'0')) as 'NovNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=11 then a.NetTotValues end),'0')) as 'NovNetSaleVal'

,sum(isnull((case when month(a.SalesFromDate)=12 then a.RetTotQty  end),'0')) as 'DecRetQty'
,sum(isnull((case when month(a.SalesFromDate)=12 then a.RetTotValue end),'0')) as 'DecRetVal'
,sum(isnull((case when month(a.SalesFromDate)=12 then a.NetTotQty end),'0')) as 'DecNetSaleQty'
,sum(isnull((case when month(a.SalesFromDate)=12 then a.NetTotValues end),'0')) as 'DecNetSaleVal'

,sum(a.RetTotQty) as YTDRetTotQty,sum(a.RetTotValue) as YTDRetTotValues
,sum(a.NetTotQty) as YTDNetSaleTotQty,sum(a.NetTotValues) as YTDNetSaleTotValues
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
group by 
d.MainTownId,e.MainTownName 
order by 
d.MainTownId,e.MainTownName 
