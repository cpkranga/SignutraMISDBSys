CREATE procedure [dbo].[spCosDashboardTrgtNSale]
--exec spCosDashboardTrgtNSale 'P',2020
(
	@SalesType varchar(1),
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
from CosUserTargetMatrix
where TrgtYear= @Year
group by TrgtYear,TrgtMonth


insert into @Temp1
select Year(a.SalesFromDate) as FigureYear
,month(a.SalesFromDate) as FigureMonth
,'NetSale' as FigureType
,sum((a.NetSaleQty * c.UnitFactor)) as 'Qty'
,sum(a.NetSaleAmt) as 'Value'
from Cosdailysales as a 
inner join CosMaterialMst as c on c.MaterialNo=a.MaterialNo

where a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
and a.PlantCode!='1101'
and Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
--and a.salestodate > '30-Jun-2019'
group by Year(a.SalesFromDate)
,month(a.SalesFromDate)

select * from @Temp1
