USE SoftUni

SELECT * FROM Employees

--Problem - 13
SELECT DepartmentID, SUM(Salary) AS [TotalSalary]
	FROM Employees
	GROUP BY DepartmentID
	ORDER BY DepartmentID

--Problem - 14
SELECT DepartmentID, MIN(Salary) AS [MinimumSalary]
	FROM Employees
	WHERE DepartmentID IN (2,5,7) AND HireDate > '2000-01-01'
	GROUP BY DepartmentID

--Problem - 15
SELECT * 
	INTO FilteredEmployees 
	FROM Employees
	WHERE Salary > 30000

DELETE
	FROM FilteredEmployees
	WHERE ManagerID = 42

UPDATE FilteredEmployees
	SET Salary += 5000
	WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS [AverageSalary]
	FROM FilteredEmployees
	GROUP BY DepartmentID

--Problem - 16
SELECT DepartmentID, Max(Salary) AS [MaxSalary]
	FROM Employees
	WHERE Salary < 30000 OR Salary > 70000
	GROUP BY DepartmentID
	