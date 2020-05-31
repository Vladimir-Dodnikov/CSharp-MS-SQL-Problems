CREATE DATABASE [Table-Relations]

USE [Table-Relations]

	CREATE TABLE Passports
	(
		PassportID INT PRIMARY KEY IDENTITY(101, 1),
		PassportNumber NVARCHAR(8) NOT NULL
	)

	CREATE TABLE Persons
	(
		PersonID INT PRIMARY KEY,
		FirstName NVARCHAR(50) NOT NULL,
		Salary DECIMAL(7,2) NOT NULL,
		PassportID INT NOT NULL FOREIGN KEY REFERENCES Passports(PassportID) UNIQUE
	)
	--drop table Passports
	--drop table Persons

	INSERT INTO Passports(PassportNumber)
	VALUES ('N34FG21B'), ('K65LO4R7'), ('ZE657QP2')

	INSERT INTO Persons(PersonID, FirstName, Salary, PassportID)
	VALUES (1, 'Roberto', 43300, 102),
			(2, 'Tom', 56600, 103),
			(3, 'Yana', 60200, 101)