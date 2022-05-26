CREATE procedure [dbo].[spDashboardManagerQuarterWise]
--exec [spDashboardManagerQuarterWise] 1,8,2019
(
	@Distributor int,
	@Month int ,
	@Year int
)
as

declare @CurrQtrStr as int 
declare @CurrQtrEnd as int 

-- 1st cycle
if (@Month=1 or @Month=2 or @Month=3 or @Month=4)
begin 
	set @CurrQtrStr=1
	set @CurrQtrEnd=4
end
-- 2nd cycle
if (@Month=5 or @Month=6 or @Month=7 or @Month=8)
begin 
	set @CurrQtrStr=5
	set @CurrQtrEnd=8
end
-- 3rd cycle
if (@Month=9 or @Month=10 or @Month=11 or @Month=12)
begin 
	set @CurrQtrStr=9
	set @CurrQtrEnd=12
end
---- 4th qtr
--if (@Month=10 or @Month=11 or @Month=12)
--begin 
--	set @CurrQtrStr=10
--	set @CurrQtrEnd=12
--end


select h.ManagerName 
,(isnull(l.MonthlyTrgtQty,0)) as MthTrgtQty
,(isnull(l.MonthlyTrgtValue,0)) as MthTrgtValue
,(isnull(m.QtrTrgtQty,0)) as QtrTrgtQty
,(isnull(m.QtrTrgtVal,0)) as QtrTrgtVal
,(isnull(n.YtdTrgtQty,0)) as YtdTrgtQty
,(isnull(n.YtdTrgtVal,0)) as YtdTrgtVal

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.GrossTotQty * c.UnitFactor) end),'0')) as 'CurMthGrsQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.GrossTotValue end),'0')) as 'CurMthGrsVal'
,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.RetTotQty * c.UnitFactor) end),'0')) as 'CurMthRetQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.RetTotValue end),'0')) as 'CurMthRetVal'

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.NetTotQty * c.UnitFactor) end),'0')) as 'CurMthNetQty'

,sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetTotValues end),'0')) as 'CurMthNetVal'
,(case when (isnull(l.MonthlyTrgtValue,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetTotValues end),'0')))*100/isnull(l.MonthlyTrgtValue,0)) end) as 'CurMthAch(%)'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then (a.NetTotQty * c.UnitFactor) end),'0')) as 'CurQtrNetQty'
,sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetTotValues end),'0')) as 'CurQtrNetVal'
,(case when (isnull(m.QtrTrgtVal,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when (month(a.SalesFromDate)>= @CurrQtrStr and month(a.SalesFromDate)<= @CurrQtrEnd)  then a.NetTotValues end),'0')))*100/isnull(m.QtrTrgtVal,0)) end) as 'CurQtrAch(%)'
,sum((a.NetTotQty * c.UnitFactor)) as YTDNetTotQty
,sum(a.NetTotValues) as YTDNetTotValues
,(case when (isnull(n.YtdTrgtVal,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetTotValues))*100/isnull(n.YtdTrgtVal,0)) end )as 'CurYtdAch(%)'
from dailysales as a 
inner join DistributorMst as b on b.DistributorId=a.DistributorId 
inner join ProductMst as c on c.ProductId=a.ProductId 
left outer join TownMst as d on d.TownId=a.TownId 
left outer join MainTownMst as e on e.MainTownId=d.MainTownId  
left outer join AreaMst as f on f.AreaId=e.AreaId 
left outer join RegionMst as g on g.ReagionId =f.ReagionId
inner join (select a.*,b.UserName as ManagerName from UserMst as a inner join UserMst as b on b.UserId=a.managerid) as h on h.UserId=a.SalesManId  
left outer join BrandMst as i on i.BrandCode=c.BrandCode
left outer join Categorymst as j on j.catcode=c.CatCode 
left outer join (select distinct AreaId,UserId,BrandCode,divicode from UserBrandAreaMatrix) as k 
on k.AreaId=f.AreaId and k.BrandCode=c.BrandCode and k.UserId=a.SalesManId 

left outer join 
(select a1.DistributorId,a1.ManagerId,sum(a1.MonthlyTrgtQty) as MonthlyTrgtQty   -- monthly target 
,sum(a1.MonthlyTrgtValue) as MonthlyTrgtValue from (select distinct a.*,b.managerid from UserTargetMatrix as a
left outer join usermst as b on b.UserId=a.UserId ) as a1
where 
DistributorId=@Distributor and TrgtYear=@Year and TrgtMonth=@Month
group by a1.DistributorId,a1.ManagerId) as l 
on l.DistributorId=a.DistributorId and l.ManagerId=h.ManagerId 

left outer join 
(select a1.DistributorId,a1.ManagerId,sum(a1.MonthlyTrgtQty) as QtrTrgtQty
,sum(a1.MonthlyTrgtValue) as QtrTrgtVal from (select distinct a.*,b.managerid from UserTargetMatrix as a
left outer join usermst as b on b.UserId=a.UserId ) as a1
where 
a1.DistributorId=@Distributor and a1.TrgtYear=@Year 
and a1.TrgtMonth>=@CurrQtrStr and a1.TrgtMonth<=@CurrQtrEnd
group by a1.DistributorId,a1.ManagerId) as m
on m.DistributorId=a.DistributorId  and m.ManagerId=h.ManagerId

left outer join 
(select a1.DistributorId,a1.ManagerId,sum(a1.MonthlyTrgtQty) as YtdTrgtQty
,sum(a1.MonthlyTrgtValue) as YtdTrgtVal from (select distinct a.*,b.managerid from UserTargetMatrix as a
left outer join usermst as b on b.UserId=a.UserId ) as a1
where 
a1.DistributorId=@Distributor and a1.TrgtYear=@Year 
group by a1.DistributorId,a1.ManagerId) as n
on n.DistributorId=a.DistributorId  and n.ManagerId=h.ManagerId


where a.DistributorId=@Distributor 
and Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and (a.SalesType+':'+cast(a.RegionId as varchar(10)) !='P:4')
group by h.ManagerName 
,l.MonthlyTrgtQty,l.MonthlyTrgtValue
,m.QtrTrgtQty,m.QtrTrgtVal
,n.YtdTrgtQty,n.YtdTrgtVal

