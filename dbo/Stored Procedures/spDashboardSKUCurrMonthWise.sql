CREATE procedure [dbo].[spDashboardSKUCurrMonthWise]
--exec [spDashboardSKUCurrMonthWise] 1,6,2019
(
	@Distributor int,
	@Month int ,
	@Year int
	
	
)
as



select c.ProductName 
,c.UnitCode
,l.CurMthAllPrdNetTotQty
,m.CurYtdAllPrdNetTotQty

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.NetTotQty ) end),'0')) as 'CurMthNetQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetTotValues end),'0')) as 'CurMthNetVal'

,(case when (isnull(l.CurMthAllPrdNetTotQty,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetTotQty end),'0')))*100/isnull(l.CurMthAllPrdNetTotQty,0)) end) as 'Sales(%)TotMthQtySls'
,sum(a.NetTotQty) as YTDNetTotQty
,sum(a.NetTotValues) as YTDNetTotValues
,(case when (isnull(m.CurYtdAllPrdNetTotQty,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetTotQty ))*100/isnull(m.CurYtdAllPrdNetTotQty,0)) end )as 'Sales(%)TotYtdQtySls'
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
left outer join 
(select DistributorId,sum(NetTotQty) as CurMthAllPrdNetTotQty
 from dailysales
  where DistributorId=@Distributor 
and Year(salesfromdate)=@Year and year(salestodate)=@Year
and Month(salesfromdate)=@Month
and (SalesType+':'+cast(RegionId as varchar(10)) !='P:4')
group by DistributorId) as l 
on l.DistributorId=a.DistributorId 

left outer join 
(select DistributorId,sum(NetTotQty) as CurYtdAllPrdNetTotQty
 from dailysales 
 where DistributorId=@Distributor 
and Year(salesfromdate)=@Year and year(salestodate)=@Year
and (SalesType+':'+cast(RegionId as varchar(10)) !='P:4')
group by DistributorId) as m 
on m.DistributorId=a.DistributorId  


where a.DistributorId=@Distributor 
and Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')
group by c.ProductName
,c.UnitCode
,l.CurMthAllPrdNetTotQty
,m.CurYtdAllPrdNetTotQty

order by c.ProductName 