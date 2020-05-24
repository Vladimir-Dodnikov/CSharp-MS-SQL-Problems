CREATE DATABASE Hotel

USE Hotel

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
	AccountNumber INT UNIQUE NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName NVARCHAR(30),
	EmergencyNumber INT NOT NULL,
	Notes NTEXT
	)

INSERT INTO Customers(AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
VALUES
		('101662142', 'Gosho', 'Goshev', 0889123123, 'Sofia', 0899123123, NULL),
		('103871264', 'Petko', 'Petkov', 088123, 'Velingrad', 0887123, NULL),
		('101225678', 'Valeri', 'Genov', 0899321321, 'Panagurishte', 0899160160, NULL)

CREATE TABLE RoomStatus  (
	RoomStatus NVARCHAR(30) UNIQUE NOT NULL,
	Notes NTEXT
)

INSERT INTO RoomStatus
VALUES('Do not enter', 'Repair'),
	  ('Free', 'Welcome'),
	  ('Busy', NULL)

CREATE TABLE RoomTypes   (
	RoomType NVARCHAR(30) UNIQUE NOT NULL,
	Notes NTEXT
)

INSERT INTO RoomTypes
VALUES('Penthouse', '2 stories brand new'),
	  ('Standard', '2 bed, 1 bathroom'),
	  ('VIP', '1 bed, 1 spa, 1 balcony')

CREATE TABLE BedTypes   (
	BedType NVARCHAR(30) UNIQUE NOT NULL,
	Notes NTEXT
)

INSERT INTO BedTypes
VALUES('Master', '250/250'),
	  ('Double', '200/200'),
	  ('OnePerson', '180/90')

CREATE TABLE Rooms(
	RoomNumber INT UNIQUE NOT NULL,
	RoomType NVARCHAR(30) REFERENCES RoomTypes(RoomType),
	BedType NVARCHAR(30) REFERENCES BedTypes(BedType),
	Rate INT NOT NULL,
	RoomStatus NVARCHAR(30) REFERENCES RoomStatus(RoomStatus),
	Notes NTEXT
)

INSERT INTO Rooms
VALUES(60, 'Penthouse', 'Master', 9, 'Free', NULL),
	  (62, 'VIP', 'Double', 8, 'Free', NULL),
	  (64, 'Standard', 'OnePerson', 5, 'Busy', NULL)

CREATE TABLE Payments(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATE NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays AS DATEDIFF(day, FirstDateOccupied, LastDateOccupied) PERSISTED,
	AmountCharged DECIMAL (6, 2) NOT NULL,
	TaxRate DECIMAL(14, 2) CHECK(TaxRate >= 0.01 AND TaxRate <= 1.00),
	TaxAmount AS (AmountCharged*TaxRate) PERSISTED NOT NULL,
	PaymentTotal AS (AmountCharged + AmountCharged*TaxRate) PERSISTED NOT NULL,
	Notes NTEXT
)

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, TaxRate, Notes)
	VALUES
			(1, '2020-05-19 20:20:20.20', 101662142, '2020-03-17', '2020-03-28', 888.88, 0.25, 'Great time'),
			(2, '2010-03-17 10:20:45.2423', 103871264, '2010-03-18', '2015-11-07', 502.94, 0.07, NULL),
			(3, '2016-01-01 00:01:00.00', 101225678, '2016-01-02', '2016-02-28', 243.88, 1, NULL)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied INT NOT NULL,
	PhoneCharge BIT NOT NULL,
	Notes NTEXT
)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
VALUES
		(1, '2020-03-17', 101662142, 60, 10, 0, NULL),
		(2, '2010-03-18', 103871264, 62, 8, 1, NULL),
		(3, '2016-01-02', 101225678, 64, 5, 1, NULL)

--Problem - 23
UPDATE Payments
SET TaxRate -= TaxRate*0.03

SELECT TaxRate FROM Payments

--Problem - 24
SELECT TaxRate FROM Payments
DELETE FROM Occupancies