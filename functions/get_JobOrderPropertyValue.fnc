﻿--------------------------------------------------------------
-- Процедура вычитки поля Value из таблицы Parameter
IF OBJECT_ID ('dbo.get_JobOrderPropertyValue', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_JobOrderPropertyValue;
GO

CREATE FUNCTION dbo.get_JobOrderPropertyValue(@JobOrderID   INT,
                                              @PropertyType [NVARCHAR](50))
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @Value [NVARCHAR](50);

SELECT @Value=p.[Value]
FROM [dbo].[Parameter] p
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=p.[PropertyType] AND pt.[Value]=@PropertyType)
WHERE (p.JobOrder=@JobOrderID);

RETURN @Value;

END;
GO
