USE [SoftUni]
GO
--Problem - 21
CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
	DECLARE @projectsCount INT = (SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId)

	IF(@projectsCount >= 3)
	BEGIN
		ROLLBACK;
		RAISERROR('The employee has too many projects!', 16, 1)
		RETURN
	END

	INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
	VALUES(@emloyeeId, @projectID)
COMMIT

--Problem - 22
CREATE TABLE Deleted_Employees
(
	EmployeeId INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(30),
	JobTitle NVARCHAR(30) NOT NULL,
	DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID) NOT NULL,
	Salary DECIMAL(18,4) NOT NULL
)
GO

CREATE TRIGGER tr_FiredEmployees ON Employees FOR DELETE
AS
	INSERT INTO Deleted_Employees(FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary)
	(SELECT del.FirstName AS [FirstName], 
			del.LastName AS [LastName], 
			del.MiddleName AS [MiddleName], 
			del.JobTitle AS [JobTitle], 
			del.DepartmentID AS [DepartmentID], 
			del.Salary AS [Salary] 
		FROM deleted AS del)