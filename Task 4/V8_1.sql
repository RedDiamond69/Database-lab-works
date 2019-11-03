USE ALEXEY_KOSYUK;
GO

-- a
CREATE SCHEMA [Person];
GO
	CREATE TABLE [Person].[CountryRegionHst]
	(
		[ID] INT IDENTITY(1, 1) PRIMARY KEY,
		[Action] NVARCHAR(6) NOT NULL,
		[ModifiedDate] DATETIME NOT NULL CONSTRAINT [DF_CountryRegionHst_ModifiedDate] DEFAULT GETDATE(),
		[SourceID] NVARCHAR(3) NOT NULL,
		[UserName] NVARCHAR(100) NOT NULL CONSTRAINT [DF_CountryRegionHst_UserName] DEFAULT CURRENT_USER,

		CONSTRAINT [CH_CountryRegionHst_Action] CHECK([Action] IN ('INSERT', 'UPDATE', 'DELETE'))
	);
GO

-- b
USE AdventureWorks2012;
GO
	-- AFTER INSERT
	CREATE TRIGGER [TR_CountryRegion_AI] ON [Person].[CountryRegion]
	AFTER INSERT
	AS
	BEGIN
		INSERT INTO [ALEXEY_KOSYUK].[Person].[CountryRegionHst]
		(
			[Action],
			[SourceID]
		)
		SELECT
			'INSERT',
			[I].[CountryRegionCode]
		FROM [INSERTED] AS [I];
	END
GO
	-- AFTER UPDATE
	CREATE TRIGGER [TR_CountryRegion_AU] ON [Person].[CountryRegion]
	AFTER UPDATE
	AS
	BEGIN
		INSERT INTO [ALEXEY_KOSYUK].[Person].[CountryRegionHst]
		(
			[Action],
			[SourceID]
		)
		SELECT
			'UPDATE',
			[I].[CountryRegionCode]
		FROM [INSERTED] AS [I];
	END
GO
	-- AFTER DELETE
	CREATE TRIGGER [TR_CountryRegion_AD] ON [Person].[CountryRegion]
	AFTER DELETE
	AS
	BEGIN
		INSERT INTO [ALEXEY_KOSYUK].[Person].[CountryRegionHst]
		(
			[Action],
			[SourceID]
		)
		SELECT
			'DELETE',
			[D].[CountryRegionCode]
		FROM [DELETED] AS [D];
	END
GO

-- c
CREATE VIEW [Person].[CountryRegion_View]
WITH ENCRYPTION
AS
	SELECT * FROM [Person].[CountryRegion];
GO

-- d
INSERT INTO [Person].[CountryRegion_View]
(
	[CountryRegionCode],
	[ModifiedDate],
	[Name]
)
VALUES
(
	'NV',
	GETDATE(),
	'Nevark'
);
GO

UPDATE [Person].[CountryRegion_View]
SET
	[ModifiedDate] = GETDATE(),
	[Name] = 'NEVARK'
WHERE [CountryRegionCode] = 'NV';
GO

DELETE FROM [Person].[CountryRegion_View]
WHERE [CountryRegionCode] = 'NV';
GO
