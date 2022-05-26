



CREATE procedure [dbo].[spCosMonthlyReport]
as

--select * from CosPlantMst
-- 4 yasara
--exec [spCosCustSkuMonthWise] 'P',2020


select * from cosManageMonth
--update CosManageMonth set CurrentMonth=5

select * from CosDailySales where MONTH(docdate)=4 and YEAR(docdate)=2021

--delete CosDailySales where MONTH(docdate)=3 and YEAR(docdate)=2022



select a.* from CosDailySales as a left outer join CosCustomerMst as b
on b.CustomerNo=a.CustomerNo where b.CustomerName is null