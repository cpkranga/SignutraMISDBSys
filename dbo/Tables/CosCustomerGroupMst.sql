CREATE TABLE [dbo].[CosCustomerGroupMst] (
    [GroupNo]        INT          NOT NULL,
    [GroupName]      VARCHAR (50) NULL,
    [GroupShortName] VARCHAR (20) NULL,
    [ProfitCenterNo] INT          NULL,
    PRIMARY KEY CLUSTERED ([GroupNo] ASC)
);

