CREATE TABLE [dbo].[UserMst] (
    [UserId]     INT           NOT NULL,
    [UserCode]   VARCHAR (10)  NOT NULL,
    [UserName]   VARCHAR (100) NULL,
    [Pwd]        VARCHAR (10)  NULL,
    [UserMailId] VARCHAR (50)  NULL,
    [IsActive]   TINYINT       DEFAULT ((1)) NULL,
    [ManagerId]  INT           NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC),
    UNIQUE NONCLUSTERED ([UserCode] ASC),
    UNIQUE NONCLUSTERED ([UserName] ASC)
);

