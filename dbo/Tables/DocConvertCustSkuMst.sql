CREATE TABLE [dbo].[DocConvertCustSkuMst] (
    [CustomerNo]   INT          NOT NULL,
    [MaterialCode] VARCHAR (16) NOT NULL,
    [CustSku]      VARCHAR (30) NULL,
    CONSTRAINT [PK__DocConve__05DF7A285A846E65] PRIMARY KEY CLUSTERED ([CustomerNo] ASC, [MaterialCode] ASC)
);

