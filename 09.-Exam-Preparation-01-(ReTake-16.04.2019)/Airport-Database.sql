CREATE DATABASE [Airport]

USE [Airport]

--01.-DDL
CREATE TABLE Planes
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	Seats INT NOT NULL,
	[Range] INT NOT NULL
)

CREATE TABLE Flights
(
	Id INT PRIMARY KEY IDENTITY,
	DepartureTime DATETIME,
	ArrivalTime DATETIME,
	Origin VARCHAR(50) NOT NULL,
	Destination VARCHAR(50) NOT NULL,
	PlaneId INT FOREIGN KEY REFERENCES Planes(Id) NOT NULL
)

CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Age INT NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	PassportId CHAR(11) NOT NULL
)

CREATE TABLE LuggageTypes
(
	Id INT PRIMARY KEY IDENTITY,
	[Type] VARCHAR(30)
)

CREATE TABLE Luggages
(
	Id INT PRIMARY KEY IDENTITY,
	LuggageTypeId INT FOREIGN KEY REFERENCES LuggageTypes(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
)

CREATE TABLE Tickets
(
	Id INT PRIMARY KEY IDENTITY,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	FlightId INT FOREIGN KEY REFERENCES Flights(Id) NOT NULL,
	LuggageId INT FOREIGN KEY REFERENCES Luggages(Id) NOT NULL,
	Price DECIMAL(15,2) NOT NULL
)
--02.-INSERT
INSERT INTO Planes (Name, Seats, Range) VALUES 
('Airbus 336', 112, 5132),
('Airbus 330', 432, 5325),
('Boeing 369', 231, 2355),
('Stelt 297', 254, 2143),
('Boeing 338', 165, 5111),
('Airbus 558', 387, 1342),
('Boeing 128', 345, 5541)

INSERT INTO LuggageTypes (Type) VALUES
('Crossbody Bag'),
('School Backpack'),
('Shoulder Bag')

--03.UPDATE
UPDATE Tickets
 SET Price *= 1.13
 WHERE FlightId IN (
					SELECT Id FROM Flights 
					WHERE Destination = 'Carlsbad'
				   )
--04.DELETE
DELETE FROM Tickets
WHERE FlightId IN (
					SELECT Id FROM Flights 
					WHERE Destination = 'Ayn Halagim'
				  )

DELETE FROM Flights
WHERE Destination = 'Ayn Halagim'

--QUERYING - NEED TO RESET DB, MAKE BACKUP
--05.WILDCARDS
SELECT Id, [Name], Seats, [Range] 
	FROM Planes
	WHERE [Name] LIKE '%Tr%'
	--WHERE CHARINDEX('tr', [Name], 1)
	ORDER BY Id, [Name], Seats, [Range]

--06.JOIN + GROUP BY
SELECT FlightId, SUM(Price) AS [TotalPrice] FROM Tickets
	GROUP BY FlightId
	ORDER BY TotalPrice DESC, FlightId

--SELECT t.FlightId, SUM(t.Price) AS [TotalPrice] FROM Flights AS f
--JOIN Tickets AS t
--ON f.Id = t.FlightId
--GROUP BY t.FlightId
--ORDER BY [TotalPrice] DESC, t.FlightId

--07.JOIN x 2, ORDER BY
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS [Full Name], f.Origin, f.Destination 
	FROM Passengers AS p
	JOIN Tickets AS t 
	ON t.PassengerId = p.Id
	JOIN Flights AS f 
	ON f.Id = t.FlightId
    ORDER BY [Full Name], f.Origin, f.Destination
		
--08.LEFT JOIN, WHERE, ORDER BY
SELECT p.FirstName, p.LastName, p.Age
	FROM Passengers AS p
	LEFT JOIN Tickets AS t ON t.PassengerId = p.Id
	WHERE t.Id IS NULL
	ORDER BY p.Age DESC, p.FirstName, p.LastName

--09.JOIN+ ALL TABLES
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS [Full Name], 
	   pl.Name AS [Plane Name], 
	   CONCAT(f.Origin, ' - ', f.Destination) AS [Trip], 
	   lt.[Type] AS [Luggage Type]
	FROM Passengers AS p
	JOIN Tickets AS t 
	ON t.PassengerId = p.Id
	JOIN Flights AS f 
	ON f.Id = t.FlightId
	JOIN Planes AS pl
	ON pl.Id = f.PlaneId
	JOIN Luggages AS l 
	ON l.Id = t.LuggageId
	JOIN LuggageTypes AS lt 
	ON lt.Id = l.LuggageTypeId
	ORDER BY [Full Name], [Name], Origin, Destination, [Type]

--10.  LEFT JOIN + GROUP BY
SELECT p.[Name], p.Seats, COUNT(t.Id) AS PassengersCount
	FROM Planes AS p
	LEFT JOIN Flights AS f 
	ON f.PlaneId = p.Id
	LEFT JOIN Tickets AS t 
	ON t.FlightId = f.Id
	GROUP BY p.[Name], p.Seats
	ORDER BY PassengersCount DESC, p.[Name], p.Seats

--11. Function
GO
CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(50), @destination VARCHAR(50), @peopleCount INT)
RETURNS VARCHAR(100)
AS
BEGIN

IF (@peopleCount <= 0)
BEGIN
	RETURN 'Invalid people count!'
END

DECLARE @flightId INT = (
							SELECT f.Id FROM Flights AS f
							JOIN Tickets AS t 
							ON t.FlightId = f.Id 
							WHERE Destination = @destination AND Origin = @origin
						)

IF (@flightId IS NULL)
BEGIN
	RETURN 'Invalid flight!'
END

DECLARE @ticketPrice DECIMAL(15,2) = (
										SELECT t.Price FROM Flights AS f
										JOIN Tickets AS t 
										ON t.FlightId = f.Id 
										WHERE Destination = @destination AND Origin = @origin
									 )

DECLARE @totalPrice DECIMAL(15, 2) = @ticketPrice * @peoplecount;

RETURN CONCAT('Total price ', @totalPrice);
END
--Test
GO
SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33) --2419.89
SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', -1) --Invalid people count!
SELECT dbo.udf_CalculateTickets('Invalid','Rancabolang', 33) --Invalid flight!

--12. Stored Procedure - wrong task condititon 
GO
CREATE PROC usp_CancelFlights
AS
UPDATE Flights
SET DepartureTime = NULL, ArrivalTime = NULL
WHERE ArrivalTime > DepartureTime

EXEC usp_CancelFlights