CREATE TABLE [dbo].[ManageMonth] (
    [CurrentYear]  INT      NULL,
    [CurrentMonth] INT      NULL,
    [UpdateOn]     DATETIME NULL
);


GO
CREATE trigger [dbo].[trgRemovePreviosRow] on [dbo].[ManageMonth]
for insert
as
delete from managemonth where Updateon < getdate()
