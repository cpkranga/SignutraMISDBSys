create procedure [dbo].[spMonthlySalesFullDetails]
--exec [spMonthlySalesFullDetails] 1,2019,0,''
(
	@Distributor int,
	@Year int,
	@Month int,
	@SalesType char(1)
	
)
as
select (case when a.SalesType='P' then 'Primary'
when a.SalesType='S' then 'Secondary'
else a.SalesType end)as SalesType
,Year(salesfromdate) as SalesYear
,month(salesfromdate) as SalesMonth
,b.DistributorName 
,f.ReagionId,g.ReagionName,e.AreaId ,f.AreaName 
,d.MainTownId,e.MainTownName
,a.TownId,d.TownName
,a.SalesManId,h.UserName as SalesManName 
,a.ProductId,c.BrandCode,i.BrandName,c.CatCode,j.CatName,c.ProductCode,c.ProductName,c.UnitCode
,(a.GrossTotQty * c.UnitFactor ) as GrossTotQtyIn400g
,a.GrossTotQty,a.GrossTotValue 
,(a.RetTotQty * c.UnitFactor ) as RetTotQtyIn400g
,a.RetTotQty
,a.RetTotValue   
,(a.NetTotQty * c.UnitFactor ) as NetTotQtyIn400g
,a.NetTotQty
,a.NetTotValues  
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
and a.SalesType =case when @SalesType='' then a.SalesType else @SalesType end
and MONTH(salesfromdate)=case when @Month=0 then MONTH(salesfromdate) else  @Month end 
and month(salestodate)=case when @Month=0 then MONTH(salestodate) else  @Month end 
and Year(salesfromdate)=@Year and year(salestodate)=@Year
