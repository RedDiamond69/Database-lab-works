USE ALEXEY_KOSYUK;
GO

-- First subtask
DROP TABLE [dbo].[Address];

CREATE TABLE [dbo].[Address] (
	[AddressID] INT NOT NULL PRIMARY KEY,
	[AddressLine1] NVARCHAR(60) NOT NULL,
	[AddressLine2] NVARCHAR(60) NULL,
	[City] NVARCHAR(30) NOT NULL,
	[StateProvinceID] INT NOT NULL,
	[PostalCode] NVARCHAR(15) NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
);

-- Second subtask
ALTER TABLE [dbo].[Address]
	ADD [ID] INT IDENTITY(1, 1) UNIQUE;

-- Third subtask
ALTER TABLE [dbo].[Address]
	ADD CONSTRAINT [CH_Address_StateProvinceID] CHECK([StateProvinceID] % 2 = 1);

-- Forth subtask
ALTER TABLE [dbo].[Address]
	ADD CONSTRAINT [DF_Address_AddressLine2] DEFAULT('Unknown') FOR [AddressLine2];

-- Fifth subtask
INSERT INTO [dbo].[Address] (
	[AddressID],
	[AddressLine1],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate]
)
SELECT [Adr].[AddressID]
	, [Adr].[AddressLine1]
	, [Adr].[City]
	, [Adr].[StateProvinceID]
	, [Adr].[PostalCode]
	, [Adr].[ModifiedDate] 
	FROM [AdventureWorks2012].[Person].[Address] AS [Adr]
	INNER JOIN [AdventureWorks2012].[Person].[StateProvince] AS [SP]
	ON [Adr].[StateProvinceID] = [SP].[StateProvinceID] AND [Adr].[StateProvinceID] % 2 = 1
	INNER JOIN [AdventureWorks2012].[Person].[CountryRegion] AS [CR]
	ON [CR].[CountryRegionCode] = [SP].[CountryRegionCode] AND SUBSTRING([CR].[Name], 1, 1) = 'a';

-- Sixth subtask
ALTER TABLE [dbo].[Address]
	ALTER COLUMN [AddressLine2] NVARCHAR(60) NOT NULL;

GO
