USE Diablo

--Problem-14
SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start] 
	FROM Games AS g
	WHERE DATEPART(YEAR, g.[Start]) IN (2011, 2012)
	ORDER BY [Start], [Name]

--Problem-15
SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email) + 1, Len(Email)) AS [Email Provider] 
	FROM Users
	ORDER BY [Email Provider], Username

--Problem-16
SELECT Username, IpAddress 
	FROM Users
	WHERE IpAddress LIKE '___.1_%._%.___'
	ORDER BY Username

--Problem-17
SELECT [Name], 
	CASE
		WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS [Part of the Day],
	CASE
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS [Duration]
	FROM Games
	ORDER BY [Name], Duration