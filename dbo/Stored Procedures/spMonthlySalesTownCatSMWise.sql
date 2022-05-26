CREATE procedure [dbo].[spMonthlySalesTownCatSMWise]
--exec spMonthlySalesTownCatSMWise 1,2019,8
(
	@Distributor int,
	@Year int,
	@Month int
	
)
as
select a.DistributorId,b.DistributorName 
,c.CatCode,j.CatName
,a.TownId,d.TownName
,a.SalesManId,h.UserName as SalesManName 
,sum(a.NetTotQty) as NetTotQty,sum(a.NetTotValues) as NetTotValues
from dailysales as a 
inner join DistributorMst as b on b.DistributorId=a.DistributorId 
LEFT outer join ProductMst as c on c.ProductId=a.ProductId 
left outer join TownMst as d on d.TownId=a.TownId 
left outer join MainTownMst as e on e.MainTownId=d.MainTownId  
left outer join AreaMst as f on f.AreaId=e.AreaId 
left outer join RegionMst as g on g.ReagionId =f.ReagionId
left outer join UserMst as h on h.UserId=a.SalesManId  
left outer join BrandMst as i on i.BrandCode=c.BrandCode
left outer join Categorymst as j on j.catcode=c.CatCode 
left outer join (select distinct AreaId,UserId,BrandCode,divicode from UserBrandAreaMatrix) as k 
on k.AreaId=f.AreaId and k.BrandCode=c.BrandCode and k.UserId=a.SalesManId 
where a.DistributorId=@Distributor
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')  -- without north and east primary sales
and MONTH(salesfromdate)=@Month and month(salestodate)=@Month
and Year(salesfromdate)=@Year and year(salestodate)=@Year
group by a.DistributorId,b.DistributorName 
,c.CatCode,j.CatName
,a.TownId,d.TownName
,a.SalesManId,h.UserName

