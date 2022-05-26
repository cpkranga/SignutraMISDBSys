CREATE TABLE [dbo].[tblUser] (
    [UserId]       UNIQUEIDENTIFIER NOT NULL,
    [Username]     VARCHAR (50)     NULL,
    [Password]     VARCHAR (50)     NULL,
    [DisplayName]  VARCHAR (50)     NULL,
    [Email]        VARCHAR (50)     NULL,
    [MobileNumber] VARCHAR (50)     NULL,
    [IsActive]     TINYINT          NULL,
    [Deleted]      TINYINT          NULL,
    [CreatedBy]    UNIQUEIDENTIFIER NULL,
    [CreatedDate]  SMALLDATETIME    NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    [UpdatedDate]  SMALLDATETIME    NULL,
    [DeletedBy]    UNIQUEIDENTIFIER NULL,
    [DeletedDate]  SMALLDATETIME    NULL
);

