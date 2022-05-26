create procedure [dbo].[spCosGetMaterialCatCode]
/*
declare @TownId int
exec [spCosGetMaterialCatCode] 1,'B002',@TownId out
select @TownId
*/
(
	@MaterialNo int,
	@CatCode varchar(3) out
)
as 
begin
set @CatCode=isnull((select top 1 isnull(CatCode,'0') from CosMaterialMst 
where MaterialNo=@MaterialNo),'0')

end

--select * from coscategorymst