CREATE DATABASE WMS
USE WMS

--PART 1 - DDL
CREATE TABLE Clients
(
	ClientId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Phone CHAR(12)
)

CREATE TABLE Mechanics
(
	MechanicId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	[Address] CHAR(255)
)

CREATE TABLE Models
(
	ModelId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) UNIQUE
)

CREATE TABLE Jobs
(
	JobId INT PRIMARY KEY IDENTITY,
	ModelId INT NOT NULL REFERENCES Models(ModelId),
	[Status] VARCHAR(11) DEFAULT 'Pending' CHECK([Status] IN ('Pending', 'In Progress', 'finished')),
	ClientId INT NOT NULL REFERENCES Clients(ClientId),
	MechanicId INT REFERENCES Mechanics(MechanicId),
	IssueDate DATE NOT NULL,
	FinishDate DATE
)

CREATE TABLE Orders
(
	OrderId INT PRIMARY KEY IDENTITY,
	JobId INT NOT NULL REFERENCES Jobs(JobId),
	IssueDate DATE,
	Delivered BIT DEFAULT 0
)

CREATE TABLE Vendors
(
	VendorId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) UNIQUE
)

CREATE TABLE Parts
(
	PartId INT PRIMARY KEY IDENTITY,
	SerialNumber VARCHAR(50) UNIQUE,
	[Description] VARCHAR(255),
	Price DECIMAL(6,2) CHECK(Price > 0 AND Price <= 9999.99),
	VendorId INT NOT NULL REFERENCES Vendors(VendorId),
	StockQty INT DEFAULT 0 CHECK(StockQty >= 0)
)

CREATE TABLE OrderParts
(
	OrderId INT NOT NULL REFERENCES Orders(OrderId),
	PartId INT NOT NULL REFERENCES Parts(PartId),
	Quantity INT NOT NULL DEFAULT 1 CHECK(Quantity > 0),
	PRIMARY KEY(OrderId, PartId)
)

CREATE TABLE PartsNeeded
(
	JobId INT NOT NULL REFERENCES Jobs(JobId),
	PartId INT NOT NULL REFERENCES Parts(PartId),
	Quantity INT NOT NULL DEFAULT 1 CHECK(Quantity > 0),
	PRIMARY KEY(JobId, PartId)
)

--Part 2
--Problem 2 INSERT
INSERT INTO Clients(FirstName,LastName,Phone)
VALUES
	('Teri', 'Ennaco','570-889-5187'),
	('Merlyn', 'Lawler','201-588-7810'),
	('Georgene', 'Montezuma','925-615-5185'),
	('Jettie', 'Mconnell','908-802-3564'),
	('Lemuel', 'Latzke','631-748-6479'),
	('Melodie', 'Knipp','805-690-1682'),
	('Candida', 'Corbley','908-275-8357')

INSERT INTO Parts(SerialNumber, [Description], Price, VendorId)
VALUES
	('WP8182119', 'Door Boot Seal',117.86, 2),
	('W10780048', 'Suspension Rod', 42.81, 1),
	('W10841140', 'Silicone Adhesive ', 6.77, 4),
	('WPY055980', 'High Temperature Adhesive', 13.94, 3)

--Problem 3 - UPDATE
UPDATE Jobs SET [Status] = 'In Progress'
WHERE [Status] = 'Pending' AND MechanicId = 3

--Problem 4
--select * from Orders
--select * from OrderParts
DELETE FROM OrderParts
WHERE OrderId = 19

DELETE FROM Orders
WHERE OrderId = 19

--Problem 5
SELECT CONCAT(FirstName, ' ', LastName) AS [Mechanic], j.[Status], j.IssueDate
FROM Mechanics AS m
LEFT JOIN Jobs AS j ON m.MechanicId = j.MechanicId
ORDER BY j.MechanicId, IssueDate, JobId

--Problem 6
SELECT CONCAT(FirstName, ' ', LastName) AS [Client], DATEDIFF(DAY, J.IssueDate, '2017-04-24') AS [Days going], J.[Status]
FROM Clients AS cl
LEFT JOIN Jobs AS j ON j.ClientId = cl.ClientId
WHERE j.[Status] != 'Finished'
ORDER BY[Days going] DESC, cl.ClientId

