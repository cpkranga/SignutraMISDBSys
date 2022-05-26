CREATE TABLE [dbo].[CosDailySales] (
    [DocDate]       DATE            NOT NULL,
    [PlantCode]     VARCHAR (4)     NOT NULL,
    [CustomerNo]    INT             NOT NULL,
    [CustTypeNo]    INT             NOT NULL,
    [MaterialNo]    INT             NOT NULL,
    [SaleQty]       INT             NOT NULL,
    [SaleAmt]       DECIMAL (15, 2) NOT NULL,
    [SalesRtnQty]   INT             NOT NULL,
    [SalesRtnAmt]   DECIMAL (15, 2) NOT NULL,
    [DmgRtnQty]     INT             NOT NULL,
    [DmgRtnAmt]     DECIMAL (15, 2) NOT NULL,
    [NetSaleQty]    INT             NOT NULL,
    [NetTaxAmt]     DECIMAL (15, 2) NULL,
    [NetSaleAmt]    DECIMAL (15, 2) NOT NULL,
    [CustGroupNo]   INT             NULL,
    [SalesType]     VARCHAR (1)     NULL,
    [SalesPersonNo] INT             NULL,
    [TownNo]        INT             NULL,
    [UpdateByNo]    INT             NULL,
    [MdfOn]         SMALLDATETIME   CONSTRAINT [DF__CosDailyS__MdfOn__7993056A] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_CosDailySales_1] PRIMARY KEY CLUSTERED ([DocDate] ASC, [PlantCode] ASC, [CustomerNo] ASC, [MaterialNo] ASC)
);


GO
CREATE trigger [dbo].[trgCosChkCurrentMonth] on dbo.CosDailySales
for insert
as 
begin try

declare @DocDate date
--declare @salestodate date
declare @curryear int 
declare @currmonth int 
select @curryear=currentyear,@currmonth=currentmonth from Cosmanagemonth
--select * from dailysales
select @DocDate=i.DocDate from inserted as i
	if (@curryear != year(@DocDate) or 
		@currmonth != month(@DocDate) )
		--@curryear != year(@salestodate) or
		--@currmonth != month(@salestodate) )
	begin
		declare @err int
		set @err='error for roallback the transaction'
	end
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
END CATCH

GO
CREATE TRIGGER [dbo].[trgAftInsertDiviMatGrpSalTyeCustetc]  
ON dbo.CosDailySales
AFTER INSERT
AS  
declare @PlantCode varchar(4)
declare @DocDate date
--declare @SalesToDate date
declare @CustomerNo int
declare @MaterialNo Int
select @PlantCode=i.PlantCode
,@DocDate=i.DocDate
--,@SalesToDate=i.SalesToDate
,@CustomerNo=i.CustomerNo
,@MaterialNo=i.MaterialNo
from inserted as i






declare @DivisionNo int
exec spCosGetDivisionNo @MaterialNo,@DivisionNo out

--declare @MaterialGroupCode varchar(2)
--exec spCosGetMaterialGroupCode @MaterialNo,@MaterialGroupCode out

declare @SalesType varchar(1)
exec spCosGetSalesType @PlantCode,@SalesType out

declare @CustGroupNo int
exec spCosGetCustGroupNo @CustomerNo,@CustGroupNo out

--declare @CustTypeNo int
--exec spCosGetCustTypeNo @CustomerNo,@CustTypeNo out

declare @SalesPersonNo int
exec spCosGetSalesPersonNo @CustomerNo,@SalesPersonNo out

declare @TownNo int
exec spCosGetTownNo @CustomerNo,@TownNo out

update Cosdailysales set 
SalesType=@SalesType,CustGroupNo=@CustGroupNo
--,CustTypeNo=@CustTypeNo
,SalesPersonNo=@SalesPersonNo
,TownNo=@TownNo
 where
PlantCode=@PlantCode and DocDate=@DocDate
--and SalesToDate=@SalesToDate 
and CustomerNo=@CustomerNo
and MaterialNo=@MaterialNo

