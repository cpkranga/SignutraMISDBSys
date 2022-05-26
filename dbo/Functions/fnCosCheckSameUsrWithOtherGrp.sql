create FUNCTION [dbo].[fnCosCheckSameUsrWithOtherGrp]
(
    -- Add the parameters for the function here
    @CustGroupNo int,
    @UserNo int
)
RETURNS bit
AS
BEGIN
    IF  (SELECT  count(CustGroupNo) FROM CosUserCustGroupTypeMatrix WHERE UserNo=@UserNo and CustGroupNo!=@CustGroupNo)>0
        return 1
    return 0
END
