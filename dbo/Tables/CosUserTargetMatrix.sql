CREATE TABLE [dbo].[CosUserTargetMatrix] (
    [CustTypeNo]          INT             NOT NULL,
    [UserId]              INT             NOT NULL,
    [TrgtYear]            INT             NOT NULL,
    [TrgtMonth]           INT             NOT NULL,
    [MonthlyTrgtQty]      DECIMAL (12, 2) NOT NULL,
    [MonthlyTrgtValue]    DECIMAL (12, 2) NOT NULL,
    [UnitCode]            VARCHAR (10)    NULL,
    [LastMnthAvgUnitRate] DECIMAL (12, 2) NULL,
    CONSTRAINT [PK_CosUserTargetMatrix] PRIMARY KEY CLUSTERED ([CustTypeNo] ASC, [UserId] ASC, [TrgtYear] ASC, [TrgtMonth] ASC)
);

