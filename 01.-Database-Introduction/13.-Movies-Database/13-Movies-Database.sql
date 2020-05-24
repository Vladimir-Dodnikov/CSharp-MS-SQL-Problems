CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DirectorName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(100)
)

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	GenreName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(100)
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(100)
)

CREATE TABLE Movies(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Title NVARCHAR(20) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
	CopyrightYear DATE NOT NULL,
	[Length] INT NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Rating DECIMAL(2,1),
	Notes NVARCHAR(100)
)

INSERT INTO Directors(DirectorName, Notes)
	VALUES	('Vladimir Dodnikov', 'Five times Academy winner'),
			('John Fabrau', 'Action movies'),
			('Jim Kerry', 'Comedy movies'),
			('Bruce Willice', 'Action movies'),
			('Scarlet Johannson', 'Drama movies')

INSERT INTO Categories(CategoryName, Notes)
	VALUES	('Action', 'Fun, fresh'),
			('Comedy', 'Relax, smile'),
			('Drama', 'Intense, feel'),
			('Documentary', 'Facts, reality'),
			('Romantic', 'Love, happiness')

INSERT INTO Genres(GenreName, Notes)
	VALUES	('Actions', NULL),
			('Comedies', NULL),
			('Dramas', NULL),
			('Documentaries', NULL),
			('Romantics', NULL)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes)
	VALUES
			('Armaggedon', 4, '1997', 120, 1, 1, 5, NULL),
			('American Pie', 1, '1997', 90, 2, 2, 5, NULL),
			('Beautiful woman', 5, '2002', 100, 3, 3, 2, NULL),
			('9/11', 2, '1997', 220, 4, 4, 4, NULL),
			('Dear John', 1, '2008', 90, 5, 5, 5, NULL)