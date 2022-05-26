create FUNCTION [dbo].[fnCheckSameUsrWithOtherArea]
(
    -- Add the parameters for the function here
    @UserId int,
    @AreaId int
)
RETURNS bit
AS
BEGIN
    IF  (SELECT  count(AreaId) FROM UserBrandAreaMatrix WHERE UserId=@UserId and AreaId!=@AreaId)>0
        return 1
    return 0
END

