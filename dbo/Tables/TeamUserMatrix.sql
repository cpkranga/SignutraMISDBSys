CREATE TABLE [dbo].[TeamUserMatrix] (
    [TeamId] INT NOT NULL,
    [UserId] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([TeamId] ASC, [UserId] ASC)
);

