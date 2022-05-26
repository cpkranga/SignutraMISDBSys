CREATE TABLE [dbo].[CosMaterialBrandMst] (
    [BrandCode]    VARCHAR (2)   NOT NULL,
    [BrandName]    VARCHAR (100) NULL,
    [RptBrandCode] VARCHAR (2)   NULL,
    [SrNo]         SMALLINT      NULL,
    PRIMARY KEY CLUSTERED ([BrandCode] ASC)
);

