

CREATE procedure [dbo].[spCosDashboardBrandMonthWisePCD]
--exec [spCosDashboardBrandMonthWisePCD] 'P',7,2020
(
	@SalesType varchar(1),
	@Month int ,
	@Year int
)
as


declare @SyncDt date
declare @lastYearSyncDt date
--set @lastSyncDt='01-Jan-2020'
--select DATEADD("YYYY",-1,@lastSyncDt)
set @SyncDt=(select top 1 DocDate from CosDailySales where MONTH(DocDate)=@Month and YEAR(docdate)=@Year order by DocDate desc)
if month(dateadd("DD",1,@SyncDt)) != MONTH(@SyncDt)
begin 
	set @lastYearSyncDt=DATEADD("YYYY",-1,@SyncDt) 
	set @lastYearSyncDt=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@lastYearSyncDt)+1,0)) 
end 
else 
begin set @lastYearSyncDt=DATEADD("YYYY",-1,@SyncDt) end
--SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,'2014-08-12')+1,0))



--if OBJECT_ID('tempdb..#temp1') is not null
--DROP TABLE #temp1
--create table #temp1
--(
--	RptDiviCode varchar(3),
--	--BrandCode varchar(2),
--	--BrandName varchar(100),
--	PrevYVal1 decimal(15,2),
--	PrevYVal2 decimal(15,2),
--	PrevYVal3 decimal(15,2),
--	PrevYVal4 decimal(15,2),
--	PrevYVal5 decimal(15,2),
--	PrevYVal6 decimal(15,2),
--	PrevYVal7 decimal(15,2),
--	PrevYVal8 decimal(15,2),
--	PrevYVal9 decimal(15,2),
--	PrevYVal10 decimal(15,2),
--	PrevYVal11 decimal(15,2),
--	PrevYVal12 decimal(15,2),

--	YVal1 decimal(15,2),
--	YVal2 decimal(15,2),
--	YVal3 decimal(15,2),
--	YVal4 decimal(15,2),
--	YVal5 decimal(15,2),
--	YVal6 decimal(15,2),
--	YVal7 decimal(15,2),
--	YVal8 decimal(15,2),
--	YVal9 decimal(15,2),
--	YVal10 decimal(15,2),
--	YVal11 decimal(15,2),
--	YVal12 decimal(15,2)

--	--,GrowthYtdVal float

	

--)
--insert into #temp1
select d.RptDivisionCode
--,i.RptBrandCode as BrandCode
--,isnull(e.BrandName,'#Others') as BrandName

,Year(a.DocDate) as 'SalesYear'
,month(a.DocDate) as 'SalesMonth'
,sum(a.NetSaleAmt) as 'TotNetVal'

from CosDailysales as a 
inner join CosMaterialmst as c on c.materialno=a.materialno
left outer join CosDivisionMst as d on d.DivisionNo=c.DivisionNo
left outer join CosMaterialBrandMst as i on i.BrandCode=c.RptBrandCode
left outer join (select distinct RptBrandCode,BrandName from CosMaterialBrandMst) as e 
on e.RptBrandCode=c.BrandCode
where 
(Year(a.DocDate)=@Year and year(a.DocDate)=@Year
or Year(a.DocDate)=@Year-1 and year(a.DocDate)=@Year-1)
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
and d.RptDivisionCode='PCD'
group by d.RptDivisionCode
,Year(a.DocDate)
,month(a.DocDate)

--,i.RptBrandCode,isnull(e.BrandName,'#Others')

--update #temp1 set GrowthYtdQty=(cast(YtdQty as float)-cast(PrevYtdQty as float))/ cast(PrevYtdQty as float)*100 where PrevYtdQty!=0
--update #temp1 set GrowthYtdVal=(cast(YtdVal as float)-cast(PrevYtdVal as float))/ cast(PrevYtdVal as float) where PrevYtdVal!=0

--select *

--from #temp1 
--where RptDiviCode='PCD'
----order by BrandName desc

----select * from #temp1