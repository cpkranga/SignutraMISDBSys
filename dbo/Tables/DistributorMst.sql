CREATE TABLE [dbo].[DistributorMst] (
    [DistributorId]   INT           NOT NULL,
    [DistributorName] VARCHAR (100) NULL,
    [DistributorAdd]  VARCHAR (100) NULL,
    [IsActive]        TINYINT       DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([DistributorId] ASC)
);

