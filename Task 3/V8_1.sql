USE ALEXEY_KOSYUK;
GO

-- a
ALTER TABLE [dbo].[Address] 
	ADD [PersonName] NVARCHAR(100);

-- b
DECLARE @addressVariable TABLE
(
	[AddressID] INT NOT NULL PRIMARY KEY,
	[AddressLine1] NVARCHAR(60) NOT NULL,
	[AddressLine2] NVARCHAR(60) NOT NULL,
	[City] NVARCHAR(30) NOT NULL,
	[StateProvinceID] INT NOT NULL,
	[PostalCode] NVARCHAR(15) NOT NULL,
	[ModifiedDate] DATETIME NOT NULL,
	[ID] INT NOT NULL UNIQUE,
	[PersonName] NVARCHAR(100) NULL
);

INSERT INTO @addressVariable
(
	[AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate],
	[ID],
	[PersonName]
)
SELECT
	[ADR].[AddressID],
	[ADR].[AddressLine1],
	[CR].[CountryRegionCode] + ', ' + [SP].[Name] + ', ' + [ADR].[City],
	[ADR].[City],
	[ADR].[StateProvinceID],
	[ADR].[PostalCode],
	[ADR].[ModifiedDate],
	[ADR].[ID],
	[ADR].[PersonName]
FROM [dbo].[Address] AS [ADR]
INNER JOIN [AdventureWorks2012].[Person].[StateProvince] AS [SP]
ON [ADR].[StateProvinceID] = [SP].[StateProvinceID]
	INNER JOIN [AdventureWorks2012].[Person].[CountryRegion] AS [CR]
	ON [CR].[CountryRegionCode] = [SP].[CountryRegionCode] AND [ADR].[StateProvinceID] = 77;

-- c
UPDATE [dbo].[Address]
SET
	[AddressLine2] = [VAR].[AddressLine2],
	[PersonName] = [PER].[FirstName] + ' ' + [PER].[LastName]
FROM @addressVariable AS [VAR]
INNER JOIN [AdventureWorks2012].[Person].[BusinessEntityAddress] AS [BEA]
ON [BEA].[AddressID] = [VAR].[AddressID]
	INNER JOIN [AdventureWorks2012].[Person].[Person] AS [PER]
	ON [PER].[BusinessEntityID] = [BEA].[BusinessEntityID];

-- d
DELETE [ADR]
FROM [dbo].[Address] AS [ADR]
INNER JOIN [AdventureWorks2012].[Person].[BusinessEntityAddress] AS [BEA]
ON [BEA].[AddressID] = [ADR].[AddressID]
	INNER JOIN [AdventureWorks2012].[Person].[AddressType] AS [AT]
	ON [AT].[AddressTypeID] = [BEA].[AddressTypeID] AND [AT].[Name] = 'Main Office';

-- e
ALTER TABLE [dbo].[Address]
	DROP COLUMN [PersonName];

SELECT [INF].[CONSTRAINT_NAME] FROM [ALEXEY_KOSYUK].INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE AS [INF]
	WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address';

SELECT [CON].[name]
FROM sys.default_constraints AS [CON]
	INNER JOIN sys.objects AS [OB]
	ON [CON].[parent_object_id] = [OB].[object_id] AND schema_name([OB].[schema_id]) + '.' + [OB].[name] = 'dbo.Address'
ORDER BY [CON].[name];

ALTER TABLE [dbo].[Address]
DROP CONSTRAINT
	[UQ__Address__3214EC2620FEED60],
	[CH_Address_StateProvinceID],
	[DF_Address_AddressLine2];

-- f
DROP TABLE [dbo].[Address];

GO
