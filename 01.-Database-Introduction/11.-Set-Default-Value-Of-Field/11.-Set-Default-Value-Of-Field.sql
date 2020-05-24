USE Minions

--CREATE TABLE Users(
--	Id BIGINT PRIMARY KEY IDENTITY(1,1) NOT NULL,
--	Username CHAR(30) UNIQUE NOT NULL,
--	[Password] VARCHAR(26) NOT NULL,
--	ProfilePicture VARBINARY(MAX) CHECK(DATALENGTH(ProfilePicture)<=900*1024),
--	LastLoginTime DATETIME2 NOT NULL,
--	IsDeleted BIT NOT NULL

--)

--INSERT INTO Users(Username, [Password], LastLoginTime, IsDeleted)
--VALUES
--		--('Pesho0', '123456', '01.01.1990', 0)
--		--('Pesho1', '123456', '01-01-1990', 0),
--		--('Pesho4', '123456', '01-01-1990', 0),
--		--('Pesho3', '123456', '01-01-1990', 1),
--		--('Pesho20', '123456', '01-01-1990', 1)

--SELECT * FROM Users

--ALTER TABLE Users
--DROP CONSTRAINT [PK__Users__3214EC07065CEB7A]

--ALTER TABLE Users
--ADD CONSTRAINT PK_Users_CompositeIdUsername
--PRIMARY KEY(Id, Username)

--ALTER TABLE Users
--ADD CONSTRAINT CK__Users__PasswordLength
--CHECK (LEN([Password]) >= 5)

ALTER TABLE Users
ADD CONSTRAINT DF__Users__LastLoginTime
DEFAULT GETDATE() FOR LastLoginTime

INSERT INTO Users(Username, [Password], IsDeleted)
VALUES
		('PeshoNOTime', '123456', 0)

SELECT * FROM Users