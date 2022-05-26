CREATE TABLE [dbo].[DocConvertCustMst] (
    [CustNo]           INT           NOT NULL,
    [CustCode]         VARCHAR (15)  NULL,
    [CustName]         VARCHAR (150) NOT NULL,
    [OfficeAdd1]       VARCHAR (30)  NULL,
    [OfficeAdd2]       VARCHAR (30)  NULL,
    [OfficeAdd3]       VARCHAR (30)  NULL,
    [OfficeAdd4]       VARCHAR (30)  NULL,
    [GodownAdd1]       VARCHAR (30)  NULL,
    [GodownAdd2]       VARCHAR (30)  NULL,
    [GodownAdd3]       VARCHAR (30)  NULL,
    [GodownAdd4]       VARCHAR (30)  NULL,
    [CustDiscPreOnMrp] DECIMAL (18)  NULL,
    [TINNo]            VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([CustNo] ASC)
);

