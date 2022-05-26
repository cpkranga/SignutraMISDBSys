CREATE procedure [dbo].[spDashboardTrgtNSale]
--exec spDashboardTrgtNSale 1,2019
(
	@Distributor int,
	@Year int
	
	
)
as



declare @Temp1 table
(
	FigureYear int,
	FigureMonth int,
	FigureType varchar(50),
	Qty decimal(12,2),
	Value decimal(12,2)
)
insert into @Temp1
select 
TrgtYear as  FigureYear
,TrgtMonth as FigureMonth
,'Target' as FigureType
,SUM(MonthlyTrgtQty) as Qty
,SUM(MonthlyTrgtValue) as Value
from UserTargetMatrix
where DistributorId=@Distributor
and TrgtYear= @Year
group by TrgtYear,TrgtMonth


insert into @Temp1
select Year(a.SalesFromDate) as FigureYear
,month(a.SalesFromDate) as FigureMonth
,'NetSale' as FigureType
,sum((a.NetTotQty * c.UnitFactor)) as 'Qty'
,sum(a.NetTotValues) as 'Value'
from dailysales as a 
inner join ProductMst as c on c.ProductId=a.ProductId 

where a.DistributorId=@Distributor 
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')
and Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and a.salestodate > '30-Jun-2019'
group by Year(a.SalesFromDate)
,month(a.SalesFromDate)

select * from @Temp1
