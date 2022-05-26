-- exec spStn 'TD000-0007'
CREATE procedure [dbo].[spStn]
(
	@StnNo varchar(20)
)
as 
select 
cast(row_number() over (order by c.DivisionNo,b.MaterialCode,b.Lot ) as int) as "srno2",
a.*,b.*,d.CustName,d.OfficeAdd1
,d.OfficeAdd2,d.OfficeAdd3,d.OfficeAdd4
,d.GodownAdd1,d.GodownAdd2,d.GodownAdd3
,d.GodownAdd4,d.TINNo
,c.DivisionNo,c.MaterialName,c.CatCode,c.CatName,c.EanCode,e.CustSku
,dbo.fnNumberToWords(a.TotAmt) as AmtInWords 
from DocConvertSTNHdr as a 
inner join DocConvertSTNDtl as b on b.StnNo=a.StnNo
left outer join DocConvertMaterialMst as c on c.MaterialCode=b.MaterialCode
inner join DocConvertCustMst as d on d.CustNo=a.CustNo
left outer join DocConvertCustSkuMst as e on e.CustomerNo=a.CustNo
and e.MaterialCode=b.MaterialCode
where a.StnNo=@StnNo
order by c.DivisionNo,b.MaterialCode,b.Lot 
