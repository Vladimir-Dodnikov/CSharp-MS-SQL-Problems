USE Minions

--CREATE TABLE Users(
--	Id BIGINT PRIMARY KEY IDENTITY(1,1) NOT NULL,
--	Username CHAR(30) UNIQUE NOT NULL,
--	[Password] VARCHAR(26) NOT NULL,
--	ProfilePicture VARBINARY(MAX) CHECK(DATALENGTH(ProfilePicture)<=900*1024),
--	LastLoginTime DATETIME2 NOT NULL,
--	IsDeleted BIT NOT NULL

--)

--INSERT INTO Users
--VALUES
--		('Pesho','123456', NULL, '01.01.1990', 0),
--		('Pesho1','123456', NULL, '01-01-1990', 0),
--		('Pesho4','123456', NULL, '01-01-1990', 0),
--		('Pesho3','123456', NULL, '01-01-1990', 1),
--		('Pesho2','123456', NULL, '01-01-1990', 1)

--SELECT * FROM Users

--ALTER TABLE Users
--DROP CONSTRAINT [PK__Users__3214EC078CD835F6]

--ALTER TABLE Users
--ADD CONSTRAINT PK_Users_CompositeIdUsername
--PRIMARY KEY(Id, Username)

ALTER TABLE Users
ADD CONSTRAINT CK__Users__PasswordLength
CHECK (LEN([Password]) >= 5

--INSERT INTO Users
--VALUES
--		('Peshoasas','126', NULL, '01.01.1990', 0)