USE SoftUni

--Problem - 1
GO
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName, LastName
		FROM Employees
		WHERE Salary > 35000
END

EXEC usp_GetEmployeesSalaryAbove35000

--Problem - 2
GO
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@minSalary DECIMAL(18,4))
AS
BEGIN
SELECT FirstName, LastName
		FROM Employees
		WHERE Salary >= @minSalary
END
EXEC usp_GetEmployeesSalaryAboveNumber 48100

--Problem - 3
GO
CREATE PROC usp_GetTownsStartingWith(@input NVARCHAR(30))
AS
BEGIN
	SELECT [Name] AS [Towns]
		FROM Towns
		WHERE SUBSTRING([Name], 1, LEN(@input)) = SUBSTRING(@input, 1, LEN(@input))
END
EXEC usp_GetTownsStartingWith b

--Problem - 4
GO
CREATE PROC usp_GetEmployeesFromTown(@townName NVARCHAR(50))
AS
BEGIN
	SELECT e.FirstName, e.LastName 
		FROM Employees AS e
		JOIN Addresses AS a
		ON e.AddressID = a.AddressID
		JOIN Towns AS t
		ON t.TownID = a.TownID
		WHERE t.[Name] = @townName
END
EXEC usp_GetEmployeesFromTown 'Sofia'

--Problem - 5
GO
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS NVARCHAR(7)
AS
BEGIN
	DECLARE @salaryLevel NVARCHAR(7);
	IF (@salary < 30000)
	SET @salaryLevel = 'Low';
	ELSE IF (@salary >= 30000 AND @salary <= 50000)
	SET @salaryLevel = 'Average';
	ELSE IF (@salary > 50000)
	SET @salaryLevel = 'High'
	
	RETURN @salaryLevel;
END

GO
SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) FROM Employees

--Problem - 6
GO
CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel NVARCHAR(7))
AS
BEGIN
	SELECT FirstName, LastName 
		FROM Employees
		WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
END
EXEC usp_EmployeesBySalaryLevel 'Low'

--Problem - 7
GO
CREATE FUNCTION ufn_IsWordComprised (@setOfLetters NVARCHAR(30), @word NVARCHAR(30))
RETURNS BIT
AS
BEGIN 
	DECLARE @counter INT = 1;
	DECLARE @currentChar CHAR;
	WHILE @counter <= LEN(@word)
	BEGIN
		SET @currentChar = SUBSTRING(@word, @counter, 1)
		DECLARE @currentIndexInSetOfLetters INT = CHARINDEX(@currentChar, @setOfLetters);
			IF(@currentIndexInSetOfLetters <= 0)
				RETURN 0;
			SET @counter += 1;
	END

	RETURN 1;
END

--Problem - 8
GO
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	--SELECT EmployeeID 
	--	FROM Employees
	--	WHERE DepartmentID = @departmentId
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
							SELECT EmployeeID
							FROM Employees
							WHERE DepartmentID = @departmentId
						)
	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (
							SELECT EmployeeID
							FROM Employees
							WHERE DepartmentID = @departmentId
					   )
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT
	
	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (
							SELECT EmployeeID
							FROM Employees
							WHERE DepartmentID = @departmentId
					   )
	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId
END
EXEC usp_DeleteEmployeesFromDepartment 1