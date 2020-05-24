USE Minions

CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(200) NOT NULL,
	Picture IMAGE,
	Height DECIMAL(7, 2),
	[Weight] DECIMAL(7, 2),
	Gender CHAR(1) NOT NULL,
	Birthdate DATE NOT NULL,
	Biography NTEXT
)

INSERT INTO People
	VALUES  ('Gosho', NULL, 1.81, 8.40, 'm', '1988-01-01', 'Born: Sofia, University: NBU'),
			('Goshka', NULL, 1.82, 87.0, 'f', '1988-02-01', 'Born: Sofia, University: UACEG'),
			('Koko', NULL, 1.83, 86.1, 'f', '1988-03-01', 'Born: Sofia, University: SU'),
			('Peter', NULL, 1.84, 85.22, 'm', '1988-04-01', 'Born: Sofia, University: SU'),
			('Anna', NULL, 1.85, 84.33, 'm', '1988-03-01', 'Born: Sofia, University: UACEG')

SELECT * FROM People