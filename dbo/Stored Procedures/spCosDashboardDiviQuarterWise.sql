CREATE procedure [dbo].[spCosDashboardDiviQuarterWise]
--exec [spCosDashboardDiviQuarterWise] 'P',7,2020
(
	@SalesType varchar(1),
	@Month int ,
	@Year int
	
	
)
as

declare @CurrQtrStr as int 
declare @CurrQtrEnd as int 

-- 1st cycle 3mth
if (@Month=1 or @Month=2 or @Month=3 )
begin 
	set @CurrQtrStr=1
	set @CurrQtrEnd=3
end
-- 2nd cycle
if (@Month=4 or @Month=5 or @Month=6 )
begin 
	set @CurrQtrStr=4
	set @CurrQtrEnd=6
end
-- 3rd cycle
if (@Month=7 or @Month=8 or @Month=9)
begin 
	set @CurrQtrStr=7
	set @CurrQtrEnd=9
end
---- 4th qtr
if (@Month=10 or @Month=11 or @Month=12)
begin 
	set @CurrQtrStr=10
	set @CurrQtrEnd=12
end


select isnull(k.DivisionCode,'N/A') as DivisionCode
,isnull(k.DivisionName,'N/A') as DivisionName
,isnull(0,0) as MthTrgtQty
,isnull(0,0) as MthTrgtValue
,isnull(0,0) as QtrTrgtQty
,isnull(0,0) as QtrTrgtVal
,isnull(0,0) as YtdTrgtQty
,isnull(0,0) as YtdTrgtVal


,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.SaleQty * c.UnitFactor)  end),'0')) as 'CurMthGrsQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.SaleAmt end),'0')) as 'CurMthGrsVal'
,sum(isnull((case when month(a.SalesFromDate) = @Month then ((a.SalesRtnQty+a.DmgRtnQty) * c.UnitFactor) end),'0')) as 'CurMthRetQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.SalesRtnAmt+a.DmgRtnAmt) end),'0')) as 'CurMthRetVal'

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.NetSaleQty * c.UnitFactor) end),'0')) as 'CurMthNetQty'

,sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')) as 'CurMthNetVal'
,(case when (isnull(sum(0),0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')))*100/isnull(0,0)) end) as 'CurMthAch(%)'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then (a.NetSaleQty * c.UnitFactor) end),'0')) as 'CurQtrNetQty'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleAmt end),'0')) as 'CurQtrNetVal'
,(case when (isnull(0,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleAmt end),'0')))*100/isnull(0,0)) end) as 'CurQtrAch(%)'
,sum(a.NetSaleQty  * c.UnitFactor) as YTDNetTotQty
,sum(a.NetSaleAmt) as YTDNetTotValues
,(case when (isnull(0,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetSaleAmt))*100/isnull(0,0)) end )as 'CurYtdAch(%)'
from Cosdailysales as a 
inner join CosMaterialmst as c on c.materialno=a.materialno
left outer join CosCityMst as d on d.CityNo=a.TownNo
inner join CosUserMst as h on h.UserId=a.SalesPersonNo
left outer join CosMaterialBrandMst as i on i.BrandCode=c.BrandCode
left outer join CosDivisionMst as k on k.DivisionNo=c.DivisionNo


--left outer join 
--(select a1.DistributorId,b1.DiviCode,sum(a1.MonthlyTrgtQty) as MonthlyTrgtQty
--,sum(a1.MonthlyTrgtValue) as MonthlyTrgtValue from CosUserTargetMatrix as a1
--inner join (select distinct SalesPersonNo,divicode from CosCustomerMst) as b1 
--on b1.UserId=a1.UserId where 
--DistributorId=@Distributor and TrgtYear=@Year and TrgtMonth=@Month
--group by a1.DistributorId,b1.DiviCode) as l 
--on l.DistributorId=a.DistributorId  and l.DiviCode=k.DiviCode 

--left outer join 
--(select a1.DistributorId,b1.DiviCode,sum(a1.MonthlyTrgtQty) as QtrTrgtQty
--,sum(a1.MonthlyTrgtValue) as QtrTrgtVal from UserTargetMatrix as a1
--inner join (select distinct UserId,divicode from UserBrandAreaMatrix) as b1 
--on b1.UserId=a1.UserId where 
--a1.DistributorId=@Distributor and a1.TrgtYear=@Year 
--and a1.TrgtMonth>=@CurrQtrStr and a1.TrgtMonth<=@CurrQtrEnd
--group by a1.DistributorId,b1.DiviCode) as m
--on m.DistributorId=a.DistributorId  and m.DiviCode=k.DiviCode 


--left outer join 
--(select a1.DistributorId,b1.DiviCode,sum(a1.MonthlyTrgtQty) as YtdTrgtQty
--,sum(a1.MonthlyTrgtValue) as YtdTrgtVal from UserTargetMatrix as a1
--inner join (select distinct UserId,divicode from UserBrandAreaMatrix) as b1 
--on b1.UserId=a1.UserId where 
--a1.DistributorId=@Distributor and a1.TrgtYear=@Year 
--group by a1.DistributorId,b1.DiviCode) as n
--on n.DistributorId=a.DistributorId  and n.DiviCode=k.DiviCode 

where 
Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
group by isnull(k.DivisionCode,'N/A'),isnull(k.DivisionName,'N/A')


