CREATE TABLE [dbo].[CosMaterialGroupMst] (
    [GroupCode]    VARCHAR (2)   NOT NULL,
    [GroupName]    VARCHAR (100) NOT NULL,
    [RptGroupCode] VARCHAR (2)   NULL,
    PRIMARY KEY CLUSTERED ([GroupCode] ASC)
);

