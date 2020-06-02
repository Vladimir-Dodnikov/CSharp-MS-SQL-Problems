USE Geography

--Problem-12
SELECT CountryName, IsoCode 
	FROM Countries
	WHERE CountryName LIKE '%a%a%a%'
	ORDER BY IsoCode

--Problem-13
SELECT PeakName, RiverName, LOWER(CONCAT(PeakName, SUBSTRING(RiverName,2,LEN(RiverName)-1))) AS Mix
	FROM dbo.Peaks, dbo.Rivers
	WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
	ORDER BY Mix
--SELECT PeakName, RiverName, LOWER(CONCAT(PeakName, SUBSTRING(RiverName,2,LEN(RiverName)-1))) AS Mix
--	FROM Peaks
--	JOIN Rivers ON RIGHT(PeakName, 1) = LEFT(RiverName, 1)
--	ORDER BY Mix