USE AdventureWorks2012;
GO

-- a
CREATE VIEW [CountryRegion_SalesTerritory_View]
WITH SCHEMABINDING
AS
	SELECT
		[CR].[CountryRegionCode],
		[CR].[ModifiedDate] AS [CountryRegion_ModifiedDate],
		[CR].[Name] AS [CountryName],
		[ST].[CostLastYear],
		[ST].[CostYTD],
		[ST].[Group],
		[ST].[ModifiedDate] AS [SalesTerritory_ModifiedDate],
		[ST].[Name] AS [SalesTerritoryName],
		[ST].[rowguid],
		[ST].[SalesLastYear],
		[ST].[SalesYTD],
		[ST].[TerritoryID]
	FROM [Person].[CountryRegion] AS [CR]
		INNER JOIN [Sales].[SalesTerritory] AS [ST]
		ON [CR].[CountryRegionCode] = [ST].[CountryRegionCode];
GO

CREATE UNIQUE CLUSTERED INDEX [UCX_CountryRegion_SalesTerritory_View_TerritoryID]
ON [dbo].[CountryRegion_SalesTerritory_View] ([TerritoryID]);
GO

-- b
CREATE TRIGGER [TR_CountryRegion_SalesTerritory_View_IO_IUD]
ON [dbo].[CountryRegion_SalesTerritory_View]
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	-- DELETE
	IF NOT EXISTS (SELECT * FROM [INSERTED])
	BEGIN
		DECLARE @crCode NVARCHAR(3);

		SELECT @crCode = [D].[CountryRegionCode] FROM [DELETED] AS [D];

		DELETE FROM [Sales].[SalesTerritory]
			WHERE [CountryRegionCode] = @crCode;
			
		DELETE FROM [Person].[CountryRegion]
			WHERE [CountryRegionCode] = @crCode;
	END

	-- INSERT
	ELSE IF NOT EXISTS (SELECT * FROM [DELETED])
	BEGIN
		IF NOT EXISTS
		(
			SELECT * FROM [Person].[CountryRegion] AS [CR] 
			INNER JOIN [INSERTED] AS [I]
			ON [I].[CountryRegionCode] = [CR].[CountryRegionCode]
		)
			INSERT INTO [Person].[CountryRegion]
			(
				[CountryRegionCode],
				[Name],
				[ModifiedDate]
			)
			SELECT 
				[I].[CountryRegionCode],
				[I].[CountryName],
				[I].[CountryRegion_ModifiedDate]
			FROM [INSERTED] AS [I];
		ELSE
			UPDATE [Person].[CountryRegion]
			SET
				[Name] = [I].[CountryName],
				[ModifiedDate] = [I].[CountryRegion_ModifiedDate]
			FROM [INSERTED] AS [I]
			WHERE [Person].[CountryRegion].[CountryRegionCode] = [I].[CountryRegionCode];

		INSERT INTO [Sales].[SalesTerritory]
		(
			[Name],
			[CountryRegionCode],
			[Group],
			[SalesYTD],
			[SalesLastYear],
			[CostYTD],
			[CostLastYear],
			[ModifiedDate]
		)
		SELECT 
			[I].[SalesTerritoryName],
			[I].[CountryRegionCode],
			[I].[Group],
			[I].[SalesYTD],
			[I].[SalesLastYear],
			[I].[CostYTD],
			[I].[CostLastYear],
			[I].[SalesTerritory_ModifiedDate]
		FROM [INSERTED] AS [I];
	END

	-- UPDATE
	ELSE
	BEGIN
		UPDATE [Person].[CountryRegion]
		SET 
			[Name] = [I].[CountryName],
			[ModifiedDate] = [I].[CountryRegion_ModifiedDate]
		FROM [Person].[CountryRegion] AS [CR]
			INNER JOIN [INSERTED] AS [I] 
			ON [CR].[CountryRegionCode] = [I].[CountryRegionCode];

		UPDATE [Sales].[SalesTerritory]
		SET 
			[Name] = [I].[SalesTerritoryName],
			[Group]= [I].[Group],
			[SalesYTD]= [I].[SalesYTD],
			[SalesLastYear]= [I].[SalesLastYear],
			[CostYTD]= [I].[CostYTD],
			[CostLastYear]= [I].[CostLastYear],
			[ModifiedDate] = [I].[SalesTerritory_ModifiedDate]
		FROM [Sales].[SalesTerritory] AS [ST]
			INNER JOIN [INSERTED] AS [I] 
			ON [ST].[TerritoryID] = [I].[TerritoryID];
	END
END
GO

-- c
INSERT INTO [dbo].[CountryRegion_SalesTerritory_View]
(
	[CountryRegionCode],
	[CountryName],
	[CountryRegion_ModifiedDate],
	[SalesTerritoryName],
	[Group],
	[SalesYTD],
	[SalesLastYear],
	[CostYTD],
	[CostLastYear],
	[rowguid],
	[SalesTerritory_ModifiedDate]
)
VALUES
(
	'NV',
	'NEVARK',
	GETDATE(),
	'NEVARK',
	'USA',
	100.0,
	300.0,
	50.0,
	25.0,
	NEWID(),
	GETDATE()
);
GO

UPDATE [dbo].[CountryRegion_SalesTerritory_View]
SET	
	[CountryName] = 'NevArk',
	[Group] ='Usa',
	[SalesLastYear] = 20.0
WHERE [CountryRegionCode] = 'NV';
GO

DELETE FROM [dbo].[CountryRegion_SalesTerritory_View]
WHERE [CountryRegionCode] = 'NV';
GO
