USE [Bank]

--Problem - 9
GO
CREATE PROC usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
		FROM AccountHolders
END
EXEC usp_GetHoldersFullName

--Problem - 10
GO
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@minBalance DECIMAL(18,4))
AS
BEGIN
	SELECT ah.FirstName, ah.LastName 
		FROM Accounts AS a
		JOIN AccountHolders AS ah
		ON a.AccountHolderId = ah.Id
		GROUP BY FirstName, LastName
		HAVING SUM(Balance) > @minBalance
		ORDER BY FirstName, LastName
END
EXEC usp_GetHoldersWithBalanceHigherThan 19999

--Problem - 11
GO
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
	DECLARE @futureValue DECIMAL(18,4);
	--FORMULA FV = I × ((1+R)^T)
	SET @futureValue = @sum * (POWER((1 + @yearlyInterestRate), @numberOfYears));

	RETURN @futureValue;
END
GO
SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--Problem - 12
GO
CREATE PROC usp_CalculateFutureValueForAccount(@accountID INT, @yearlyInterestRate FLOAT)
AS
BEGIN
	SELECT ah.Id, ah.FirstName, ah.LastName, a.Balance, 
		   dbo.ufn_CalculateFutureValue(a.Balance, @yearlyInterestRate, 5) AS [Balance in 5 years]
		   FROM Accounts as a
	JOIN AccountHolders AS ah
	ON A.AccountHolderId = AH.Id
	WHERE a.Id = @accountID
END
EXEC usp_CalculateFutureValueForAccount 1, 0.1