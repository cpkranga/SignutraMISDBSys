





--update ManageMonth set CurrentMonth=3



CREATE procedure [dbo].[spMonthlyReports]
as
--

select * from DailySales where MONTH(SalesFromDate)=8
select SUM(nettotqty) from DailySales where MONTH(SalesFromDate)=8

select * from DailySales where MONTH(SalesFromDate)=8 and 
year(SalesFromDate)=2019 and SalesManId=7 and TownId=23

select * from AreaMst
select * from TownMst

select * from ProductMst

select * from UserBrandAreaMatrix where UserId=2
select * from UserBrandAreaMatrix where UserId=7

select SUM(MonthlyTrgtQty)  from UserTargetMatrix where TrgtMonth=8


select top 1 * from UserTargetMatrix where TrgtYear=2019 and TrgtMonth=8
select top 1 * from DailySales where DistributorId =1 order by SalesToDate desc



--update UserTargetMatrix set LastMnthAvgUnitRate=1647,MonthlyTrgtValue=(MonthlyTrgtQty*1647) where TrgtYear=2019 and TrgtMonth=8 



-- month end report
--exec [spYearlySalesHqBrandSKUWise] 1,2022
--exec spYearlySalesTownCatSMWise 1,2022
--exec spYearlySalesSKUMonthWise 1,2022

--exec spMonthlySales 1,2020,0  
--exec [spYearlySalesSKUSMMonthWise] 1,2020

--exec [spYearlySalesSMMonthWise] 1,2021 

--exec [spYearlySalesDiviSMQuarterWise] 1,2019
--exec [spYearlySalesDiviQuarterWise] 1,2019
--exec spYearlySalesDiviMonthWise 1,2019
--exec spYearlySalesDiviSMMonthWise 1,2019

--exec spYearlySalesBrandMonthWise 1,2019
--
--exec [spYearlySalesDiviSMQuarterWise] 1,2019
--exec [spDashboardSMDiviQuarterWise] 1,3,2019
--exec [spYearlySalesSKUSMQuarterWise] 1,2019


--exec [spYearlySalesUnitSMQuarterWise] 1,2019
--exec spMonthlySalesTownCatSMWise 1,2019,8
--exec spYearlySalesDiviTownMonthWise 1,2019
--exec spYearlySalesCatSMMonthWise 1,2019
--exec spYearlySalesBrandSMMonthWise 1,2019






--select * from DailySales where month(SalesFromDate)=8 and RegionId=4 and updateon > '22-Aug-2019'

--select * from DailySales where month(SalesFromDate)=2 and year(SalesFromDate)=2021

--delete from DailySales where month(SalesFromDate)=4 and year(SalesFromDate)=2022






select * from ManageMonth
select * from UserTargetMatrix

N015

select * from DailySales where TownId=0
--update DailySales set TownId=505 where DistTownCode='S015'
select * from DailySales where SalesFromDate > '25-Aug-2019' and RegionId =4

--delete from DailySales where month(SalesFromDate)=3 and YEAR(salesfromdate)=2022

select * from DailySales order by SalesFromDate desc

--R010	Rajanganaya




select * from TownMst where TownName like '%Rajanganaya%'

------R010	Rajanganaya 376



select * from DailySales where TownId=417

select * from MainTownMst where MainTownId=142 







select * from DailySales where MONTH(salesfromdate)=12 and year(salesfromdate)=2020






select * from DailySales where DistTownCode='N017' 
--update DailySales set TownId=376 where DistTownCode='R010'
----R010	Rajanganaya 376


select a.ProductId,a.DistProductCode,b.ProductName  from DistProductMatrix as a inner join ProductMst
as b on b.ProductId=a.ProductId  



select * from DistributorTownMatrix where DistTownCode='P021'
--insert into DistributorTownMatrix values(1,376,'R010',GETDATE())

--R010	Rajanganaya 376


select * from TownMst where TownName like '%KANTHARMADAM%'
insert into TownMst values(505,'SILAVATHAI',150)




select *from MainTownMst where MainTownName like '%Mannar%'







select distinct a.DistTownCode,c.TownId ,c.TownName,b.UserId ,b.UserName 
from DailySales as a inner join UserMst as b
on b.UserId=a.SalesManId  
left outer join TownMst as c on c.TownId=a.TownId



select a.*,b.AreaId,c.AreaName,c.ReagionId,d.ReagionName

 from TownMst as a 
left outer join MainTownMst as b on b.MainTownId=a.MainTownId
left outer join AreaMst as c on c.AreaId=b.AreaId
left outer join RegionMst as d on d.ReagionId=c.ReagionId

select * from CosDailySales as a 
left outer join CosMaterialMst as b on b.MaterialNo=a.MaterialNo
where b.MaterialNo is null

select * from CosDailySales as a 
left outer join CosCustomerMst as b on b.CustomerNo=a.CustomerNo
where b.CustomerNo is null