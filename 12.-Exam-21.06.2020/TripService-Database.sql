CREATE DATABASE TripService
USE TripService

--DDL - Part 1
--Problem 1
CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	CountryCode NCHAR(2) NOT NULL
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	CityId INT NOT NULL REFERENCES Cities(Id),
	EmployeeCount INT NOT NULL,
	BaseRate DECIMAL(5,2)
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(15,2) NOT NULL,
	[Type] NVARCHAR(20) NOT NULL,
	Beds INT NOT NULL,
	HotelId INT NOT NULL REFERENCES Hotels(Id)
)

CREATE TABLE Trips
(
	Id INT PRIMARY KEY IDENTITY,
	RoomId INT NOT NULL REFERENCES Rooms(Id),
	BookDate DATETIME NOT NULL,
	ArrivalDate DATETIME NOT NULL,
	ReturnDate DATETIME NOT NULL,
	CancelDate DATETIME,
	CONSTRAINT BookCheck CHECK(BookDate < ArrivalDate), 
	CONSTRAINT ArrivalCheck CHECK(ArrivalDate < ReturnDate)
)

CREATE TABLE Accounts
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(20),
	LastName NVARCHAR(50) NOT NULL,
	CityId INT NOT NULL REFERENCES Cities(Id),
	BirthDate DATETIME NOT NULL,
	Email NVARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE AccountsTrips
