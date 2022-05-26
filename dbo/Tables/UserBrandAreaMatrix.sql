CREATE TABLE [dbo].[UserBrandAreaMatrix] (
    [AreaId]    INT         NOT NULL,
    [BrandCode] VARCHAR (2) NOT NULL,
    [UserId]    INT         NOT NULL,
    [DiviCode]  VARCHAR (3) NULL,
    [IsActive]  TINYINT     CONSTRAINT [DF_UserBrandAreaMatrix_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_UserBrandAreaMatrix] PRIMARY KEY CLUSTERED ([AreaId] ASC, [BrandCode] ASC, [IsActive] ASC)
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trgCheckSameUidWithOtherArea]
   ON  [dbo].[UserBrandAreaMatrix]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @UserId int
	declare @AreaId int
	select @UserId=i.UserId,@AreaId=i.AreaId from Inserted as i
    -- Insert statements for trigger here
    if (select count(distinct areaid) from UserBrandAreaMatrix where UserId=@UserId and AreaId=@AreaId)>1
	begin
		print(@UserId)
		print(@AreaId)
		
	end



END
