CREATE TABLE [dbo].[DistributorTownMatrix] (
    [DistributorId] INT           NOT NULL,
    [TownId]        INT           NOT NULL,
    [DistTownCode]  VARCHAR (20)  NOT NULL,
    [UpdateOn]      SMALLDATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([DistributorId] ASC, [TownId] ASC),
    CONSTRAINT [uniqCosnDisTown] UNIQUE NONCLUSTERED ([DistributorId] ASC, [DistTownCode] ASC)
);

