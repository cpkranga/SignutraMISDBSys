CREATE TABLE [dbo].[CosCustomerMst] (
    [CustomerNo]     INT           NOT NULL,
    [CustomerCode]   VARCHAR (9)   NULL,
    [CustomerName]   VARCHAR (150) NULL,
    [ProfitCenterNo] INT           NULL,
    [GroupNo]        INT           NULL,
    [TypeNo]         INT           NULL,
    [SalesPersonNo]  INT           NULL,
    [TownNo]         INT           NULL,
    [RptCustomerNo]  INT           NULL,
    [RptSrNo]        INT           NULL,
    CONSTRAINT [PK__CosCusto__A4AFBF631975C517] PRIMARY KEY CLUSTERED ([CustomerNo] ASC)
);

