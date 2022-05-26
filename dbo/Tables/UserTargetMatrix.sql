CREATE TABLE [dbo].[UserTargetMatrix] (
    [DistributorId]       INT             NOT NULL,
    [UserId]              INT             NOT NULL,
    [TrgtYear]            INT             NOT NULL,
    [TrgtMonth]           INT             NOT NULL,
    [MonthlyTrgtQty]      DECIMAL (12, 2) NOT NULL,
    [MonthlyTrgtValue]    DECIMAL (12, 2) NOT NULL,
    [UnitCode]            VARCHAR (10)    NULL,
    [LastMnthAvgUnitRate] DECIMAL (12, 2) NULL,
    PRIMARY KEY CLUSTERED ([DistributorId] ASC, [UserId] ASC, [TrgtYear] ASC, [TrgtMonth] ASC)
);

