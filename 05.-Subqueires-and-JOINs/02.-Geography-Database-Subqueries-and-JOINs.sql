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
