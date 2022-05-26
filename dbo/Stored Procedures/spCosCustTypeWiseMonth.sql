

CREATE procedure [dbo].[spCosCustTypeWiseMonth]
--exec [spCosCustTypeWiseMonth] 'P',2020
(
	@SalesType varchar(1),
	--@Month int ,
	@Year int
)
as





if OBJECT_ID('tempdb..#temp1') is not null
DROP TABLE #temp1
create table #temp1
(
	TypeNo int,
	TypeName varchar(100),
	JanQty int,
	JanVal decimal(15,2),
	FebQty int,
	FebVal decimal(15,2),
	MarQty int,
	MarVal decimal(15,2),
	AprQty int,
	AprVal decimal(15,2),
	MayQty int,
	MayVal decimal(15,2),
	JunQty int,
	JunVal decimal(15,2),
	JulQty int,
	JulVal decimal(15,2),
	AugQty int,
	AugVal decimal(15,2),
	SepQty int,
	SepVal decimal(15,2),
	OctQty int,
	OctVal decimal(15,2),
	NovQty int,
	NovVal decimal(15,2),
	DecQty int,
	DecVal decimal(15,2),
	
	TotQty int,
	TotVal decimal(15,2)

)

insert into #temp1
select i.TypeNo as CustTypeNo
,(case when i.TypeNo=205 and d.RptDivisionCode='CCD' then 'Direct Sales-MTBA-CCD'
 when i.TypeNo=205 and d.RptDivisionCode='PCD' then 'Direct Sales-MTBA-PCD'
 when i.TypeNo=205 and d.RptDivisionCode='SAN' then 'Direct Sales-MTBA-SAN'
 
 when i.TypeNo=203 and d.RptDivisionCode='CCD' then 'Direct Sales-BA-CCD'
 when i.TypeNo=203 and d.RptDivisionCode='PCD' then 'Direct Sales-BA-PCD'
 when i.TypeNo=203 and d.RptDivisionCode='SAN' then 'Direct Sales-BA-SAN'
else isnull(i.TypeName,'#Others') end) as CustTypeName


,sum(isnull((case when (month(a.DocDate) = 1 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'JanQty'
,sum(isnull((case when (month(a.DocDate) = 1 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'JanVal'

,sum(isnull((case when (month(a.DocDate) = 2 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'FebQty'
,sum(isnull((case when (month(a.DocDate) = 2 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'FebVal'

,sum(isnull((case when (month(a.DocDate) = 3 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'MarQty'
,sum(isnull((case when (month(a.DocDate) = 3 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'MarVal'
,sum(isnull((case when (month(a.DocDate) = 4 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'AprQty'
,sum(isnull((case when (month(a.DocDate) = 4 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'AprVal'
,sum(isnull((case when (month(a.DocDate) = 5 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'MayQty'
,sum(isnull((case when (month(a.DocDate) = 5 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'MayVal'
,sum(isnull((case when (month(a.DocDate) = 6 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'JunQty'
,sum(isnull((case when (month(a.DocDate) = 6 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'JunVal'
,sum(isnull((case when (month(a.DocDate) = 7 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'JulQty'
,sum(isnull((case when (month(a.DocDate) = 7 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'JulVal'
,sum(isnull((case when (month(a.DocDate) = 8 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'AugQty'
,sum(isnull((case when (month(a.DocDate) = 8 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'AugVal'
,sum(isnull((case when (month(a.DocDate) = 9 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'SepQty'
,sum(isnull((case when (month(a.DocDate) = 9 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'SepVal'
,sum(isnull((case when (month(a.DocDate) = 10 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'OctQty'
,sum(isnull((case when (month(a.DocDate) = 10 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'OctVal'
,sum(isnull((case when (month(a.DocDate) = 11 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'NovQty'
,sum(isnull((case when (month(a.DocDate) = 11 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'NovVal'
,sum(isnull((case when (month(a.DocDate) = 12 and year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'DecQty'
,sum(isnull((case when (month(a.DocDate) = 12 and year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'DecVal'
,sum(isnull((case when (year(a.DocDate) = @Year) then (a.NetSaleQty ) end),'0')) as 'TotQty'
,sum(isnull((case when (year(a.DocDate) = @Year)then a.NetSaleAmt end),'0')) as 'TotVal'


from CosDailysales as a 
inner join CosMaterialmst as c on c.materialno=a.materialno
left outer join CosDivisionMst as d on d.DivisionNo=c.DivisionNo
left outer join CosCustomerTypeMst as i on i.TypeNo=a.CustTypeNo

where 
(Year(a.DocDate)=@Year and year(a.DocDate)=@Year
or Year(a.DocDate)=@Year-1 and year(a.DocDate)=@Year-1)
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end

group by i.TypeNo,
(case when i.TypeNo=205 and d.RptDivisionCode='CCD' then 'Direct Sales-MTBA-CCD'
 when i.TypeNo=205 and d.RptDivisionCode='PCD' then 'Direct Sales-MTBA-PCD'
 when i.TypeNo=205 and d.RptDivisionCode='SAN' then 'Direct Sales-MTBA-SAN'
 when i.TypeNo=203 and d.RptDivisionCode='CCD' then 'Direct Sales-BA-CCD'
 when i.TypeNo=203 and d.RptDivisionCode='PCD' then 'Direct Sales-BA-PCD'
 when i.TypeNo=203 and d.RptDivisionCode='SAN' then 'Direct Sales-BA-SAN'

else isnull(i.TypeName,'#Others') end)


--update #temp1 set GrowthYtdQty=(cast(YtdQty as float)-cast(PrevYtdQty as float))/ cast(PrevYtdQty as float)*100 where PrevYtdQty!=0

select #temp1.* 

from #temp1 
left outer join CosCustomerTypeMst  as f on f.TypeNo=#temp1.TypeNo
--order by f.CustomerName

--select * from #temp1