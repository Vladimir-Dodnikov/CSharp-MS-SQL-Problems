USE [Bank]

--Problem - 14
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY NOT NULL,
	AccountId INT NOT NULL,
	OldSum DECIMAL(18,4) NOT NULL,
	NewSum DECIMAL(18,4)
)
GO
--submit start
CREATE TRIGGER tr_AddEntryToLogs ON Accounts FOR UPDATE
AS
	DECLARE @OldSum DECIMAL(18,4) = (SELECT Balance FROM deleted)
	DECLARE @NewSum DECIMAL(18,4) = (SELECT Balance FROM inserted)
	DECLARE @AccountID INT = (SELECT Id FROM inserted)

INSERT INTO Logs(AccountId, OldSum, NewSum)
VALUES 
	(
		@AccountID, 
		@OldSum, 
		@NewSum
	)
--submit end
--DROP TRIGGER tr_AddEntryToLogs

 UPDATE Accounts
 SET Balance += 610.00
 WHERE Id= 6

SELECT *
	FROM Accounts 
	WHERE Id = 6

SELECT * 
	FROM Logs

--Problem - 15
CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Recipient INT FOREIGN KEY REFERENCES Accounts(Id) NOT NULL, 
	[Subject] NVARCHAR(50) NOT NULL, 
	Body NVARCHAR(100) NOT NULL
)
GO
--submit start
CREATE TRIGGER tr_InsertNewEmails ON Logs FOR INSERT
AS
	DECLARE @AccountId INT = (SELECT TOP(1) AccountId FROM inserted)
	DECLARE @Subject NVARCHAR(50) =  'Balance change for account: '+ CAST(@AccountId AS VARCHAR(5)) 
	DECLARE @OldSum DECIMAL (18,4)= (SELECT TOP(1) OldSum FROM inserted)
	DECLARE @NewSum DECIMAL (18,4)= (SELECT TOP(1) NewSum FROM inserted)
	DECLARE @Body NVARCHAR(100) = 'On ' + FORMAT(GETDATE(), 'MMM dd yyyy hh:mm tt') + ' your balance was changed from '+ CAST(@OldSum AS VARCHAR(20)) + ' to ' + CAST(@NewSum AS VARCHAR(20)) + '.';

	INSERT INTO NotificationEmails(Recipient, [Subject], Body)
	VALUES
	(
		@AccountId, 
		@Subject, 
		@Body
	)
--submit end

SELECT * FROM [dbo].[NotificationEmails]

--Problem - 16
GO
--submit start
CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
BEGIN
	DECLARE @money DECIMAL(18,4) = ABS(@MoneyAmount);

	IF(@MoneyAmount < 0)
	BEGIN
		ROLLBACK;
		THROW 50001, 'Money cannot be a negative number!', 1;
		RETURN
	END

	IF (EXISTS(SELECT Id FROM Accounts WHERE @AccountId NOT IN (SELECT Id FROM Accounts)))
	BEGIN
		ROLLBACK;
		THROW 50002, 'Invalid AccountId!', 1;
		RETURN
	END

	UPDATE Accounts
	SET Balance += @money
	WHERE @AccountId = Id
END
--submit end
EXEC usp_DepositMoney 6, 10000
GO
--Problem - 17
CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
BEGIN TRANSACTION
	IF(@MoneyAmount < 0)
	BEGIN
		ROLLBACK;
		THROW 50001, 'Money cannot be a negative number!', 1;
		RETURN
	END

	IF (EXISTS(SELECT Id FROM Accounts WHERE @AccountId NOT IN (SELECT Id FROM Accounts)))
	BEGIN
	ROLLBACK;
	THROW 50002, 'Invalid AccountId!', 1;
	RETURN
	END

	UPDATE Accounts
	SET Balance -= @MoneyAmount
	WHERE Id = @AccountId

COMMIT
GO

SELECT * FROM Accounts
EXEC usp_WithdrawMoney 6, 10000
GO

--Problem - 18
CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18,4))
AS
BEGIN TRANSACTION
	EXEC usp_WithdrawMoney @SenderId,  @Amount
	EXEC usp_DepositMoney @ReceiverId, @Amount
COMMIT

EXEC usp_TransferMoney 5, 1, 5000
EXEC usp_TransferMoney 1, 5, 5000
SELECT * FROM Accounts