create database ColonialJourney
use ColonialJourney 
--drop database ColonialJourney
create table Planets
(
	Id int primary key identity,
	[Name] varchar(50) not null
)

create table Spaceports	
(
	Id int primary key identity,
	[Name] varchar(50) not null,
	PlanetId int references Planets(Id)
)

create table Spaceships
(
	Id int primary key identity,
	[Name] varchar(50) not null,
	Manufacturer varchar(30) not null,
	LightSpeedRate int default 0
)

create table Colonists
(
	Id int primary key identity,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	Ucn varchar(10) unique not null,
	BirthDate date not null
)

create table Journeys
(
	Id int primary key identity,
	JourneyStart datetime not null,
	JourneyEnd datetime not null,
	Purpose varchar(11) not null check(Purpose in('Medical', 'Technical', 'Educational', 'Military')),
	DestinationSpaceportId int not null references Spaceports(Id),
	SpaceshipId int not null references Spaceships(Id)
)

create table TravelCards
(
	Id int primary key identity,
	CardNumber char(10) unique not null,
	JobDuringJourney varchar(8) not null check(JobDuringJourney in('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
	ColonistId int not null references Colonists(Id),
	JourneyId int not null references Journeys(Id)
)

--2
insert into Planets([Name])
values ('Mars'), ('Earth'), ('Jupiter'), ('Saturn')

insert into Spaceships([Name], Manufacturer, LightSpeedRate)
values ('Golf', 'VW', 3),('WakaWaka', 'Wakanda', 4),('Falcon9', 'SpaceX', 1),('Bed', 'Vidolov', 6)

--3
update Spaceships set LightSpeedRate +=1 from Spaceships where Id>= 8 and Id <=12

--4


--5
select Id, 
FORMAT(JourneyStart, 'dd/MM/yyyy') as JourneyStart, 
FORMAT(JourneyEnd, 'dd/MM/yyyy') as JourneyEnd
from Journeys where Purpose = 'Military'
order by JourneyStart

--6
select c.Id as id, CONCAT(c.FirstName, ' ', c.LastName) as [full_name]  from Colonists as c
left join TravelCards as tc on tc.ColonistId = c.Id
where tc.JobDuringJourney = 'Pilot'
order by c.Id

--7
select COUNT(*) as [count] from Colonists as c
left join TravelCards as tc on tc.ColonistId = c.Id
left join Journeys as j on j.Id = tc.JourneyId
where j.Purpose = 'Technical'
group by j.Purpose

--8
select s.Name, s.Manufacturer from Spaceships as s
left join Journeys as j on j.SpaceshipId = s.Id
left join TravelCards as tc on tc.JourneyId = j.Id
left join Colonists as c on c.Id = tc.ColonistId
where DATEDIFF(YEAR, c.BirthDate, '2019-01-01') <= 30 and tc.JobDuringJourney = 'Pilot'
group by s.Name, s.Manufacturer
order by s.Name

--9
select p.Name, count(p.Id) as [JourneysCount] from Journeys as j
left join Spaceports as sp on sp.Id = j.DestinationSpaceportId
left join Planets as p on p.Id = sp.PlanetId
group by p.Name, p.Id
order by JourneysCount desc, p.Name

--10
select query.JobDuringJourney, query.FullName, query.JobRank from (select tc.JobDuringJourney, CONCAT(c.FirstName, ' ', c.LastName) as [FullName],
		DENSE_RANK() over (partition by tc.JobDuringJourney order by c.BirthDate) as [JobRank]
from Colonists as c
left join TravelCards as tc on tc.ColonistId = c.Id
group by tc.JobDuringJourney,CONCAT(c.FirstName, ' ', c.LastName), c.BirthDate) as query
where query.JobRank = 2 and query.JobDuringJourney is not null


--11
go
create function udf_GetColonistsCount(@PlanetName VARCHAR (30))
returns int
as
begin
	declare @PlanetId INT = (select Id from Planets where [Name] = @PlanetName)

	declare @count INT = (select COUNT(p.Id) as [Count] from TravelCards as tc
						left join Colonists as c on tc.ColonistId = c.Id
						left join Journeys as j on j.Id = tc.JourneyId
						left join Spaceports as sp on sp.Id = j.DestinationSpaceportId
						left join Planets as p on sp.PlanetId = p.Id
						where p.Name = 'Otroyphus'
						group by p.Id, p.Name)
	return @count
end
go
SELECT dbo.udf_GetColonistsCount('Otroyphus')

--12
go
create proc usp_ChangeJourneyPurpose(@JourneyId int, @NewPurpose varchar(11))
as
begin
	declare @Purpose varchar(50) = (select Purpose from Journeys where Id = @JourneyId)

	if(@Purpose is null) THROW 50001, 'The journey does not exist!', 1;
	if(@Purpose = @NewPurpose) throw 50002, 'You cannot change the purpose!', 1;

	update Journeys set Purpose = @NewPurpose where Id = @JourneyId
end
go
EXEC usp_ChangeJourneyPurpose 4, 'Technical'
EXEC usp_ChangeJourneyPurpose 2, 'Educational'
EXEC usp_ChangeJourneyPurpose 196, 'Technical'

