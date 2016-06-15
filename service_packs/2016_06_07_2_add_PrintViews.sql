﻿SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintFile', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintFile];
GO

CREATE VIEW [dbo].[v_PrintFile]
AS
     SELECT mlp.ID,
            f.Name,
            f.FileType,
            f.[Data],
            pt.[Value] Property,
            mlp.MaterialLotID
     FROM [dbo].[Files] f,
          dbo.MaterialLotProperty mlp,
          dbo.PropertyTypes pt
     WHERE ISNUMERIC(mlp.[Value] + '.0e0')=1
	       AND mlp.[Value] = f.ID
           AND mlp.PropertyType = pt.ID
           AND pt.[Value] = N'TEMPLATE';
GO

IF OBJECT_ID('dbo.v_PrintProperties', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintProperties];
GO

CREATE VIEW [dbo].[v_PrintProperties]
AS
     SELECT NEWID() ID,
            mlp.MaterialLotID,
            N'MaterialLotProperty' [TypeProperty],
            pt.[Value] [PropertyCode],
            pt.[Description] [Description],
            mlp.Value
     FROM dbo.MaterialLot ml
          INNER JOIN dbo.MaterialLotProperty mlp ON(mlp.MaterialLotID = ml.ID)
          INNER JOIN dbo.PropertyTypes pt ON(pt.ID = mlp.PropertyType)
     UNION ALL
     SELECT NEWID() ID,
            ml.ID MaterialLotID,
            N'Weight' [TypeProperty],
            N'WEIGHT' [PropertyCode],
            N'Вес' [Description],
            CONVERT( NVARCHAR, ml.Quantity) Value
     FROM dbo.MaterialLot ml
     UNION ALL
     SELECT NEWID() ID,
            ml.ID MaterialLotID,
            N'FactoryNumber' [TypeProperty],
            N'FactoryNumber' [PropertyCode],
            N'Номер бирки' [Description],
            CONVERT( NVARCHAR, ml.FactoryNumber) Value
     FROM dbo.MaterialLot ml
     WHERE ml.FactoryNumber IS NOT NULL;
GO

IF OBJECT_ID('dbo.v_JobOrders', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_JobOrders];
GO

CREATE VIEW [dbo].[v_JobOrders]
AS
     SELECT ID,
            DispatchStatus,
		  WorkType,
		  Command,
		  CommandRule
     FROM dbo.JobOrder;
GO

IF OBJECT_ID('dbo.v_PrintJobs', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintJobs];
GO

