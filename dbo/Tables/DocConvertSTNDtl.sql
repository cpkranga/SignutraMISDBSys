CREATE TABLE [dbo].[DocConvertSTNDtl] (
    [StnNo]        VARCHAR (10)    NOT NULL,
    [MaterialCode] VARCHAR (16)    NOT NULL,
    [Lot]          VARCHAR (6)     NOT NULL,
    [Mrp]          DECIMAL (12, 2) NOT NULL,
    [BSP]          DECIMAL (12, 2) NOT NULL,
    [Qty]          INT             NULL,
    [Amount]       DECIMAL (12, 2) NULL,
    [SrNo]         INT             NOT NULL,
    CONSTRAINT [PK__DocConve__AA3ACCAF52E34C9D] PRIMARY KEY CLUSTERED ([StnNo] ASC, [MaterialCode] ASC, [Lot] ASC, [Mrp] ASC)
);

