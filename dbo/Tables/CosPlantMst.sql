CREATE TABLE [dbo].[CosPlantMst] (
    [PlantNo]            INT           NOT NULL,
    [PlantCode]          VARCHAR (4)   NULL,
    [PlantName]          VARCHAR (100) NULL,
    [PlantSalesTypeCode] VARCHAR (1)   NOT NULL,
    CONSTRAINT [PK__CosPlant__98FE310F2C88998B] PRIMARY KEY CLUSTERED ([PlantNo] ASC)
);

