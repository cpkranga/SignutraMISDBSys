

CREATE procedure [dbo].[spCosDashboardChannelWise]
--exec [spCosDashboardChannelWise] 'P',2,2022
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
	--RptDiviCode varchar(3),
	CustomerNo int,
	--CustomerName varchar(100),
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

	

)
insert into #temp1
select i.RptCustomerNo as CustomerNo --,isnull(f.CustomerName,'#Others') as CustomerName

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



from CosDailysales as a 
left outer join CosMaterialmst as c on c.materialno=a.materialno
left outer join CosDivisionMst as d on d.DivisionNo=c.DivisionNo
left outer join CosCustomerMst as i on i.CustomerNo=a.CustomerNo 
left outer join (select distinct RptCustomerNo  from CosCustomerMst) as e 
on e.RptCustomerNo=i.CustomerNo 

where 
(Year(a.DocDate)=@Year and year(a.DocDate)=@Year
or Year(a.DocDate)=@Year-1 and year(a.DocDate)=@Year-1)
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
group by i.RptCustomerNo  --,isnull(f.CustomerName,'#Others')

--update #temp1 set GrowthYtdQty=(cast(YtdQty as float)-cast(PrevYtdQty as float))/ cast(PrevYtdQty as float)*100 where PrevYtdQty!=0

select f.RptSrNo,f.CustomerName,#temp1.* 
,(case when PrevYtdQty=0 then 0 else round(((((cast(YtdQty as float)-cast(PrevYtdQty as float))/cast(PrevYtdQty as float)))*100),2) end) as GrowthYtdQty
,(case when PrevYtdVal=0 then 0 else round((((cast(YtdVal as float)-cast(PrevYtdVal as float))/cast(PrevYtdVal as float))*100),2) end) as GrowthYtdVal

,(case when PrevMtdQty=0 then 0 else round((((cast(MtdQty as float)-cast(PrevMtdQty as float))/cast(PrevMtdQty as float))*100),2) end) as GrowthMtdQty
,(case when PrevMtdVal=0 then 0 else round((((cast(MtdVal as float)-cast(PrevMtdVal as float))/cast(PrevMtdVal as float))*100),2) end) as GrowthMtdVal

,(case when PrevWtdQty=0 then 0 else round((((cast(WtdQty as float)-cast(PrevWtdQty as float))/cast(PrevWtdQty as float))*100),2) end) as GrowthWtdQty
,(case when PrevWtdVal=0 then 0 else round((((cast(WtdVal as float)-cast(PrevWtdVal as float))/cast(PrevWtdVal as float))*100),2) end) as GrowthWtdVal


from #temp1 
left outer join CosCustomerMst as f on f.CustomerNo=#temp1.CustomerNo
order by f.RptSrNo

--select * from #temp1