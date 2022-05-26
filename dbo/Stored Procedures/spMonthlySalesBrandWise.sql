CREATE procedure [dbo].[spMonthlySalesBrandWise]
--exec spMonthlySalesBrandWise 1,2019,2
(
	@Distributor int,
	@Year int,
	@Month int
	
)
as
select a.DistributorId,b.DistributorName 
,c.BrandCode,i.BrandName
,sum(a.NetTotQty) as NetTotQty,sum(a.NetTotValues) as NetTotValues
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
where a.DistributorId=@Distributor 
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')
and MONTH(salesfromdate)=@Month and month(salestodate)=@Month
and Year(salesfromdate)=@Year and year(salestodate)=@Year
group by a.DistributorId,b.DistributorName 
,c.BrandCode,i.BrandName
