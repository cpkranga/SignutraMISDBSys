CREATE TABLE [dbo].[DocConvertSTNHdr] (
    [StnNo]        VARCHAR (10)    NOT NULL,
    [StnDate]      SMALLDATETIME   NOT NULL,
    [StnOrderNo]   VARCHAR (50)    NULL,
    [StnOrderDate] SMALLDATETIME   NULL,
    [Remarks]      VARCHAR (100)   NULL,
    [CustNo]       INT             NULL,
    [TotQty]       INT             NULL,
    [TotAmt]       DECIMAL (14, 2) NULL,
    [TotMrpAmt]    DECIMAL (14, 2) NULL,
    CONSTRAINT [PK__DocConve__556021104F12BBB9] PRIMARY KEY CLUSTERED ([StnNo] ASC)
);

