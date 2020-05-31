USE [Table-Relations]

CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	EstablishedOn DATE NOT NULL
)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerID INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers(ManufacturerID, Name, EstablishedOn)
VALUES	(1, 'BMW', '03/07/1916'),
		(2, 'Tesla', '03/07/1916'),
		(3, 'Lada', '05/01/1966')

INSERT INTO Models(ModelID, [Name], ManufacturerID)
VALUES	(101, 'X1', 1),
		(102, 'i6', 1),
		(103, 'Model S', 2),
		(104, 'Model X', 2),
		(105, 'Model 3', 2),
		(106, 'Nova', 3)

--SELECT * FROM Models AS mo
--JOIN Manufacturers AS ma
--ON mo.ManufacturerID = ma.ManufacturerID