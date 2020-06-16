USE [Diablo]
GO
--Problem - 19
--Part-1
CREATE TRIGGER tr_RestrictHigherLevelOnUsers ON UserGameItems INSTEAD OF INSERT
AS 
 DECLARE @itemId INT = (SELECT ItemId FROM inserted)
 DECLARE @userGameId INT = (SELECT UserGameId FROM inserted)

 DECLARE @itemLevel INT = (SELECT MinLevel FROM Items WHERE Id = @itemId)
 DECLARE @userGameLevel INT = (SELECT [Level] FROM UsersGames WHERE Id = @userGameId)

 IF(@userGameLevel > @itemLevel)
 BEGIN
	INSERT INTO UserGameItems(ItemId, UserGameId)
	VALUES(
			@itemId, 
			@userGameId
		  )
 END
 
SELECT * 
	FROM Users AS u
	JOIN UsersGames AS ug 
	ON u.Id = ug.UserId
	WHERE u.Id = 61

SELECT * FROM Items WHERE Id = 2 

SELECT * FROM UserGameItems WHERE UserGameId = 38 AND ItemId = 14

INSERT INTO UserGameItems
VALUES(14, 38)

--Part-2
SELECT * FROM Users AS u
JOIN UsersGames AS ug 
ON u.Id = ug.UserId
JOIN Games AS g 
ON ug.GameId = g.Id
WHERE g.Name = 'Bali'

UPDATE UsersGames
SET Cash += 50000
WHERE GameId = (SELECT Id FROM Games WHERE [Name] ='Bali') AND 
	  UserId IN (SELECT Id FROM Users WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos'))

--Part-3
GO
DECLARE @itemId INT= 251;

WHILE(@itemId <= 299 OR @itemId <= 539)
BEGIN
	EXEC usp_BuyItems 12,@itemId, 212
	EXEC usp_BuyItems 22,@itemId, 212
	EXEC usp_BuyItems 37,@itemId, 212
	EXEC usp_BuyItems 52,@itemId, 212
	EXEC usp_BuyItems 61,@itemId, 212

	SET @itemId += 1;

	IF(@itemId = 299)
	BEGIN
		SET @itemId = 501
	END
END

SELECT * FROM UsersGames WHERE GameId = 212
GO

CREATE PROC usp_BuyItems (@UserId INT, @ItemId INT ,@GameId INT)
AS
BEGIN TRANSACTION
	DECLARE @user INT= (SELECT Id FROM Users WHERE Id = @UserId)
	DECLARE @item INT = (SELECT Id FROM Items WHERE Id = @ItemId)
	DECLARE @game INT = (SELECT Id FROM Games WHERE Id = @GameId)

	IF(@user IS NULL OR @item IS NULL OR @game IS NULL)
	BEGIN
		ROLLBACK;
		THROW 50003, 'Invalid inputs!', 1;
	END

 	DECLARE @currentCash DECIMAL(18,4) = (SELECT Cash FROM UsersGames WHERE UserId = @UserId AND GameId = @GameId)
	DECLARE @itemPrice DECIMAL(18,4) = (SELECT Price FROM Items WHERE Id = @ItemId)

	IF(@itemPrice > @currentCash)
	BEGIN
		ROLLBACK;
		THROW 50004, 'Not enough money!', 1;
	END

	DECLARE @userGameId INT = (SELECT Id FROM UsersGames WHERE UserId = @UserId AND GameId = @GameId)

	UPDATE UsersGames
	SET Cash -= @itemPrice
	WHERE UserId = @UserId AND GameId = @GameId
	
	INSERT INTO UserGameItems(ItemId, UserGameId)
	VALUES(@ItemId, @userGameId)
COMMIT

EXEC usp_BuyItems 61, 35, 212

--Part-4
SELECT u.Username, g.[Name], ug.Cash, i.[Name] AS [Item Name]
	FROM Users AS u
	JOIN UsersGames AS ug
	ON u.Id = ug.UserId
	JOIN Games AS g
	ON g.Id = ug.GameId
	JOIN UserGameItems AS ugi
	ON ugi.UserGameId = ug.Id
	JOIN Items AS i
	ON ugi.ItemId = i.Id
	WHERE g.[Name] = 'Bali'
	ORDER BY u.Username, i.[Name]

--Problem - 20
