CREATE TABLE [dbo].[CosUserMst] (
    [UserId]     INT           NOT NULL,
    [UserCode]   VARCHAR (10)  NOT NULL,
    [UserName]   VARCHAR (100) NULL,
    [Pwd]        VARCHAR (10)  NULL,
    [UserMailId] VARCHAR (50)  NULL,
    [IsActive]   TINYINT       NULL,
    [ManagerId]  INT           NULL
);

