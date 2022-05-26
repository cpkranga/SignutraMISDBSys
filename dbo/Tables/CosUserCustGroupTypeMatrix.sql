CREATE TABLE [dbo].[CosUserCustGroupTypeMatrix] (
    [CustGroupNo] INT NOT NULL,
    [CustTypeNo]  INT NOT NULL,
    [UserNo]      INT NOT NULL,
    PRIMARY KEY CLUSTERED ([CustGroupNo] ASC, [CustTypeNo] ASC, [UserNo] ASC),
    CHECK ([dbo].[fnCosCheckSameUsrWithOtherGrp]([CustGroupNo],[UserNo])=(0))
);

