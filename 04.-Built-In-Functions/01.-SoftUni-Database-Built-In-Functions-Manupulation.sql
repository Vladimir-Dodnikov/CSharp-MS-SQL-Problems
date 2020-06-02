USE SoftUni
--Problem-1
SELECT FirstName, LastName 
	FROM Employees
	WHERE FirstName LIKE 'SA%'

--Problem-2
SELECT FirstName, LastName 
	FROM Employees
	WHERE LastName LIKE '%ei%'

--Problem-3
SELECT FirstName 
	FROM Employees
	WHERE LastName LIKE '%ei%'

--Problem-4
SELECT FirstName 
	FROM Employees
	WHERE DepartmentID IN (3,10) AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005
									--YEAR(Hiredate) BETWEEN 1995 AND 2005
--Problem-5
SELECT [Name] 
	FROM Towns
	WHERE LEN([Name]) IN (5,6)
	ORDER BY [Name]

--Problem-6
SELECT TownID, [Name]
	FROM Towns
	WHERE [Name] LIKE '[MKBE]%'
		--LEFT([Name], 1) IN ('M', 'B', 'K', 'E')
		--SUBSTRING([Name], 1, 1) IN ('M', 'B', 'K', 'E')
	ORDER BY [Name]

--Problem-7
SELECT TownID, [Name]
	FROM Towns
	WHERE [Name] NOT LIKE '[RBD]%'
		--[Name] LIKE '[^RBD]%'
		--LEFT([Name], 1) NOT IN ('R', 'B', 'D')
		--SUBSTRING([Name], 1, 1) NOT IN ('R', 'B', 'D')
	ORDER BY [Name]

--Problem-8
GO
CREATE VIEW V_EmployeesHiredAfter2000 AS
	SELECT FirstName, LastName 
	FROM Employees
	WHERE YEAR(HireDate) > 2000

--Problem-9
SELECT FirstName, LastName 
	FROM Employees
	WHERE LEN(LastName) = 5

--Problem-10
SELECT EmployeeID, FirstName, LastName, Salary,
	DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC

--Problem-11
SELECT * FROM (SELECT EmployeeID, FirstName, LastName, Salary,
	DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000) AS [Temp]
	WHERE [Rank] = 2
	ORDER BY Salary DESC