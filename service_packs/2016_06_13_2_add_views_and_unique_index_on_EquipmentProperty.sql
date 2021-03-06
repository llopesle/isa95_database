﻿SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_EquipmentProperty_PrinterNo', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_EquipmentProperty_PrinterNo];
GO

CREATE VIEW [dbo].[v_EquipmentProperty_PrinterNo] WITH SCHEMABINDING
AS
SELECT ep.ID, ep.[Value], ep.[Description], ep.EquipmentID, ep.ClassPropertyID
FROM [dbo].[EquipmentProperty] ep
     INNER JOIN [dbo].[EquipmentClassProperty] ecp ON (ecp.ID=ep.ClassPropertyID AND ecp.Value=N'PRINTER_NO')
GO

CREATE UNIQUE CLUSTERED INDEX [u_EquipmentProperty_PrinterNo] ON [dbo].[v_EquipmentProperty_PrinterNo] (Value)
GO

IF OBJECT_ID ('dbo.v_EquipmentProperty_ScalesNo', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_EquipmentProperty_ScalesNo];
GO

CREATE VIEW [dbo].[v_EquipmentProperty_ScalesNo] WITH SCHEMABINDING
AS
SELECT ep.ID, ep.[Value], ep.[Description], ep.EquipmentID, ep.ClassPropertyID
FROM [dbo].[EquipmentProperty] ep
     INNER JOIN [dbo].[EquipmentClassProperty] ecp ON (ecp.ID=ep.ClassPropertyID AND ecp.Value=N'SCALES_NO')
GO

CREATE UNIQUE CLUSTERED INDEX [u_EquipmentProperty_ScalesNo] ON [dbo].[v_EquipmentProperty_ScalesNo] (Value)
GO