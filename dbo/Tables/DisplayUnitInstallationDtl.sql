CREATE TABLE [dbo].[DisplayUnitInstallationDtl] (
    [CompanyNo]     INT           NOT NULL,
    [DspUnitNo]     INT           NOT NULL,
    [InstalledFrom] DATE          NOT NULL,
    [InstalledTo]   DATE          NOT NULL,
    [PONo]          VARCHAR (20)  NULL,
    [MerCounterNo]  INT           NULL,
    [Remarks]       VARCHAR (100) NULL,
    CONSTRAINT [PK_DisplayUnitInstallationDtl] PRIMARY KEY CLUSTERED ([CompanyNo] ASC, [DspUnitNo] ASC, [InstalledFrom] ASC, [InstalledTo] ASC)
);

