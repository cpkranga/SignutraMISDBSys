CREATE TABLE [dbo].[ProductMst] (
    [ProductId]   INT            NOT NULL,
    [ProductCode] VARCHAR (20)   NULL,
    [ProductName] VARCHAR (100)  NOT NULL,
    [BrandCode]   VARCHAR (2)    NULL,
    [CatCode]     VARCHAR (3)    NULL,
    [UnitCode]    VARCHAR (10)   NULL,
    [UnitSize]    DECIMAL (5, 2) NULL,
    [UnitFactor]  DECIMAL (6, 4) NULL,
    PRIMARY KEY CLUSTERED ([ProductId] ASC)
);

