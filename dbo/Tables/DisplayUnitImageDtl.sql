CREATE TABLE [dbo].[DisplayUnitImageDtl] (
    [CompanyNo]     INT              NOT NULL,
    [DspUnitNo]     INT              NOT NULL,
    [ImageNo]       INT              NOT NULL,
    [ImagePath]     VARCHAR (100)    NULL,
    [ImageUploadOn] SMALLDATETIME    NULL,
    [ImageRemarks]  VARCHAR (100)    NULL,
    [SrNo]          INT              NULL,
    [UploadById]    UNIQUEIDENTIFIER NULL,
    [MdfOn]         SMALLDATETIME    NULL,
    CONSTRAINT [PK_DisplayUnitImageDtl] PRIMARY KEY CLUSTERED ([CompanyNo] ASC, [DspUnitNo] ASC, [ImageNo] ASC)
);

