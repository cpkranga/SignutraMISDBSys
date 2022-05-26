CREATE procedure spGetTownId
/*
declare @TownId int
exec spGetTownId 1,'B002',@TownId out
select @TownId
*/
(
	@DistributorId int,
	@DistTownCode varchar(20),
	@TownId int out
)
as 
begin
set @TownId=isnull((select isnull(TownId,0) from DistributorTownMatrix 
where DistributorId=@DistributorId
and DistTownCode=@DistTownCode),0)

end
