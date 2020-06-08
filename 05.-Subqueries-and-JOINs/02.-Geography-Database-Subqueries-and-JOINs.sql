USE Geography

--Problem - 12
SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation 
	FROM Countries AS c
	JOIN MountainsCountries AS ms
	ON c.CountryCode = ms.CountryCode
	JOIN Mountains AS m
	ON m.Id = ms.MountainId
	JOIN Peaks AS p
	ON p.MountainId = m.Id
	WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
	ORDER BY p.Elevation DESC

--Problem - 13
SELECT CountryCode, COUNT(MountainId) AS [MountainRanges]
	FROM MountainsCountries
	WHERE CountryCode IN ('RU', 'BG', 'US')
	GROUP BY CountryCode

--Problem - 14
SELECT TOP(5) c.CountryName, r.RiverName
	FROM (
			SELECT TOP(5) CountryName, CountryCode 
				FROM Countries 
				WHERE ContinentCode ='AF' 
				ORDER BY CountryName
		 ) AS c
	LEFT JOIN CountriesRivers AS cr 
	ON cr.CountryCode = c.CountryCode
	LEFT JOIN Rivers AS r 
	ON cr.RiverId = r.Id

--Problem - 15
SELECT ContinentCode, CurrencyCode, CurrencyCount AS CurrencyUsage
	FROM (
				SELECT ContinentCode, CurrencyCode, CurrencyCount,
						DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY CurrencyCount DESC) AS CurrencyRank
					FROM (
						SELECT ContinentCode, CurrencyCode, COUNT(*) AS CurrencyCount
							FROM Countries
							GROUP BY ContinentCode, CurrencyCode
						 ) AS CurrencyCountQuery
					WHERE CurrencyCount > 1
		 ) AS CurrencyRankingQuery
	WHERE CurrencyRank = 1
	ORDER BY ContinentCode ASC

--Problem - 16
SELECT COUNT(*) AS [Count] 
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS ms
	ON c.CountryCode = ms.CountryCode
WHERE ms.CountryCode IS NULL

--Problem - 17
SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS [HighestPeakElevation], MAX(r.Length) AS [LongestRiverLength] 
	FROM Countries AS c
	LEFT OUTER JOIN CountriesRivers AS cr
	ON c.CountryCode = cr.CountryCode
	LEFT OUTER JOIN Rivers AS r
	ON r.Id = cr.RiverId
	LEFT OUTER JOIN	MountainsCountries AS mc
	ON c.CountryCode = mc.CountryCode
	LEFT OUTER JOIN	Mountains AS m
	ON mc.MountainId = m.Id
	LEFT OUTER JOIN Peaks AS p
	ON p.MountainId = m.Id
	GROUP BY c.CountryName
	ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName ASC

--Problem - 18
SELECT TOP (5) [Country], 
		CASE
			WHEN [PeakName] IS NULL THEN '(no highest peak)'
			ELSE [PeakName]
		END AS [PeakName],
		CASE
			WHEN [Elevation] IS NULL THEN 0
			ELSE [Elevation]
		END AS [Elevation],
		CASE
			WHEN [Mountain] IS NULL THEN '(no mountain)'
			ELSE [Mountain]
		END AS [Mountain]
	FROM (
		SELECT *,
			DENSE_RANK() OVER (PARTITION BY [Country] ORDER BY [Elevation]) AS [PeakRank]
			FROM (
				SELECT c.CountryName AS [Country], p.PeakName AS [PeakName], 
					   p.Elevation AS [Elevation], m.MountainRange AS [Mountain]
					FROM Countries AS c
					LEFT OUTER JOIN	MountainsCountries AS mc
					ON c.CountryCode = mc.CountryCode
					LEFT OUTER JOIN	Mountains AS m
					ON mc.MountainId = m.Id
					LEFT OUTER JOIN Peaks AS p
					ON p.MountainId = m.Id
				) AS [AllDataQuery]
		) AS [PeakRankQuery]
WHERE [PeakRank] = 1
ORDER BY [Country] ASC, [PeakName] ASC