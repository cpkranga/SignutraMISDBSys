CREATE TABLE [dbo].[CosMaterialMst] (
    [MaterialNo]   INT            NOT NULL,
    [MaterialCode] VARCHAR (20)   NULL,
    [MaterialName] VARCHAR (200)  NOT NULL,
    [DivisionNo]   INT            NOT NULL,
    [GroupCode]    VARCHAR (2)    NULL,
    [BrandCode]    VARCHAR (2)    NULL,
    [RptBrandCode] VARCHAR (2)    NULL,
    [CatCode]      VARCHAR (3)    NULL,
    [UnitCode]     VARCHAR (5)    NULL,
    [UintSize]     DECIMAL (5, 2) NULL,
    [UnitFactor]   DECIMAL (5, 3) NULL,
    CONSTRAINT [PK__CosMater__C50628D425A691D2] PRIMARY KEY CLUSTERED ([MaterialNo] ASC)
);

