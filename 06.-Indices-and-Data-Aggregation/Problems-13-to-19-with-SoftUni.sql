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

--Problem - 17
SELECT COUNT(Salary) AS [Count]
	FROM Employees
	WHERE ManagerID IS NULL
	GROUP BY ManagerID

--Problem - 18
SELECT DepartmentID, Salary AS [ThirdHighestSalary]
	FROM (
			SELECT DepartmentID, Salary, DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
				FROM Employees
				GROUP BY DepartmentID, Salary
		 ) AS [SalaryRankQuery]
	WHERE SalaryRank = 3

--Problem - 19
SELECT TOP(10) FirstName, LastName, DepartmentID 
	FROM Employees AS e1
	WHERE e1.Salary > (
						SELECT AVG(Salary)
							FROM Employees AS e2
							WHERE e1.DepartmentID = e2.DepartmentID	
							GROUP BY DepartmentID	
					  )
	ORDER BY DepartmentID ASC

