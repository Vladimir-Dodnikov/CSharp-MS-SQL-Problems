USE SoftUni

CREATE TABLE Towns(
	Id INT NOT NULL PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Adresses(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	AdressesText NVARCHAR(100) NOT NULL,
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Departments(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(30),
	LastName NVARCHAR(30) NOT NULL,
	JobTitle NVARCHAR(30) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
	HireDate DATE NOT NULL,
	Salary DECIMAL(7,2) NOT NULL,
	AdressId INT FOREIGN KEY REFERENCES Adresses(Id)
)

INSERT INTO Towns([Name])
	VALUES
			('Sofia'),
			('Plodviv'),
			('Varna'),
			('Bourgas')

INSERT INTO Departments
	VALUES
			('Engineering'),
			('Sales'),
			('Marketing'),
			('Software development'),
			('Quality Assurance')

INSERT INTO Employees(FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES('Ivan','Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
	  ('Petar','Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
	  ('Maria','Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
	  ('Georgi','Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
	  ('Peter','Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)


--Problems - 19, 
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees
--Problem - 20,
SELECT * FROM Towns
ORDER BY [Name] ASC
SELECT * FROM Departments
ORDER BY [Name] ASC
SELECT * FROM Employees
ORDER BY [Salary] DESC
--Problem - 21
SELECT Name FROM Towns ORDER BY Name
SELECT Name FROM Departments ORDER By Name
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC
SELECT Name FROM Towns ORDER BY Name
--Problem - 22
UPDATE Employees
SET Salary *= 1.1

SELECT Salary FROM Employees