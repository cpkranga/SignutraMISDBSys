CREATE procedure [dbo].[spDashboardBrandMonthWise]
--exec spDashboardBrandMonthWise 1,2019
(
	@Distributor int,
	@Year int
)
as
select c.BrandCode,i.BrandName 
,Year(a.SalesFromDate) as 'SalesYear'
,month(a.SalesFromDate) as 'SalesMonth'
,sum(a.NetTotQty * c.UnitFactor) as 'TotNetQty'
,sum(a.NetTotValues) as 'TotNetVal'
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
left outer join (select distinct UserId,divicode from UserBrandAreaMatrix) as k
on k.UserId=a.SalesManId  
where a.DistributorId=@Distributor 
and Year(salesfromdate)=@Year and year(salestodate)=@Year
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')
group by c.BrandCode,i.BrandName 
,Year(a.SalesFromDate) 
,month(a.SalesFromDate)
