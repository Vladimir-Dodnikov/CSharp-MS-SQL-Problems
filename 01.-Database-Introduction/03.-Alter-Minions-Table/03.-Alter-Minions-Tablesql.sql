--CREATE DATABASE Minions

--USE Minions

--CREATE TABLE Minions(
--	Id INT PRIMARY KEY NOT NULL,
--	[Name] VARCHAR(50) NOT NULL,
--	Age TINYINT
--)
      
--CREATE TABLE Towns(
--	Id INT PRIMARY KEY NOT NULL,
--	[Name] NVARCHAR(50) NOT NULL,
--)

USE Minions

ALTER TABLE Minions
ADD TownId INT FOREIGN KEY REFERENCES Towns(Id)
