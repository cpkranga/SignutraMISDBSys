CREATE TABLE [dbo].[MerchantCounter] (
    [CompanyNo]      INT              NOT NULL,
    [MerCounterNo]   INT              NOT NULL,
    [MerCounterName] VARCHAR (100)    NOT NULL,
    [Address1]       VARCHAR (50)     NULL,
    [Address2]       VARCHAR (50)     NULL,
    [TelNo]          VARCHAR (50)     NULL,
    [DoorId]         VARCHAR (20)     NULL,
    [Remarks]        VARCHAR (100)    NULL,
    [IsActive]       TINYINT          CONSTRAINT [DF_MerchantCounter_IsActive] DEFAULT ((1)) NULL,
    [LastMonthSales] DECIMAL (12, 2)  NULL,
    [MdfUserNo]      UNIQUEIDENTIFIER NULL,
    [MdfOn]          DATETIME         NULL,
    CONSTRAINT [PK_MerchantCounter] PRIMARY KEY CLUSTERED ([CompanyNo] ASC, [MerCounterNo] ASC)
);

