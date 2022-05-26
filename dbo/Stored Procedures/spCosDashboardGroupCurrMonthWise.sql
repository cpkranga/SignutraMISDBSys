CREATE procedure [dbo].[spCosDashboardGroupCurrMonthWise]
--exec [spCosDashboardGroupCurrMonthWise] 'P',7,2020
(
	@SalesType varchar(1),
	@Month int ,
	@Year int
	
	
)
as



select ii.GroupName
,c.UnitCode
,l.CurMthAllPrdNetTotQty
,m.CurYtdAllPrdNetTotQty

,sum(isnull((case when month(a.SalesFromDate) = @Month then (a.NetSaleQty ) end),'0')) as 'CurMthNetQty'
,sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleAmt end),'0')) as 'CurMthNetVal'

,(case when (isnull(l.CurMthAllPrdNetTotQty,0))=0 then 0 else CONVERT(decimal(12,2),(sum(isnull((case when month(a.SalesFromDate) = @Month then a.NetSaleQty end),'0')))*100/isnull(l.CurMthAllPrdNetTotQty,0)) end) as 'Sales(%)TotMthQtySls'
,sum(a.NetSaleQty) as YTDNetTotQty
,sum(a.NetSaleAmt) as YTDNetTotValues
,(case when (isnull(m.CurYtdAllPrdNetTotQty,0))=0 then 0 else CONVERT(decimal(12,2),(sum(a.NetSaleQty ))*100/isnull(m.CurYtdAllPrdNetTotQty,0)) end )as 'Sales(%)TotYtdQtySls'
from Cosdailysales as a 
inner join CosMaterialmst as c on c.materialno=a.materialno 
--left outer join CosCityMst as d on d.CityNo=a.TownNo
--inner join CosUserMst as h on h.UserId=a.SalesPersonNo 
left outer join CosMaterialGroupMst as ii on ii.GroupCode=c.GroupCode
--left outer join CosMaterialBrandMst as i on i.BrandCode=c.BrandCode
--left outer join Categorymst as j on j.catcode=c.CatCode 
--left outer join (select distinct AreaId,UserId,BrandCode,divicode from UserBrandAreaMatrix) as k 
--on k.AreaId=f.AreaId and k.BrandCode=c.BrandCode and k.UserId=a.SalesManId 
left outer join 
(select SalesType,sum(NetSaleQty) as CurMthAllPrdNetTotQty
 from cosdailysales
  where 
Year(salesfromdate)=@Year and year(salestodate)=@Year
and Month(salesfromdate)=@Month
and SalesType=case when @SalesType='' then SalesType else @SalesType end
group by SalesType) as l 
on l.SalesType=a.SalesType 

left outer join 
(select SalesType,sum(NetSaleQty) as CurYtdAllPrdNetTotQty
 from cosdailysales
  where 
Year(salesfromdate)=@Year and year(salestodate)=@Year
--and Month(salesfromdate)=@Month
and SalesType=case when @SalesType='' then SalesType else @SalesType end
group by SalesType) as m 
on l.SalesType=a.SalesType 


where 
Year(a.salesfromdate)=@Year and year(a.salestodate)=@Year
and a.PlantCode!='1101'
and a.SalesType=case when @SalesType='' then a.SalesType else @SalesType end
group by ii.GroupName
,c.UnitCode
,l.CurMthAllPrdNetTotQty
,m.CurYtdAllPrdNetTotQty

order by ii.GroupName 