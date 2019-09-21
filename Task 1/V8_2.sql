USE master;
GO

RESTORE DATABASE AdventureWorks2012
	FROM DISK = 'E:\BSUIR\БД\DB backup file\AdventureWorks2012-Full Database Backup.bak'
	WITH
		MOVE 'AdventureWorks2012_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2012_Data.mdf',
		MOVE 'AdventureWorks2012_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2012_Log.mdf';

GO

USE AdventureWorks2012;
GO

-- First subtask
SELECT BusinessEntityID, BirthDate, MaritalStatus, Gender, HireDate 
FROM [HumanResources].Employee
WHERE MaritalStatus = 'S' AND YEAR(BirthDate) <= 1960;

-- Second subtask
SELECT BusinessEntityID, JobTitle, MaritalStatus, Gender, HireDate 
FROM [HumanResources].Employee
WHERE JobTitle = 'Design Engineer';

-- Third subtask
SELECT BusinessEntityID, DepartmentID, StartDate, EndDate, YEAR(ISNULL(EndDate, GETDATE())) - YEAR(StartDate) AS 'YearsWorked'  
FROM [HumanResources].EmployeeDepartmentHistory
WHERE DepartmentID = 1

GO

USE master;
GO
