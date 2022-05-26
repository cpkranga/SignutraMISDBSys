

CREATE procedure [dbo].[spCosDashboardBrand]
--exec [spCosDashboardBrand] 'P',8,2020
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



if OBJECT_ID('tempdb..#temp1') is not null
DROP TABLE #temp1
create table #temp1
(
	RptDiviCode varchar(3),
	BrandCode varchar(2),
	--BrandName varchar(100),
	PrevYtdQty int,
	PrevYtdVal decimal(15,2),
	PrevMtdQty int,
	PrevMtdVal decimal(15,2),
	PrevWtdQty int,
	PrevWtdVal decimal(15,2),
	YtdQty int,
	YtdVal decimal(15,2),
	MtdQty int,
	MtdVal decimal(15,2),
	WtdQty int,
	WtdVal decimal(15,2)
	--,GrowthYtdVal float

	

)
insert into #temp1
select d.RptDivisionCode
--,i.RptBrandCode
,(case when (d.DivisionNo=1 and i.RptBrandCode='00' and d.RptDivisionCode='CCD')
  then '##'
  WHEN  (d.DivisionNo=2 and d.RptDivisionCode='CCD')
  then '#1' else i.RptBrandCode end) as BrandCode
  
  --,(case when (d.DivisionNo=1 and i.RptBrandCode='00' and d.RptDivisionCode='CCD')
  --then 'REVLON CLASSIC'
  --WHEN  (d.DivisionNo=2 and d.RptDivisionCode='CCD')
  --then 'STREET WEAR' else isnull(i.BrandName,'#Others') end) as BrandName
  
  
  --isnull(e.BrandName,'#Others') as BrandName

,sum(isnull((case when (year(a.DocDate) = @Year-1 and a.DocDate<=@lastYearSyncDt) then (a.NetSaleQty ) end),'0')) as 'PrevYtdQty'
,sum(isnull((case when (year(a.DocDate) = @Year-1 and a.DocDate<=@lastYearSyncDt)then a.NetSaleAmt end),'0')) as 'PrevYtdVal'
,sum(isnull((case when (month(a.DocDate) = @Month and year(a.DocDate) = @Year-1 and a.DocDate<=@lastYearSyncDt) then (a.NetSaleQty ) end),'0')) as 'PrevYMtdQty'
,sum(isnull((case when (month(a.DocDate) = @Month and year(a.DocDate) = @Year-1 and a.DocDate<=@lastYearSyncDt)then a.NetSaleAmt end),'0')) as 'PrevYMtdVal'
,sum(isnull((case when (a.DocDate >= dateadd("DD",-7,@lastYearSyncDt) and month(a.DocDate) = @Month and year(a.DocDate) = @Year-1 and a.DocDate<=@lastYearSyncDt) then (a.NetSaleQty ) end),'0')) as 'PrevYWtdQty'
,sum(isnull((case when (a.DocDate >= dateadd("DD",-7,@lastYearSyncDt) and month(a.DocDate) = @Month and year(a.DocDate) = @Year-1 and a.DocDate<=@lastYearSyncDt)then a.NetSaleAmt end),'0')) as 'PrevYWtdVal'


,sum(isnull((case when (year(a.DocDate) = @Year and a.DocDate<=@SyncDt) then (a.NetSaleQty ) end),'0')) as 'YtdQty'
,sum(isnull((case when (year(a.DocDate) = @Year and a.DocDate<=@SyncDt)then a.NetSaleAmt end),'0')) as 'YtdVal'
,sum(isnull((case when (month(a.DocDate) = @Month and year(a.DocDate) = @Year and a.DocDate<=@SyncDt) then (a.NetSaleQty ) end),'0')) as 'MtdQty'
,sum(isnull((case when (month(a.DocDate) = @Month and year(a.DocDate) = @Year and a.DocDate<=@SyncDt)then a.NetSaleAmt end),'0')) as 'MtdVal'
,sum(isnull((case when (a.DocDate >= dateadd("DD",-7,@SyncDt) and month(a.DocDate) = @Month and year(a.DocDate) = @Year and a.DocDate<=@SyncDt) then (a.NetSaleQty ) end),'0')) as 'WtdQty'
,sum(isnull((case when (a.DocDate >= dateadd("DD",-7,@SyncDt) and month(a.DocDate) = @Month and year(a.DocDate) = @Year and a.DocDate<=@SyncDt)then a.NetSaleAmt end),'0')) as 'WtdVal'

--,0 as GrowthYtdVal

from CosDailysales as a 
left outer join CosMaterialmst as c on c.materialno=a.materialno
left outer join CosDivisionMst as d on d.DivisionNo=c.DivisionNo
left outer join CosMaterialBrandMst as i on i.BrandCode=c.RptBrandCode
--left outer join CosCategoryMst as j on j.CatCode=c.CatCode
--left outer join (select distinct RptBrandCode,BrandName from CosMaterialBrandMst) as e 
--on e.RptBrandCode=c.BrandCode
where 
(Year(a.DocDate)=@Year and year(a.DocDate)=@Year
or Year(a.DocDate)=@Year-1 and year(a.DocDate)=@Year-1)
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
group by d.RptDivisionCode,

(case when (d.DivisionNo=1 and i.RptBrandCode='00' and d.RptDivisionCode='CCD')
  then '##'
  WHEN  (d.DivisionNo=2 and d.RptDivisionCode='CCD')
  then '#1' else i.RptBrandCode end)
--,  (case when (d.DivisionNo=1 and i.RptBrandCode='00' and d.RptDivisionCode='CCD')
--  then 'REVLON CLASSIC'
--  WHEN  (d.DivisionNo=2 and d.RptDivisionCode='CCD')
--  then 'STREET WEAR' else isnull(i.BrandName,'#Others') end)
--,isnull(e.BrandName,'#Others')

--update #temp1 set GrowthYtdQty=(cast(YtdQty as float)-cast(PrevYtdQty as float))/ cast(PrevYtdQty as float)*100 where PrevYtdQty!=0
--update #temp1 set GrowthYtdVal=(cast(YtdVal as float)-cast(PrevYtdVal as float))/ cast(PrevYtdVal as float) where PrevYtdVal!=0

select b.BrandName,b.srno,#temp1.* 
,(case when PrevYtdQty=0 then 0 else round(((((cast(YtdQty as float)-cast(PrevYtdQty as float))/cast(PrevYtdQty as float)))*100),2) end) as GrowthYtdQty
,(case when PrevYtdVal=0 then 0 else round((((cast(YtdVal as float)-cast(PrevYtdVal as float))/cast(PrevYtdVal as float))*100),2) end) as GrowthYtdVal

,(case when PrevMtdQty=0 then 0 else round((((cast(MtdQty as float)-cast(PrevMtdQty as float))/cast(PrevMtdQty as float))*100),2) end) as GrowthMtdQty
,(case when PrevMtdVal=0 then 0 else round((((cast(MtdVal as float)-cast(PrevMtdVal as float))/cast(PrevMtdVal as float))*100),2) end) as GrowthMtdVal

,(case when PrevWtdQty=0 then 0 else round((((cast(WtdQty as float)-cast(PrevWtdQty as float))/cast(PrevWtdQty as float))*100),2) end) as GrowthWtdQty
,(case when PrevWtdVal=0 then 0 else round((((cast(WtdVal as float)-cast(PrevWtdVal as float))/cast(PrevWtdVal as float))*100),2) end) as GrowthWtdVal


from #temp1 left outer join CosMaterialBrandMst as b on b.BrandCode=#temp1.BrandCode

order by b.srno

--select * from #temp1