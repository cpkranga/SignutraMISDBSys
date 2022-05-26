CREATE TABLE [dbo].[DocConvertMaterialMst] (
    [EanCode]      VARCHAR (30)   NULL,
    [DivisionNo]   INT            NOT NULL,
    [MaterialCode] VARCHAR (16)   NOT NULL,
    [MaterialName] VARCHAR (200)  NOT NULL,
    [CatCode]      VARCHAR (3)    NOT NULL,
    [CatName]      VARCHAR (200)  NULL,
    [GroupCode]    VARCHAR (2)    NULL,
    [BrandCode]    VARCHAR (2)    NULL,
    [UnitCode]     VARCHAR (10)   NULL,
    [UnitSize]     DECIMAL (5, 2) NULL,
    [UnitFactor]   DECIMAL (5, 2) NULL,
    CONSTRAINT [PK__DocConve__170C54BB56B3DD81] PRIMARY KEY CLUSTERED ([MaterialCode] ASC),
    CONSTRAINT [chkMatLenth] CHECK (len([materialcode])=(16))
);

