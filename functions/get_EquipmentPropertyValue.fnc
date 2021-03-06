﻿--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentPropertyValue', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentPropertyValue;
GO
/*
   Function: get_EquipmentPropertyValue

   Функция вычитки поля Value из таблицы EquipmentProperty

   Parameters:

      EquipmentID                   - ID весов,
	  EquipmentClassPropertyValue   - Свойство.
     
   Returns:
	  
	  Значение свойства.

*/
CREATE FUNCTION dbo.get_EquipmentPropertyValue(@EquipmentID                 INT,
                                               @EquipmentClassPropertyValue [NVARCHAR](50))
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @Value [NVARCHAR](50);

SELECT @Value=ep.[Value]
FROM [dbo].[EquipmentProperty] ep
WHERE ep.[EquipmentID]=@EquipmentID
  AND ep.[ClassPropertyID]=dbo.get_EquipmentClassPropertyByValue(@EquipmentClassPropertyValue);

RETURN @Value;

END;
GO
