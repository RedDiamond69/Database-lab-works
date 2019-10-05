USE AdventureWorks2012;
GO

-- First subtask
SELECT [Empl].[BusinessEntityID], [Empl].[OrganizationLevel], [Empl].[JobTitle], [JC].[JobCandidateID], [JC].[Resume] 
FROM [HumanResources].[Employee] AS [Empl]
	INNER JOIN [HumanResources].[JobCandidate] AS [JC]
	ON [Empl].[BusinessEntityID] = [JC].[BusinessEntityID]
	WHERE [JC].[Resume] IS NOT NULL;

-- Second subtask
SELECT [Dep].[DepartmentID], [Dep].[Name], COUNT(*) AS [EmpCount]
FROM [HumanResources].[Department] AS [Dep]
	INNER JOIN [HumanResources].[EmployeeDepartmentHistory] AS [EDH]
	ON [Dep].[DepartmentID] = [EDH].[DepartmentID]
	WHERE [EDH].[EndDate] IS NULL
	GROUP BY [Dep].[DepartmentID], [Dep].[Name]
	HAVING COUNT(*) > 10;

-- Third subtask
SELECT [Dep].[Name]
	, [Empl].[HireDate]
	, [Empl].[SickLeaveHours]
	, SUM([Empl].[SickLeaveHours]) OVER (PARTITION BY [Dep].[Name] ORDER BY [Empl].[Hiredate] ASC) AS [AccumulativeSum]
FROM [HumanResources].[Employee] AS [Empl]
	INNER JOIN [HumanResources].[EmployeeDepartmentHistory] AS [EDH]
	ON [Empl].[BusinessEntityID] = [EDH].[BusinessEntityID] AND [EDH].[EndDate] IS NULL
	INNER JOIN [HumanResources].[Department] AS [Dep]
	ON [Dep].[DepartmentID] = [EDH].[DepartmentID];

GO
