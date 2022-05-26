CREATE TABLE [dbo].[TownMst] (
    [TownId]     INT           NOT NULL,
    [TownName]   VARCHAR (100) NOT NULL,
    [MainTownId] INT           NULL,
    PRIMARY KEY CLUSTERED ([TownId] ASC)
);

