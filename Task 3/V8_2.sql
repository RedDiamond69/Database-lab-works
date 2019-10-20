USE [ALEXEY_KOSYUK]
GO

-- a
ALTER TABLE [dbo].[Address]
ADD
	[AccountNumber] NVARCHAR(15) NULL,
    [MaxPrice] MONEY NULL,
    [AccountID] AS 'ID' + [AccountNumber];

-- b
CREATE TABLE #AddressTemp (
	[ID] INT NOT NULL PRIMARY KEY,
	[AddressID] INT NOT NULL,
	[AddressLine1] NVARCHAR(60) NOT NULL,
	[AddressLine2] NVARCHAR(60) NULL,
	[City] NVARCHAR(30) NOT NULL,
	[StateProvinceID] INT NOT NULL,
	[PostalCode] NVARCHAR(15) NOT NULL,
	[ModifiedDate] DATETIME NOT NULL,
	[AccountNumber] NVARCHAR(15),
    [MaxPrice] MONEY
);

-- c
WITH MaxPrice_CTE ([BusinessEntityID], [MaxPrice])
AS
(
    SELECT
        [BusinessEntityID],
        MAX([StandardPrice]) AS [MaxPrice]
    FROM [AdventureWorks2012].[Purchasing].[ProductVendor]
    GROUP BY [BusinessEntityID]
)
INSERT INTO #AddressTemp
(
	[ID],
    [AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate],
	[AccountNumber],
	[MaxPrice]
)
SELECT
	[ADR].[ID],
    [ADR].[AddressID],
	[ADR].[AddressLine1],
	[ADR].[AddressLine2],
	[ADR].[City],
	[ADR].[StateProvinceID],
	[ADR].[PostalCode],
	[ADR].[ModifiedDate],
	[VEN].[AccountNumber],
	[MaxPrice_CTE].[MaxPrice]
FROM [dbo].[Address] AS [ADR]
INNER JOIN [AdventureWorks2012].[Person].[BusinessEntityAddress] AS [BEA]
ON [ADR].[AddressID] = [BEA].[AddressID]
	INNER JOIN [AdventureWorks2012].[Purchasing].[Vendor] AS [VEN]
	ON [VEN].[BusinessEntityID] = [BEA].BusinessEntityID
		INNER JOIN [MaxPrice_CTE]
		ON [VEN].[BusinessEntityID] = [MaxPrice_CTE].[BusinessEntityID];

-- d
DELETE FROM [dbo].[Address]
	WHERE [ID] = 293;

-- e
MERGE [dbo].[Address] AS [TARGET]
USING #AddressTemp AS [SOURCE]
ON ([TARGET].[ID] = [SOURCE].[ID])
WHEN MATCHED THEN
UPDATE 
	SET 
		[AccountNumber] = [SOURCE].[AccountNumber],
		[MaxPrice] = [SOURCE].[MaxPrice]
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
    [AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate],
	[AccountNumber],
	[MaxPrice]
)
VALUES
(
    [AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate],
	[AccountNumber],
	[MaxPrice]
)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

GO