GO
CREATE TRIGGER [dbo].[trgCosAftUpdateDiviMatGrpSalTyeCustetc]  
ON dbo.CosDailySales
AFTER update
AS  
declare @PlantCode varchar(4)
declare @DocDate date
--declare @SalesToDate date
declare @CustomerNo int
declare @MaterialNo int
select @PlantCode=i.PlantCode
--,@SalesFromDate=i.SalesFromDate
,@DocDate=i.DocDate
,@CustomerNo=i.CustomerNo
,@MaterialNo=i.MaterialNo
from inserted as i


DECLARE ds_cursor CURSOR FOR     
SELECT i.PlantCode,i.DocDate
--,i.SalesToDate
,i.CustomerNo,i.MaterialNo
FROM inserted as i;

OPEN ds_cursor    
  
FETCH NEXT FROM ds_cursor     
INTO @PlantCode,@DocDate  -- ,@SalesToDate
,@CustomerNo,@MaterialNo
WHILE @@FETCH_STATUS = 0    
BEGIN




--declare @DivisionNo int
--exec spCosGetDivisionNo @MaterialNo,@DivisionNo out

--declare @MaterialGroupCode varchar(2)
--exec spCosGetMaterialGroupCode @MaterialNo,@MaterialGroupCode out

declare @SalesType varchar(1)
exec spCosGetSalesType @PlantCode,@SalesType out

declare @CustGroupNo int
exec spCosGetCustGroupNo @CustomerNo,@CustGroupNo out

--declare @CustTypeNo int
--exec spCosGetCustTypeNo @CustomerNo,@CustTypeNo out

declare @SalesPersonNo int
exec spCosGetSalesPersonNo @CustomerNo,@SalesPersonNo out

declare @TownNo int
exec spCosGetTownNo @CustomerNo,@TownNo out

update Cosdailysales set 
SalesType=@SalesType,CustGroupNo=@CustGroupNo
--,CustTypeNo=@CustTypeNo
,SalesPersonNo=@SalesPersonNo
,TownNo=@TownNo
 where
PlantCode=@PlantCode and DocDate=@DocDate
--and SalesToDate=@SalesToDate 
and CustomerNo=@CustomerNo
and MaterialNo=@MaterialNo


FETCH NEXT FROM ds_cursor     
INTO @PlantCode,@DocDate  -- ,@SalesToDate
,@CustomerNo,@MaterialNo
   
END     
CLOSE ds_cursor;    
DEALLOCATE ds_cursor;

GO
CREATE trigger [dbo].[trgCosChkToDateIsSaturday] on dbo.CosDailySales
for insert
as 
begin try

declare @Docdate date

--select * from dailysales
select @Docdate=i.Docdate from inserted as i
	if (SELECT DATENAME(DW, @Docdate) )!='Saturday'
	begin
		declare @err int
		set @err='error for roallback the transaction'
	end
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
END CATCH

GO
DISABLE TRIGGER [dbo].[trgCosChkToDateIsSaturday]
    ON [dbo].[CosDailySales];


GO
CREATE trigger [dbo].[trgCosChkCurrentMonth4Del] on dbo.CosDailySales
 INSTEAD OF DELETE
as 
begin try

declare @DocDate date
--declare @salestodate date
declare @curryear int 
declare @currmonth int 
select @curryear=currentyear,@currmonth=currentmonth from Cosmanagemonth
--select * from dailysales
select @DocDate=i.DocDate from DELETED as i
	if (@curryear != year(@DocDate) or 
		@currmonth != month(@DocDate) )
		--@curryear != year(@salestodate) or
		--@currmonth != month(@salestodate) )
	begin
		
		declare @err int
		set @err='error for roallback the transaction'
		 RAISERROR ('Could not delete client because he is a programmer', -- Message text  
                    16, -- Severity 
                    1 -- State
                    )
	end
	else
	begin
		DELETE CosDailySales
		 FROM DELETED D
		 INNER JOIN dbo.CosDailySales T ON 
		 T.DocDate = D.DocDate
		 and T.PlantCode = D.PlantCode
		 and T.CustomerNo = D.CustomerNo
		 and T.MaterialNo = D.MaterialNo
	end
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	
END CATCH
