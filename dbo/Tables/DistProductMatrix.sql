CREATE TABLE [dbo].[DistProductMatrix] (
    [DistId]          INT          NOT NULL,
    [ProductId]       INT          NOT NULL,
    [DistProductCode] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([DistId] ASC, [ProductId] ASC),
    CONSTRAINT [uniqCosn] UNIQUE NONCLUSTERED ([DistId] ASC, [DistProductCode] ASC)
);

