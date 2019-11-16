USE AdventureWorks2012;
GO

-- Scalar-valued
CREATE FUNCTION [Production].[GetProductCountBySubcategoryID]
(
	@id INT
)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*) FROM [Product] WHERE [ProductSubcategoryID] = @id); 
END

GO

-- Inline table-valued
CREATE FUNCTION [Production].[GetProductsListFromSubcategoryWithPrice]
(
	@id INT
)
RETURNS TABLE
AS
	RETURN (SELECT * FROM [Product] WHERE [ProductSubcategoryID] = @id AND [StandardCost] > 1000.00);

GO

-- CROSS APPLY
SELECT * FROM [Production].[Product] CROSS APPLY [Production].[GetProductsListFromSubcategoryWithPrice]([ProductSubcategoryID]);

GO

-- OUTER APPLY
SELECT * FROM [Production].[Product] OUTER APPLY [Production].[GetProductsListFromSubcategoryWithPrice]([ProductSubcategoryID]);

GO

-- Multistatement table-valued
CREATE FUNCTION [Production].[GetProductsListFromSubcategoryWithPrice_Multistatement]
(
	@id INT
)
RETURNS @products TABLE
(
	[ProductID] INT NOT NULL PRIMARY KEY,
	[StandardCost] MONEY NOT NULL,
	[ProductNumber] NVARCHAR(25) NOT NULL,
	[ProductSubcategoryID] INT NOT NULL
)
AS
BEGIN
	INSERT INTO @products
		SELECT  
			[P].[ProductID],
			[P].[StandardCost],
			[P].[ProductNumber],
			[P].[ProductSubcategoryID]
		FROM [Production].[Product] AS [P]
		WHERE [ProductSubcategoryID] = @id AND [StandardCost] > 1000.00;

	RETURN;
END

GO
