USE AdventureWorks2012;
GO

DROP PROCEDURE [Production].[OrdersSummaryByMonths];
GO

CREATE PROCEDURE [Production].[OrdersSummaryByMonths]
    @chosenMonths NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sqlExpression NVARCHAR(512);
	SET @sqlExpression = 
		'SELECT [Year],' + @chosenMonths + '
		FROM
		(
			SELECT
				YEAR([W].[DueDate]) AS [Year],
				DATENAME(MONTH, [W].[DueDate]) AS [Month],
				[W].[OrderQty] AS [OrdersSummary]
			FROM
				[Production].[WorkOrder] AS [W]
		) AS [WO]
		PIVOT
		(
			SUM(OrdersSummary)
			FOR Month
			IN (' + @chosenMonths + ')
		) AS [Summary]';

	EXEC sp_executesql @sqlExpression;
END
GO

EXECUTE [Production].[OrdersSummaryByMonths] '[January],[February],[March],[April],[May],[June]';

GO
