CREATE TABLE [dbo].[DisplayUnit] (
    [CompanyNo]        INT              NOT NULL,
    [DspUnitNo]        INT              NOT NULL,
    [DspUnitName]      VARCHAR (100)    NOT NULL,
    [CustSuppNo]       INT              NULL,
    [CurrMerCounterNo] INT              NULL,
    [InstalledDate]    DATE             NULL,
    [AlterationDate]   DATE             NULL,
    [CurrPONo]         VARCHAR (20)     NULL,
    [UnitTypeNo]       INT              NULL,
    [IsActive]         TINYINT          NULL,
    [Remarks]          VARCHAR (100)    NULL,
    [MdfUserNo]        UNIQUEIDENTIFIER NULL,
    [MdfOn]            DATETIME         NULL,
    CONSTRAINT [PK_DisplayUnit] PRIMARY KEY CLUSTERED ([CompanyNo] ASC, [DspUnitNo] ASC)
);

