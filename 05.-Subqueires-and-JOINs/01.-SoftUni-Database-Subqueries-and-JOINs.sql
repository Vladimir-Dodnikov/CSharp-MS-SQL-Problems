USE SoftUni

--Problem - 1
SELECT TOP (5) e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	ORDER BY e.AddressID ASC

--Problem - 2
SELECT TOP (50) e.FirstName, e.LastName, t.[Name] AS Town, a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	JOIN Towns AS t
	ON t.TownID = a.TownID
	ORDER BY e.FirstName ASC, e.LastName

--Problem - 3
SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS DepartmentName
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'
	ORDER BY e.EmployeeID ASC

--Problem - 4
SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.[Name] AS DepartmentName
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE e.Salary > 15000
	ORDER BY e.DepartmentID ASC

--Problem - 5
SELECT TOP(3) e.EmployeeID, e.FirstName
	FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	WHERE ep.ProjectID IS NULL
	ORDER BY e.EmployeeID ASC

--Problem - 6
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName 
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE e.HireDate > '1999-01-01' AND d.[Name] IN ('Sales', 'Finance')
	ORDER BY e.HireDate ASC

--Problem - 7
SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name] AS ProjectName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p
	ON p.ProjectID = ep.ProjectID
	WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID ASC

--Problem - 8
SELECT e.EmployeeID, e.FirstName, 
	CASE  
		WHEN DATEPART(YEAR, p.StartDate) >= 2005 THEN NULL
		ELSE p.[Name]
	END AS ProjectName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p
	ON p.ProjectID = ep.ProjectID
	WHERE e.EmployeeID = 24

--Problem - 9
SELECT e1.EmployeeID, e1.FirstName, e1.ManagerID, e2.FirstName AS ManagerName
	FROM Employees AS e1
	JOIN Employees AS e2
	ON e1.ManagerID = e2.EmployeeID
	WHERE e1.ManagerID IN (3,7)
	ORDER BY e1.EmployeeID ASC

--Problem - 10
SELECT TOP(50) e1.EmployeeID, CONCAT(e1.FirstName, ' ', e2.LastName) AS EmployeeName, 
				e2.FirstName + ' ' + e2.LastName AS ManagerName, d.[Name] AS DepartmentName
	FROM Employees AS e1
	LEFT OUTER JOIN Employees AS e2
	ON e1.ManagerID = e2.EmployeeID
	JOIN Departments AS d
	ON e1.DepartmentID = d.DepartmentID
	ORDER BY e1.EmployeeID ASC

--Problem - 11
SELECT MIN(AverageSalary) AS [MinAverageSalary]
	FROM (
			SELECT AVG(e.Salary) AS AverageSalary
				FROM Employees AS e
				GROUP BY e.DepartmentID
		 ) 
	AS [AverageSalaryByDepartments]