(
	AccountId INT NOT NULL REFERENCES Accounts(Id),
	TripId INT NOT NULL REFERENCES Trips(Id),
	Luggage INT NOT NULL CHECK(Luggage >= 0),
	PRIMARY KEY (AccountId, TripId)
)
drop table Cities
--DML Part 2
--Problem 2
INSERT INTO Accounts(FirstName, MiddleName, LastName, CityId, BirthDate, Email)
VALUES
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL,	'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov',59, '1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO Trips(RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
VALUES
(101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
(103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
(104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
(109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)

--Problem 3
UPDATE Rooms SET Price = Price * 1.14
WHERE HotelId IN (5,7,9)

--Problem 4

DELETE FROM AccountsTrips
WHERE AccountId = 47

--Part 3 - Querrying
--Problem 5
GO
SELECT a.FirstName, a.LastName, a.BirthDate, c.[Name] AS [HomeTown], a.Email FROM Accounts AS a
JOIN Cities AS c ON a.CityId = c.Id
WHERE a.Email LIKE 'e%'
ORDER BY c.Name

--Problem 6
SELECT c.[Name] AS [City], COUNT(h.Name) AS [Hotels] FROM Cities AS c
JOIN Hotels AS h ON h.CityId = c.Id
GROUP BY c.[Name]
ORDER BY [Hotels] DESC

--Problem 7
SELECT	acct.AccountId,
		(a.FirstName + ' ' + a.LastName) AS [FullName],
		MAX(DATEDIFF(day, tr.ArrivalDate, tr.ReturnDate)) AS [LongestTrip],
		MIN(DATEDIFF(day, tr.ArrivalDate, tr.ReturnDate)) AS [ShortestTrip]
FROM Accounts AS a
JOIN AccountsTrips AS acct ON acct.AccountId = a.Id
JOIN Trips AS tr ON tr.Id = acct.TripId
WHERE a.MiddleName IS NULL AND tr.CancelDate IS NULL
GROUP BY acct.AccountId, (a.FirstName + ' ' + a.LastName)
ORDER BY LongestTrip DESC, ShortestTrip ASC

--Problem 8
SELECT TOP(10)
		c.Id, 
		c.Name AS City,
		c.CountryCode AS Country,
		COUNT(c.Id) AS Accounts 
FROM Accounts AS a
LEFT JOIN Cities AS c on a.CityId = c.Id
GROUP BY c.Name, c.Id, c.CountryCode
ORDER BY Accounts DESC

--Problem 9
SELECT 
		a.Id, a.Email, 
		c.Name AS [City], 
		COUNT(c.Name) AS [Trips]
FROM Accounts AS a
LEFT JOIN AccountsTrips AS act ON a.Id = act.AccountId
LEFT JOIN Trips AS tr ON act.TripId = tr.Id
LEFT JOIN Rooms AS r ON r.Id = tr.RoomId
LEFT JOIN Hotels AS h ON h.Id = r.HotelId
LEFT JOIN Cities AS c ON h.CityId = c.Id
WHERE a.CityId = h.CityId
GROUP BY c.Name, a.Id, a.Email
ORDER BY Trips DESC, a.Id

--Problem 10
SELECT	tr.Id, 
		CASE
			WHEN a.MiddleName IS NOT NULL THEN CONCAT(a.FirstName, ' ', a.MiddleName, ' ', a.LastName)
			ELSE CONCAT(a.FirstName, ' ', a.LastName)
		END AS [Full Name],
		c1.Name AS [Hometown],
		c2.Name AS [To],
		CASE
			WHEN tr.CancelDate IS NULL THEN CONVERT(NVARCHAR(MAX), DATEDIFF(DAY, tr.ArrivalDate, tr.ReturnDate)) + ' days'
			ELSE 'Canceled'
		END AS [Duration]
FROM Trips AS tr
JOIN AccountsTrips AS act ON act.TripId = tr.Id
JOIN Accounts AS a ON a.Id = act.AccountId
JOIN Cities AS c1 ON c1.Id = a.CityId
JOIN Rooms AS r ON r.Id = tr.RoomId
JOIN Hotels AS h ON h.Id = r.HotelId
JOIN Cities AS c2 ON c2.Id = h.CityId
ORDER BY [Full Name], tr.Id

--Part 4 - Programmability
--Problem 11
GO
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATETIME, @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @ArrivalDate DATETIME = (SELECT TOP(1) ArrivalDate FROM Trips AS tr JOIN Rooms AS r ON r.Id = tr.RoomId WHERE r.HotelId = @HotelId);
	DECLARE @ReturnDate DATETIME = (SELECT TOP(1) ReturnDate FROM Trips AS tr JOIN Rooms AS r ON r.Id = tr.RoomId WHERE r.HotelId = @HotelId);
	DECLARE @CancelDate DATETIME = (SELECT TOP(1) CancelDate FROM Trips AS tr JOIN Rooms AS r ON r.Id = tr.RoomId WHERE r.HotelId = @HotelId);

	IF(@Date >= @ArrivalDate AND @Date <= @ReturnDate AND @CancelDate IS NOT NULL)
	BEGIN
		RETURN 'Room is ocupied for that date.';
	END

	DECLARE @Room INT = (SELECT TOP(1) Id FROM Rooms WHERE Beds > @People AND HotelId = @HotelId ORDER BY Price DESC);

	IF(@Room IS NULL) 
	BEGIN
		RETURN 'No rooms available';
	END

	DECLARE @RoomBeds INT = (SELECT TOP(1) Beds FROM Rooms WHERE HotelId = @HotelId ORDER BY Beds DESC);

	IF(@RoomBeds < @People) 
	BEGIN
		RETURN 'This room doesn''t have enough beds.';
	END

	DECLARE @HotelBaseRate DECIMAL(5,2) = (SELECT BaseRate FROM Hotels WHERE Id = @HotelId);

	DECLARE @RoomPrice DECIMAL(15,2) = (SELECT TOP(1) Price FROM Rooms WHERE HotelId = @HotelId ORDER BY Price DESC);

	DECLARE @TotalPriceRoom DECIMAL(18,2) = (@HotelBaseRate + @RoomPrice) * @People;

	DECLARE @RoomType NVARCHAR(20) = (SELECT TOP(1) [Type] FROM Rooms WHERE Price = @RoomPrice);
	
	RETURN ('Room ' + CAST(@Room AS NVARCHAR(10)) + ': ' + @RoomType + ' (' + CAST(@RoomBeds AS NVARCHAR(10)) + ' beds) - $' + CAST(@TotalPriceRoom AS NVARCHAR(10)));
END

--DROP FUNCTION  dbo.udf_GetAvailableRoom
GO
SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)

--Problem 12
GO
CREATE PROCEDURE usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
BEGIN
    DECLARE @hotelId INT = (
							SELECT TOP(1) h.Id FROM Trips AS tr
							JOIN Rooms AS r ON r.Id = tr.RoomId 
							JOIN Hotels AS h ON h.Id = r.HotelId
							WHERE tr.Id = @TripId
						   )
 
    DECLARE @targetHotelId INT = (
									SELECT TOP(1) Hotels.Id FROM Rooms
									JOIN Hotels ON Hotels.Id = Rooms.HotelId
									WHERE Rooms.Id = @TargetRoomId
								 )
 
    IF(@hotelId != @targetHotelId) THROW 50001, 'Target room is in another hotel!', 1;
 
    DECLARE @TripAccounts INT = (
									SELECT COUNT(Id) FROM AccountsTrips as act
									JOIN Accounts AS a ON a.Id = act.AccountId
									WHERE act.TripId = @TripId
								 )
 
    DECLARE @RoomBeds INT = (SELECT Beds FROM Rooms WHERE Id = @TargetRoomId)
 
    IF(@TripAccounts > @RoomBeds) THROW 50002, 'Not enough beds in target room!', 1;
 
    UPDATE Trips
    SET RoomId = @TargetRoomId
    WHERE Trips.Id = @TripId
END

EXEC usp_SwitchRoom 10, 11
SELECT RoomId FROM Trips WHERE Id = 10
EXEC usp_SwitchRoom 10, 7
EXEC usp_SwitchRoom 10, 8