USE Gringotts
--Problem - 1
SELECT COUNT(*) AS [Count]
	FROM WizzardDeposits

SELECT * FROM WizzardDeposits

--Problem - 2
SELECT MAX(MagicWandSize) AS [LongestMagicWand]
	FROM WizzardDeposits

--Problem - 3
SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand]
	FROM WizzardDeposits
	GROUP BY DepositGroup

--Problem - 4
SELECT TOP (2) DepositGroup
	FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

--Problem - 5
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	GROUP BY DepositGroup

--Problem - 6
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

--Problem - 7
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) < 150000
	ORDER BY TotalSum DESC

--Problem - 8
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS [MinDepositCharge]
	FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator, DepositGroup

--Problem - 9
SELECT [AgeGroup], COUNT(*)
FROM (
		SELECT 
			CASE
				WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
				WHEN Age > 60 THEN '[61+]'
			END AS [AgeGroup], 
			*
			FROM WizzardDeposits
	) AS [AgeGroupQuery]
GROUP BY AgeGroup

--Problem - 10
SELECT DISTINCT(SUBSTRING(FirstName, 1, 1)) AS [FirstLetter]
	FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY DepositGroup
--Option-2
SELECT * 
	FROM (
			SELECT SUBSTRING(FirstName, 1, 1) AS [FirstLetter]
			FROM WizzardDeposits
			WHERE DepositGroup = 'Troll Chest'
		 ) AS [FirstLetterQuery]
GROUP BY FirstLetter

--Problem - 11
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS [AverageInterest]
	FROM WizzardDeposits
	WHERE DepositStartDate > '1985-01-01'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired ASC

--Problem - 12
SELECT SUM([Difference]) AS [SumDifference]
	FROM (
			SELECT FirstName AS [Wizard Host], DepositAmount AS [Host Wizard Deposit],
			LEAD(FirstName) OVER(ORDER BY Id ASC) AS [Guest Wizard],
			LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Guest Wizard Deposit],
			DepositAmount - LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Difference]
			FROM WizzardDeposits
		 ) AS [DifferenceQuery]