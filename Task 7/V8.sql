USE AdventureWorks2012;
GO

CREATE PROCEDURE XmlToTable
	@xml XML
AS
BEGIN
	SELECT
		Address.value('@ID', 'INT') AS [AddressID],
		Address.value('(City)[1]', 'NVARCHAR(30)') AS [City],
		Address.value('(Province/@ID)[1]', 'INT') AS [StateProvinceID],
		Address.value('(Province/Region)[1]', 'NVARCHAR(3)') AS [CountryRegionCode]
	FROM @xml.nodes('Addresses/Address') AS X(Address);
END;

GO

DECLARE @xml XML = 
	(SELECT
		[ADR].[AddressID] AS '@ID',
		[ADR].[City],
		[SP].[StateProvinceID] AS 'Province/@ID',
		[SP].[CountryRegionCode] AS 'Province/Region'
	FROM [Person].[Address] AS [ADR]
		INNER JOIN [Person].[StateProvince] AS [SP]
		ON [ADR].[StateProvinceID] = [SP].[StateProvinceID]
	FOR XML PATH('Address'), ROOT('Addresses'));

SELECT @xml;

EXEC XmlToTable @xml;

GO
