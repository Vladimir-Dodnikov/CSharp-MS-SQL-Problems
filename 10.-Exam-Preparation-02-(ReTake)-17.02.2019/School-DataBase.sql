CREATE DATABASE School

USE [School]

--Problem - 1
CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(25),
	LastName NVARCHAR(30) NOT NULL,
	Age INT NOT NULL CHECK(Age > 0),
	[Address] NVARCHAR(50), 
	Phone NCHAR(10)
)

CREATE TABLE Subjects	
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(20) NOT NULL,
	Lessons INT NOT NULL CHECK(Lessons > 0)
)

CREATE TABLE StudentsSubjects	
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
	SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
	Grade DECIMAL(3,2) NOT NULL CHECK(Grade BETWEEN 2 AND 6)
)

CREATE TABLE Exams	
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Date] DATETIME2,
	SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id)
)

CREATE TABLE StudentsExams	
(
	StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
	ExamId INT NOT NULL FOREIGN KEY REFERENCES Exams(Id),
	Grade DECIMAL(3,2) NOT NULL CHECK(Grade BETWEEN 2 AND 6)
	PRIMARY KEY(StudentId, ExamId)
)

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	[Address] NVARCHAR(20) NOT NULL,
	Phone NCHAR(10),
	SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id)
)

CREATE TABLE StudentsTeachers
(
	StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
	TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id),
	PRIMARY KEY(StudentId, TeacherId)
)

--Problem - 2 INSERT
INSERT INTO Teachers(FirstName, LastName, [Address], Phone, SubjectId)
VALUES
		('Ruthanne', 'Bamb', '84948 Mesta Junction', '3105500146', 6),
		('Gerrard', 'Lowin', '370 Talisman Plaza', '3324874824', 2),
		('Merrile', 'Lambdin', '81 Dahle Plaza', '4373065154', 5),
		('Bert', 'Ivie', '2 Gateway Circle', '4409584510', 4)

INSERT INTO sUBJECTS([Name], Lessons)
VALUES
		('Geometry', 12),
		('Health', 10),
		('Drama', 7),
		('Sports', 9)

--Problem - 3 UPDATE
UPDATE StudentsSubjects
SET Grade = 6.00
WHERE Grade >= 5.50 AND SubjectId IN (1, 2)

--SELECT SUM(Grade) FROM StudentsSubjects
--WHERE SubjectId IN (1,2)

--Problem - 4 DELETE
DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone LIKE '%72%')

DELETE FROM Teachers
WHERE Phone LIKE '%72%'

--Problem - 5
SELECT FirstName, LastName, Age 
	FROM Students
	WHERE Age >= 12
	ORDER BY FirstName, LastName

--Problem - 6
SELECT s.FirstName, s.LastName, COUNT(st.TeacherId) AS [TeachersCount] 
FROM Students AS s
JOIN StudentsTeachers AS st
ON s.Id = st.StudentId
GROUP BY s.FirstName, s.LastName

--Problem - 7
SELECT CONCAT(s.FirstName, ' ', s.LastName) AS [Full Name] FROM Students AS s
FULL OUTER JOIN StudentsExams AS se
ON s.Id = se.StudentId
WHERE se.Grade IS NULL
ORDER BY [Full Name]

--Problem - 8
SELECT TOP (10) s.FirstName, s.LastName, CONVERT(DECIMAL(3,2), AVG(se.Grade)) AS [Grade] FROM Students AS s
JOIN StudentsExams AS se
ON s.Id = se.StudentId
GROUP BY s.FirstName, s.LastName
ORDER BY Grade DESC, s.FirstName, s.LastName

--Problem - 9
SELECT CONCAT(COALESCE(FirstName + ' ', ''), COALESCE(MiddleName + ' ', ''), COALESCE(Lastname, '')) AS [Full Name] 
FROM Students AS s
LEFT OUTER JOIN StudentsSubjects AS ss
ON s.Id = ss.StudentId
WHERE ss.SubjectId IS NULL
GROUP BY s.FirstName, s.MiddleName, s.LastName
ORDER BY [Full Name]

--Problem - 10
SELECT s.Name, AVG(ss.Grade) AS [AverageGrade] FROM Subjects AS s
JOIN StudentsSubjects AS ss
ON s.Id = ss.SubjectId
GROUP BY s.[Name], ss.SubjectId
ORDER BY ss.SubjectId

--Problem - 11 Function
GO
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(3,2))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @studentExist INT = (
									SELECT TOP(1) StudentId 
									FROM StudentsExams 
									WHERE StudentId = @studentId
								)
	IF(@studentExist IS NULL)
	BEGIN
		RETURN 'The student with provided id does not exist in the school!'
	END

	IF(@grade > 6)
	BEGIN
		RETURN 'Grade cannot be above 6.00!'
	END

	DECLARE @higerGrade DECIMAL(3,2) = @grade + 0.5;
	
	DECLARE @countGrades INT = (
								SELECT COUNT(se.Grade) FROM StudentsExams AS se
								WHERE se.StudentId = @studentId AND (se.Grade >= @grade AND se.Grade <= @higerGrade)
								)

	DECLARE @firstName NVARCHAR(30) = (
										SELECT TOP(1) s.FirstName 
										FROM Students AS s 
										WHERE s.Id = @studentId
										)

	RETURN ('You have to update ' + CAST(@countGrades AS NVARCHAR(10)) + ' grades for the student ' + @firstName);
END
GO
SELECT dbo.udf_ExamGradesToUpdate(12, 6.20)
SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)
SELECT dbo.udf_ExamGradesToUpdate(121, 5.50)

--Problem - 12 Stored Procedure
GO
CREATE OR ALTER PROC usp_ExcludeFromSchool(@StudentId INT)
AS
DECLARE @studentExist INT = (
									SELECT TOP(1) StudentId 
									FROM StudentsExams 
									WHERE StudentId = @StudentId
								)
	IF(@studentExist IS NULL)
	BEGIN
		RAISERROR('This school has no student with the provided id!', 16, 1)
		RETURN
	END

	DELETE FROM StudentsExams
	WHERE StudentId = @studentExist

	DELETE FROM StudentsSubjects
	WHERE StudentId = @studentExist

	DELETE FROM StudentsTeachers
	WHERE StudentId = @studentExist

	DELETE FROM Students
	WHERE Id = @studentExist

GO
EXEC usp_ExcludeFromSchool 1
SELECT COUNT(*) FROM Students

EXEC usp_ExcludeFromSchool 301
