create FUNCTION dbo.fnCheckSameUsrWithOtherDivi
(
    -- Add the parameters for the function here
    @UserId int,
    @DiviCode varchar(3)
)
RETURNS bit
AS
BEGIN
    IF  (SELECT  count(DiviCode) FROM UserBrandAreaMatrix WHERE UserId=@UserId and DiviCode!=@DiviCode)>0
        return 1
    return 0
END
