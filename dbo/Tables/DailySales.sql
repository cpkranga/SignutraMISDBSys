CREATE TABLE [dbo].[DailySales] (
    [DistributorId]   INT             NOT NULL,
    [SalesType]       VARCHAR (1)     NOT NULL,
    [SalesFromDate]   DATE            NOT NULL,
    [SalesToDate]     DATE            NOT NULL,
    [DistTownCode]    VARCHAR (20)    NOT NULL,
    [DistProductCode] VARCHAR (20)    NOT NULL,
    [GrossTotQty]     INT             NOT NULL,
    [GrossTotValue]   DECIMAL (12, 2) NOT NULL,
    [RetTotQty]       INT             NOT NULL,
    [RetTotValue]     DECIMAL (12, 2) NOT NULL,
    [NetTotQty]       INT             NOT NULL,
    [NetTotValues]    DECIMAL (12, 2) NULL,
    [TownId]          INT             CONSTRAINT [DF__DailySale__TownI__5CA1C101] DEFAULT ((0)) NULL,
    [ProductId]       INT             CONSTRAINT [DF__DailySale__Produ__5D95E53A] DEFAULT ((0)) NULL,
    [SalesManId]      INT             NULL,
    [UpdateById]      INT             NULL,
    [UpdateOn]        SMALLDATETIME   CONSTRAINT [DF__DailySale__Updat__5E8A0973] DEFAULT (getdate()) NULL,
    [RegionId]        INT             NULL,
    CONSTRAINT [PK_DailySales] PRIMARY KEY CLUSTERED ([DistributorId] ASC, [SalesType] ASC, [SalesFromDate] ASC, [SalesToDate] ASC, [DistTownCode] ASC, [DistProductCode] ASC),
    CONSTRAINT [chkConSalesType] CHECK ([SalesType]='P' OR [SalesType]='S' OR [SalesToDate]>'31-Jan-2021' AND [SalesType]='N'),
    CONSTRAINT [CK__DailySale__RetTo__59C55456] CHECK ([RetTotQty]>=(0)),
    CONSTRAINT [CK__DailySale__RetTo__5AB9788F] CHECK ([RetTotValue]>=(0)),
    CONSTRAINT [CK__DailySales__5BAD9CC8] CHECK (datepart(month,[SalesFromDate])=datepart(month,[SalesToDate]) AND datepart(year,[SalesFromDate])=datepart(year,[SalesToDate]) AND [SalesFromDate]<=[SalesToDate])
);


GO
CREATE TRIGGER [dbo].[trgUpdateTownIdAndProdIdUserIdRehId]  
ON dbo.DailySales
AFTER update
AS  
declare @DistId int
declare @DistTownCode varchar(20)
declare @DistProdCode varchar(20)
declare @SalesFromDate date
declare @SalesToDate date
declare @RetTotQty int
declare @RetTotValue decimal(12,2)
select @DistId=i.DistributorId
,@SalesFromDate=i.SalesFromDate
,@SalesToDate=i.SalesToDate
,@DistTownCode=i.DistTownCode
,@DistProdCode=i.DistProductCode
from inserted as i


DECLARE ds_cursor CURSOR FOR     
SELECT i.DistributorId,i.SalesFromDate
,i.SalesToDate,i.DistTownCode,i.DistProductCode
FROM inserted as i;

OPEN ds_cursor    
  
FETCH NEXT FROM ds_cursor     
INTO @DistId,@SalesFromDate ,@SalesToDate
,@DistTownCode,@DistProdCode
WHILE @@FETCH_STATUS = 0    
BEGIN




declare @TownId int
exec spGetTownId @DistId,@DistTownCode,@TownId out

declare @ProductId int
exec spGetProductId @DistId,@DistProdCode,@ProductId out

declare @UserId int
exec spGetUserId @DistId,@DistTownCode,@DistProdCode,@UserId out

declare @RegionId int
exec spGetRegionId @DistId,@DistTownCode,@RegionId out


update dailysales set 
TownId=@TownId,ProductId=@ProductId,SalesManId=@UserId,RegionId=@RegionId where
DistributorId=@DistId and SalesFromDate=@SalesFromDate
and SalesToDate=@SalesToDate and DistTownCode=@DistTownCode
and DistProductCOde=@DistProdCode


FETCH NEXT FROM ds_cursor     
INTO @DistId,@SalesFromDate ,@SalesToDate
,@DistTownCode,@DistProdCode 
   
END     
CLOSE ds_cursor;    
DEALLOCATE ds_cursor;

GO
create TRIGGER [dbo].[trgUpdateOfIsrtTownIdAndProdIdUserIdRehId]  
ON dbo.DailySales
AFTER INSERT
AS  
declare @DistId int
declare @DistTownCode varchar(20)
declare @DistProdCode varchar(20)
declare @SalesFromDate date
declare @SalesToDate date
declare @RetTotQty int
declare @RetTotValue decimal(12,2)
select @DistId=i.DistributorId
,@SalesFromDate=i.SalesFromDate
,@SalesToDate=i.SalesToDate
,@DistTownCode=i.DistTownCode
,@DistProdCode=i.DistProductCode
from inserted as i

declare @TownId int
exec spGetTownId @DistId,@DistTownCode,@TownId out

declare @ProductId int
exec spGetProductId @DistId,@DistProdCode,@ProductId out

declare @UserId int
exec spGetUserId @DistId,@DistTownCode,@DistProdCode,@UserId out

declare @RegionId int
exec spGetRegionId @DistId,@DistTownCode,@RegionId out


update dailysales set 
TownId=@TownId,ProductId=@ProductId,SalesManId=@UserId,RegionId=@RegionId where
DistributorId=@DistId and SalesFromDate=@SalesFromDate
and SalesToDate=@SalesToDate and DistTownCode=@DistTownCode
and DistProductCOde=@DistProdCode

GO
CREATE trigger trgChkCurrentMonth on dailysales
for insert
as 
begin try

declare @salesfromdate date
declare @salestodate date
declare @curryear int 
declare @currmonth int 
select @curryear=currentyear,@currmonth=currentmonth from managemonth
--select * from dailysales
select @salesfromdate=i.SalesFromDate,@salestodate=i.SalesToDate from inserted as i
	if (@curryear != year(@salesfromdate) or 
		@currmonth != month(@salesfromdate) or
		@curryear != year(@salestodate) or
		@currmonth != month(@salestodate) )
	begin
		declare @err int
		set @err='error for roallback the transaction'
	end
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
END CATCH

GO
create trigger [dbo].[trgCosChkCurrentMonth4Del1] on [dbo].[DailySales]
 INSTEAD OF DELETE
as 
begin try

declare @salesfromdate date
declare @salestodate date
declare @curryear int 
declare @currmonth int 
select @curryear=currentyear,@currmonth=currentmonth from managemonth
--select * from dailysales
select @salesfromdate=i.SalesFromDate,@salestodate=i.SalesToDate from DELETED as i
	if (@curryear != year(@salesfromdate) or 
		@currmonth != month(@salesfromdate) or
		@curryear != year(@salestodate) or
		@currmonth != month(@salestodate) )
	begin
		declare @err int
		set @err='error for roallback the transaction'
	end
	else
	begin
		DELETE DailySales
		 FROM DELETED D
		 INNER JOIN dbo.DailySales T ON 
		 T.DistributorId = D.DistributorId
		 and T.SalesType = D.SalesType
		 and T.SalesFromDate = D.SalesFromDate
		 and T.SalesToDate = D.SalesToDate
		 and T.DistTownCode = D.DistTownCode
		 and T.DistProductCode = D.DistProductCode
	end
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
END CATCH
