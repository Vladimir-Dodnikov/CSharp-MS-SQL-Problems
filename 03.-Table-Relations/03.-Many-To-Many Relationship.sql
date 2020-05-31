USE [Table-Relations]

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID) NOT NULL,
	PRIMARY KEY (StudentID, ExamID) --create composite key
)

INSERT INTO Students(StudentID, Name)
VALUES	(1, 'Mila'), (2, 'Toni'), (3, 'Ron')

INSERT INTO Exams(ExamID, Name)
VALUES	(101, 'SpringMVC'), (102, 'Neo4j'), (103, 'Oracle 11g')

INSERT INTO StudentsExams
VALUES (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103)

--SELECT * FROM StudentsExams AS se
--JOIN Students AS s ON se.StudentID = s.StudentID
--JOIN Exams AS e ON se.ExamID = e.ExamID