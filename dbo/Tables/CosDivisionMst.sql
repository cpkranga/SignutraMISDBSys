CREATE TABLE [dbo].[CosDivisionMst] (
    [DivisionNo]      INT          NOT NULL,
    [DivisionCode]    VARCHAR (3)  NULL,
    [DivisionName]    VARCHAR (50) NULL,
    [RptDivisionCode] VARCHAR (3)  NULL,
    PRIMARY KEY CLUSTERED ([DivisionNo] ASC)
);