--Problem 7
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic], AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)) AS [Average Days]
FROM Mechanics AS m
LEFT JOIN Jobs AS j ON j.MechanicId = M.MechanicId
WHERE j.[Status] = 'Finished'
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
ORDER BY m.MechanicId

--Problem 8
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Available] FROM Mechanics AS m
LEFT JOIN Jobs AS j ON m.MechanicId = j.MechanicId
WHERE j.[Status] = 'Finished' AND j.[FinishDate] IS NULL
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId, j.FinishDate
ORDER BY m.MechanicId,

--Problem 9
SELECT j.JobId, SUM(p.Price * pn.Quantity) AS [Total]
FROM Jobs AS j
LEFT JOIN PartsNeeded AS pn ON pn.JobId = j.JobId
LEFT JOIN Parts AS p ON p.PartId = pn.PartId
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId

SELECT j.JobId, SUM(p.Price * op.Quantity) AS [Total] 
FROM Jobs AS j
LEFT JOIN Orders AS o ON j.JobId = o.JobId
LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
LEFT JOIN Parts AS p ON p.PartId = op.PartId
WHERE j.[Status] = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId

--Problem 12
go
CREATE FUNCTION udf_GetCost(@JobId INT) 
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @Result DECIMAL(18,2) = (select SUM(p.Price * op.Quantity) AS [Total] 
									from Jobs as j
									left join Orders as o on o.JobId = j.JobId
									left join OrderParts as op on op.OrderId = o.OrderId
									left join Parts as p on p.PartId = op.PartId
									where j.JobId = @JobId
									group by j.JobId)

	IF(@Result IS NULL)
	BEGIN
		RETURN 0;
	END

	RETURN @Result;
END

GO
SELECT dbo.udf_GetCost(1)

--Problem 11
go

CREATE PROCEDURE usp_PlaceOrder(@JobId INT, @SerialNumber VARCHAR(50), @Quantity INT)
AS
BEGIN TRANSACTION
	DECLARE @JobStatus VARCHAR(25) = (select [Status] from Jobs where JobId = @JobId);

	DECLARE @Id INT = (select JobId from Jobs where JobId = @JobId);

	if(@JobStatus = 'Finished') 
	BEGIN 
		ROLLBACK;
		THROW 50011, 'This job is not active!', 1;
	END

	if(@Quantity <= 0)
	BEGIN 
		ROLLBACK;
		THROW 50012, 'Part quantity must be more than zero!', 1;
		RETURN;
	END

	if(@JobId != @Id)
	BEGIN
		ROLLBACK;
		THROW 50013, 'Job not found!', 1;
		RETURN
	END

	DECLARE @PartId INT = (select PartId from Parts where SerialNumber = @SerialNumber)

	IF(@PartId IS NULL)
	BEGIN
		ROLLBACK;
		THROW 50014, 'Part not found!', 1;
		RETURN
	END

	DECLARE @OrderId INT = (select OrderId from Orders where JobId = @JobId);
	DECLARE @IssueDateOfOrder DATE = (select IssueDate from Orders where JobId = @JobId);

	IF(@OrderId != 0 AND @IssueDateOfOrder IS NULL)
	BEGIN
		IF(@PartId != 0)
		BEGIN
			UPDATE OrderParts SET Quantity += 1 WHERE OrderId = @OrderId
		END
			INSERT INTO OrderParts(OrderId, PartId, Quantity) VALUES (@OrderId, @PartId, @Quantity)
			INSERT INTO Orders(OrderId, JobId, IssueDate, Delivered) VALUES (@OrderId, @JobId, @IssueDateOfOrder, 0)
	END
COMMIT
go
DECLARE @err_msg AS NVARCHAR(MAX);
BEGIN TRY
  EXEC usp_PlaceOrder 1, 'ZeroQuantity', 0
END TRY

BEGIN CATCH
  SET @err_msg = ERROR_MESSAGE();
  SELECT @err_msg
END CATCH
