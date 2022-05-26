CREATE procedure [dbo].[spCosDashboardSMDiviQuarterWise]
--exec [spCosDashboardSMDiviQuarterWise] 'P',7,2020
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



select h.UserName 
,isnull(hh.TypeName,'N/A') as TypeName
,isnull(l.MonthlyTrgtQty,0) as MthTrgtQty
,isnull(l.MonthlyTrgtValue,0) as MthTrgtValue
,isnull(m.QtrTrgtQty,0) as QtrTrgtQty
,isnull(m.QtrTrgtVal,0) as QtrTrgtVal
,isnull(n.YtdTrgtQty,0) as YtdTrgtQty
,isnull(n.YtdTrgtVal,0) as YtdTrgtVal

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.SaleQty * c.UnitFactor) end),'0')) as 'CurMthGrsQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.SaleAmt end),'0')) as 'CurMthGrsVal'
,sum(isnull((case when month(a.SalesFromDate) = @Month then ((a.SalesRtnQty+a.DmgRtnQty) * c.UnitFactor) end),'0')) as 'CurMthRetQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.SalesRtnAmt+a.DmgRtnAmt) end),'0')) as 'CurMthRetVal'

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.NetSaleQty * c.UnitFactor) end),'0')) as 'CurMthNetQty'

,sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')) as 'CurMthNetVal'
,(case when (isnull(l.MonthlyTrgtValue,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')))*100/isnull(l.MonthlyTrgtValue,0)) end) as 'CurMthAch(%)'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then (a.NetSaleQty * c.UnitFactor) end),'0')) as 'CurQtrNetQty'



,(case when (isnull(m.QtrTrgtQty,0))=0 then 0 else CONVERT(decimal(12,2),((sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleQty * c.UnitFactor end),'0')))*100)/isnull(m.QtrTrgtQty,0)) end) as 'CurQtrQtyAch(%)'

,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleAmt end),'0')) as 'CurQtrNetVal'
,(case when (isnull(m.QtrTrgtVal,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleAmt end),'0')))*100/isnull(m.QtrTrgtVal,0)) end) as 'CurQtrAch(%)'
,sum((a.NetSaleQty  * c.UnitFactor)) as YTDNetTotQty
,(case when (isnull(n.YtdTrgtQty,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetSaleQty  * c.UnitFactor))*100/(isnull(n.YtdTrgtQty ,0))) end )as 'CurYtdQtyAch(%)'
,sum(a.NetSaleAmt ) as YTDNetTotValues
,(case when (isnull(n.YtdTrgtVal,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetSaleAmt ))*100/isnull(n.YtdTrgtVal,0)) end )as 'CurYtdAch(%)'
from Cosdailysales as a 
inner join CosMaterialMst  as c on c.MaterialNo =a.MaterialNo
left outer join CosCityMst as d on d.CityNo=a.TownNo 
inner join CosUserMst as h on h.UserId=a.SalesPersonNo 
left outer join CosMaterialBrandMst as i on i.BrandCode=c.BrandCode

left outer join CosCustomerMst mm on mm.CustomerNo=a.CustomerNo
left outer join CosUserCustGroupTypeMatrix as k 
on k.CustGroupNo=mm.GroupNo and k.CustTypeNo=mm.TypeNo and k.UserNo=a.SalesPersonNo
left outer join CosCustomerTypeMst as hh on hh.TypeNo=mm.TypeNo

left outer join 
(select CustTypeNo,UserId,sum(MonthlyTrgtQty) as MonthlyTrgtQty
,sum(MonthlyTrgtValue) as MonthlyTrgtValue from CosUserTargetMatrix
 where TrgtYear=@Year and TrgtMonth=@Month
group by CustTypeNo,UserId) as l 
on l.UserId=a.SalesPersonNo and l.CustTypeNo=mm.TypeNo

left outer join 
(select CustTypeNo,UserId,sum(MonthlyTrgtQty) as QtrTrgtQty
,sum(MonthlyTrgtValue) as QtrTrgtVal from CosUserTargetMatrix
where TrgtYear=@Year 
and TrgtMonth>=@CurrQtrStr and TrgtMonth<=@CurrQtrEnd
group by CustTypeNo,UserId) as m
on m.UserId=a.SalesPersonNo and m.CustTypeNo=mm.TypeNo

left outer join 
(select CustTypeNo,UserId,sum(MonthlyTrgtQty) as YtdTrgtQty
,sum(MonthlyTrgtValue) as YtdTrgtVal from CosUserTargetMatrix
where TrgtYear=@Year 
group by CustTypeNo,UserId) as n
on n.UserId=a.SalesPersonNo and n.CustTypeNo=mm.TypeNo

where Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
group by h.UserName ,isnull(hh.TypeName,'N/A')
,l.MonthlyTrgtQty,l.MonthlyTrgtValue
,m.QtrTrgtQty,m.QtrTrgtVal
,n.YtdTrgtQty,n.YtdTrgtVal

