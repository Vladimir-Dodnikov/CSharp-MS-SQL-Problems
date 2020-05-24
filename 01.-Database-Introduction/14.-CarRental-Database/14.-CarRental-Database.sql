CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName NVARCHAR(30) NOT NULL,
	DailyRate INT NOT NULL,
	WeeklyRate INT NOT NULL,
	MonthlyRate INT NOT NULL,
	WeekendRate INT NOT NULL
)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
	VALUES
			('Limousine', 5, 3, 5, 4),
			('Combi', 2, 5, 8, 6),
			('Minivan', 8, 9, 10, 9)

CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	PlateNumber NVARCHAR(8) NOT NULL,
	Model NVARCHAR(10) NOT NULL,
	CarYear DATE NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Doors INT NOT NULL,
	Picture IMAGE,
	Condition NVARCHAR(10) NOT NULL,
	Available NVARCHAR(10) NOT NULL
)

INSERT INTO Cars(PlateNumber, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
VALUES
		('PA1234AP', 'Audi', '2016', 1, 4, 'asd', 'Used', 'Yes'),
		('CB888888', 'Bentley', '2015', 1, 2, 'asdf', 'Used', 'Yes'),
		('PB0033CB', 'BMW', '2010', 2, 2, 'asdfg', 'Used', 'Yes')

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	Title NVARCHAR(20) NOT NULL,
	Notes NTEXT
)

INSERT INTO Employees(FirstName, LastName, Title, Notes)
VALUES
		('Vladimir', 'Dodnikov', 'CEO', 'C# Architect'),
		('Peter', 'Pedigru', 'Engineer', 'Harry Potter'),
		('Boicho', 'Borisov', 'Back-end', 'C# DevOps')


CREATE TABLE Customers  (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DriverLicenceNumber INT NOT NULL,
	FullName NVARCHAR(40) NOT NULL,
	[Address] NVARCHAR(30),
	City NVARCHAR(30),
	ZIPCode NVARCHAR(6),
	Notes NTEXT
)

INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes)
VALUES
		('101662142', 'Gosho Goshev', 'Bulgaria 1 blv.', 'Sofia', '1000', NULL),
		('103871264', 'Petko Petkov', '1st may 19 str.', 'Velingrad', '4600', NULL),
		('101225678', 'Valeri Genov', 'Petko Machev 20 str.', 'Panagurishte', '4500', NULL)

CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
	TankLevel DECIMAL(4, 2) NOT NULL CHECK (TankLevel >= 0 AND TankLevel <=70),
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage AS (KilometrageEnd-KilometrageStart) PERSISTED,
	StartDate DATETIME2(3) NOT NULL,
	EndDate DATETIME2(3) NOT NULL,
	TotalDays AS (DATEDIFF(day, StartDate, EndDate)) PERSISTED,
	RateApplied INT NOT NULL,
	TaxRate INT NOT NULL,
	OrderStatus BIT NOT NULL,
	Notes NTEXT
)

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied,TaxRate, OrderStatus,Notes)
VALUES(2, 1, 2, 15.50, 20000, 35000, '2020-07-17 09:12:58.924', '2020-04-01 23:23:58.99223', 10, 10, 1, NULL),
	  (1, 2, 1, 70, 50000, 62345, '2019-11-13 16:12:58.924', '2020-04-01 06:23:58.99223', 10, 10, 0, NULL),
	  (3, 3, 3, 33.33, 0, 66582, '2020-02-12 09:12:58.924', '2020-05-19 23:19:58.99223', 10, 10, 1, NULL)