CREATE procedure [dbo].[spGetUserId]
/*
declare @UserId int
exec spGetUserId 1,'C002','MANSV200',@UserId out
select @UserId
*/
(
	@DistributorId int,
	@DistTownCode varchar(20),
	@DistProductCode varchar(20),
	@UserId int out
)
as 
begin

declare @TownId_ int
exec spGetTownId @DistributorId,@DistTownCode,@TownId_ out


declare @ProductId_ int
exec spGetProductId @DistributorId,@DistProductCode,@ProductId_ out
--select @ProductId_


set @UserId=isnull((select isnull(UserId,0) from userbrandareamatrix where areaid=
(select isnull(b.AreaId,0) from MainTownMst as a inner join 
AreaMst as b on b.AreaId=a.AreaId 
inner join TownMst as c on c.MainTownId=a.MainTownId 
where c.TownId=@TownId_)
and BrandCode = (select isnull(BrandCode,'00') from ProductMst 
where ProductId=@ProductId_ )
and IsActive=1
),0)

end
