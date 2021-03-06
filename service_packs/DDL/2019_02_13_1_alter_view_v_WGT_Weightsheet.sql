﻿
IF OBJECT_ID ('dbo.v_WGT_Weightsheet',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_Weightsheet];
GO

/*
   View: v_WGT_Weightsheet
   Возвращает взвешивания вагонов для отвесной
*/
create view [dbo].[v_WGT_Weightsheet] as 

select
	 WO.[ID]
	,WO.[DocumentationsID]		as [WeightsheetID]
	,PUD.[PackagingUnitsID]		as [WagonID]
	,WO.[Description]			as [WagonNumber]
	,DP.[DocumentationsID]		as [WaybillID]
	,DP.[Value]					as [WaybillNumber]
	,cast(WOP.[Value] as real)	as [Carrying]
	,cast(WOP1.[Value] as real)	as [MarkedTare]
	,WO.[MaterialDefinitionID]	as [CargoTypeID]
	,MD.[Description]			as [CargoType]
	/* added ds 12.02.19 - test */
	,(select [SAPCode] from [dbo].[v_WGT_Materials] where ID = WO.[MaterialDefinitionID]) as [CargoSAPCode]
	,DP1.[Value]				as [CargoTypeNotes]
	--,WO.[EquipmentID]			as [WeighbridgeID]
	--,[PackagingUnitsDocsID]
	,WO.[Brutto]
	,WO.[Tara]
	,WO.[Netto]
	--,[OperationType]
	,WO.[Status]
	--,WO.[OperationTime]
	,convert(nvarchar(10) ,cast(WO.[OperationTime] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast(WO.[OperationTime] as datetime), 108) as [OperationTime]
	--,WO.[TaringTime]
	,convert(nvarchar(10) ,cast(WO.[TaringTime] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast(WO.[TaringTime] as datetime), 108) as [TaringTime]
	--,PUDP.*
	--,D.*
	--,PUD.*
	--,DP.*
	,PUDP.[DWWagonID]
	,convert(nvarchar(10) ,cast(PUDP.[OriginalDate] as datetime), 104) + ' ' + convert(nvarchar(8) ,cast(PUDP.[OriginalDate] as datetime), 108) as [OriginalDate]
FROM [dbo].[WeightingOperations] WO
left join 
	(select
		 [PackagingUnitsDocsID]
		,[Путевая]		as [WaybillID]
		,[Род груза]	as [CargoTypeID]
		,[DWWagonID]	as [DWWagonID]
		,[OriginalDate] as [OriginalDate]
	from (
		select
			 [PackagingUnitsDocsID]
			,[Description]
			,[Value]
		from [dbo].[PackagingUnitsDocsProperty] PUDP) as T
	pivot( max([Value]) for [Description] in ([Путевая], [Род груза], [DWWagonID], [OriginalDate])) as pvt) as PUDP
on PUDP.[PackagingUnitsDocsID] = WO.[PackagingUnitsDocsID]
left join [dbo].[MaterialDefinition] MD
on PUDP.[CargoTypeID] = MD.[ID]
left join [dbo].[v_WGT_DocumentsProperty] DP
on DP.[DocumentationsID] = PUDP.[WaybillID] and DP.[Description] = N'Номер путевой'
left join [dbo].[v_WGT_DocumentsProperty] DP1
on DP1.[DocumentationsID] = PUDP.[WaybillID] and DP1.[Description] = N'Примечание к роду груза'
left join [dbo].[PackagingUnitsDocs] PUD
on PUD.ID = WO.[PackagingUnitsDocsID]
left join [dbo].[WeightingOperationsProperty] WOP
on WOP.[WeightingOperationsID] = WO.[ID] and WOP.[Description] = N'Грузоподъемность'
left join [dbo].[WeightingOperationsProperty] WOP1
on WOP1.[WeightingOperationsID] = WO.[ID] and WOP1.[Description] = N'Тара с бруса'


GO