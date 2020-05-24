USE SoftUni
--Problem 2
SELECT * FROM Departments
--Problem 3
SELECT [Name] FROM Departments
--Problem 4
--SELECT * FROM Employees
SELECT FirstName, LastName, Salary FROM Employees
--Problem 5
SELECT FirstName, MiddleName, LastName FROM Employees
--Problem 6
SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Adress]
FROM Employees
--SELECT CONCAT(FirstName, '.', LastName, '@', 'softuni.bg') AS [Full Email Adress]
--FROM Employees
--Problem 7
SELECT DISTINCT Salary From Employees
--Problem 8
SELECT * FROM Employees WHERE JobTitle = 'Sales Representative'
--Problem 9
SELECT FirstName, LastName, JobTitle From Employees
WHERE Salary >=20000 AND Salary <= 30000
--WEHERE Salary BETWEEN 20000 AND 30000 
--Problem 10
SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [FullName] 
--SELECT CONCAT(FirstName, ' ', MiddleName + ' ', LastName) AS [FullName]
FROM Employees
WHERE Salary IN	(25000, 14000, 12500, 23600)
--Problem 11
SELECT FirstName, LastName 
FROM Employees
WHERE ManagerID IS NULL
--Problem 12
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC
--Problem 13
SELECT TOP(5) FirstName, LastName
FROM Employees
ORDER BY Salary DESC
--Problem 14
SELECT FirstName, LastName
FROM Employees
WHERE DepartmentID != 4
--Problem 15
SELECT * FROM Employees
ORDER BY Salary DESC, FirstName ASC, LastName DESC, MiddleName ASC
--Problem 16
GO --to do not underline create view syntax / from where the query starts /
CREATE VIEW [V_EmployeesSalaries]
AS
(SELECT FirstName, LastName, Salary FROM Employees)
DROP VIEW [V_EmployeesSalaries]
--Problem 17
GO
CREATE VIEW [V_EmployeeNameJobTitle]
AS
(SELECT CONCAT(FirstName, ' ', ISNULL(MiddleName, ''), ' ', LastName) AS [Full Name], JobTitle FROM Employees)
--Problem 18
SELECT DISTINCT JobTitle FROM Employees
--Problem 19
SELECT TOP(10) * FROM Projects
ORDER BY StartDate ASC, [Name] ASC
--Problem 20
SELECT TOP(7) FirstName, LastName, HireDate 
FROM Employees
ORDER BY HireDate DESC
--Problem 21
--First make Back-up of Softuni DB
UPDATE Employees
SET Salary += Salary*0.12
WHERE DepartmentID IN (1, 2, 4, 11)
SELECT Salary FROM Employees