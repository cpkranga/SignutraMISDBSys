CREATE procedure [dbo].[spCosDashboardManagerQuarterWise]
--exec [spCosDashboardManagerQuarterWise] 'P',7,2020
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



select h.ManagerName 
,(isnull(l.MonthlyTrgtQty,0)) as MthTrgtQty
,(isnull(l.MonthlyTrgtValue,0)) as MthTrgtValue
,(isnull(m.QtrTrgtQty,0)) as QtrTrgtQty
,(isnull(m.QtrTrgtVal,0)) as QtrTrgtVal
,(isnull(n.YtdTrgtQty,0)) as YtdTrgtQty
,(isnull(n.YtdTrgtVal,0)) as YtdTrgtVal

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.SaleQty * c.UnitFactor) end),'0')) as 'CurMthGrsQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.SaleAmt end),'0')) as 'CurMthGrsVal'
,sum(isnull((case when month(a.SalesFromDate) = @Month then ((a.SalesRtnQty+a.DmgRtnQty) * c.UnitFactor) end),'0')) as 'CurMthRetQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.SalesRtnAmt+a.DmgRtnAmt) end),'0')) as 'CurMthRetVal'

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.NetSaleQty * c.UnitFactor) end),'0')) as 'CurMthNetQty'

,sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')) as 'CurMthNetVal'
,(case when (isnull(l.MonthlyTrgtValue,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')))*100/isnull(l.MonthlyTrgtValue,0)) end) as 'CurMthAch(%)'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then (a.NetSaleQty * c.UnitFactor) end),'0')) as 'CurQtrNetQty'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleAmt  end),'0')) as 'CurQtrNetVal'
,(case when (isnull(m.QtrTrgtVal,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetSaleAmt end),'0')))*100/isnull(m.QtrTrgtVal,0)) end) as 'CurQtrAch(%)'
,sum((a.NetSaleQty * c.UnitFactor)) as YTDNetTotQty
,sum(a.NetSaleAmt)  as YTDNetTotValues
,(case when (isnull(n.YtdTrgtVal,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetSaleAmt))*100/isnull(n.YtdTrgtVal,0)) end )as 'CurYtdAch(%)'
from Cosdailysales as a 

inner join CosMaterialmst as c on c.materialno=a.materialno 
left outer join CosCityMst as d on d.CityNo=a.TownNo 
inner join (select a.*,b.UserName as ManagerName from CosUserMst as a inner join CosUserMst as b on b.UserId=a.managerid) as h on h.UserId=a.SalesPersonNo 
left outer join CosMaterialBrandMst as i on i.BrandCode=c.BrandCode
left outer join CosCustomerMst mm on mm.CustomerNo=a.CustomerNo
left outer join CosUserCustGroupTypeMatrix as k 
on k.CustGroupNo=mm.GroupNo and k.CustTypeNo=mm.TypeNo and k.UserNo=a.SalesPersonNo
left outer join CosCustomerTypeMst as hh on hh.TypeNo=mm.TypeNo



left outer join 
(select a1.ManagerId,sum(a1.MonthlyTrgtQty) as MonthlyTrgtQty   -- monthly target 
,sum(a1.MonthlyTrgtValue) as MonthlyTrgtValue from (select distinct a.*,b.managerid from CosUserTargetMatrix as a
left outer join Cosusermst as b on b.UserId=a.UserId ) as a1
where 
TrgtYear=@Year and TrgtMonth=@Month
group by a1.ManagerId) as l 
on l.ManagerId=h.ManagerId 

left outer join 
(select a1.ManagerId,sum(a1.MonthlyTrgtQty) as QtrTrgtQty
,sum(a1.MonthlyTrgtValue) as QtrTrgtVal from (select distinct a.*,b.managerid from CosUserTargetMatrix as a
left outer join Cosusermst as b on b.UserId=a.UserId ) as a1
where 
a1.TrgtYear=@Year 
and a1.TrgtMonth>=@CurrQtrStr and a1.TrgtMonth<=@CurrQtrEnd
group by a1.ManagerId) as m
on m.ManagerId=h.ManagerId

left outer join 
(select a1.ManagerId,sum(a1.MonthlyTrgtQty) as YtdTrgtQty
,sum(a1.MonthlyTrgtValue) as YtdTrgtVal from (select distinct a.*,b.managerid from CosUserTargetMatrix as a
left outer join Cosusermst as b on b.UserId=a.UserId ) as a1
where 
a1.TrgtYear=@Year 
group by a1.ManagerId) as n
on n.ManagerId=h.ManagerId


where 
Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
group by h.ManagerName 
,l.MonthlyTrgtQty,l.MonthlyTrgtValue
,m.QtrTrgtQty,m.QtrTrgtVal
,n.YtdTrgtQty,n.YtdTrgtVal

