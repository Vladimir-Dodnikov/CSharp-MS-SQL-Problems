CREATE DATABASE [Service]
USE [Service]

--DDL - Part 1
--Problem 1
create table Users
(
	Id int primary key identity not null,
	Username nvarchar(30) unique not null,
	[Password] nvarchar(50) not null,
	[Name] nvarchar(50),
	Birthdate datetime2,
	Age int check(Age between 4 and 110),
	Email nvarchar(50) not null
)

create table Departments
(
	Id int primary key identity not null,
	[Name] nvarchar(50) not null
)

create table Employees
(
	Id int primary key identity not null,
	FirstName nvarchar(25),
	LastName nvarchar(25),
	Birthdate datetime2,
	Age int check(Age between 18 and 110),
	DepartmentId int foreign key references Departments(Id)
)

create table Categories
(
	Id int primary key identity not null,
	[Name] nvarchar(50) not null,
	DepartmentId int not null foreign key references Departments(Id)
)

create table Status
(
	Id int primary key identity not null,
	[Label] nvarchar(30) not null
)

create table Reports
(
	Id int primary key identity not null,
	CategoryId int not null foreign key references Categories(Id),
	StatusId int not null foreign key references Status(Id),
	OpenDate datetime2 not null,
	CloseDate datetime2,
	Description nvarchar(200) not null,
	UserId int not null foreign key references Users(Id),
	EmployeeId int foreign key references Employees(Id)
)

--DML - Part 2
--Problem 2
insert into Employees(FirstName, LastName, Birthdate, DepartmentId)
values
('Marlo', 'O''Malley', '1958-09-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

insert into Reports(CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
values
(1, 1, '2017-04-13', null, 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', null, 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)

--Problem 3
update Reports set CloseDate = GETDATE() where CloseDate is null
--Problem 4
delete from Reports where StatusId = 4

--Querrying - Part 3
--Problem 5
select [Description], FORMAT(OpenDate, 'dd-MM-yyyy') as [OpenDate] 
from Reports as r
where EmployeeId is null
order by r.OpenDate, [Description]

--Problem 6
select r.Description, c.Name as [CategoryName] from Reports as r
join Categories as c
on r.CategoryId = c.Id
order by r.Description, [CategoryName]

--Problem 7
select top(5) c.Name as [CategoryName], COUNT(*) as [ReportsNumber] from Reports as r
join Categories as c on r.CategoryId = c.Id
group by r.CategoryId, c.Name
order by ReportsNumber desc, c.Name

--Problem 8
select u.Username, c.Name as [CategoryName] from Reports as r
join Users as u on u.Id = r.UserId
join Categories as c on c.Id = r.CategoryId
where FORMAT(r.OpenDate, 'MM-dd') = FORMAT(u.Birthdate, 'MM-dd')
order by u.Username, CategoryName

--Problem 9
select CONCAT(FirstName, ' ', LastName) as [FullName],
		(select COUNT(distinct UserId) from Reports where EmployeeId = e.Id) as [UsersCount]
from Employees as e
order by UsersCount desc, [FullName]

--Problem 10
select ISNULL(e.FirstName + ' ' + e.LastName, 'None') as [Employee],
	ISNULL(d.[Name], 'None') as [Department],
	ISNULL(c.[Name], 'None') as [Category],
	isnull(r.[Description], 'None') as [Description],
	FORMAT(r.[OpenDate], 'dd.MM.yyyy') as [OpenDate],
	ISNULL(s.[Label], 'None') as [Status],
	ISNULL(u.[Name], 'None') as [User]
from Reports as r
left join Employees as e on r.EmployeeId = e.Id
left join Categories as c on c.Id = r.CategoryId
left join Departments as d on d.Id = e.DepartmentId
left join Status as s on s.Id = r.StatusId
left join Users as u on u.Id = r.UserId
order by 
	e.FirstName desc,
	e.LastName desc, 
	d.[Name] asc, 
	c.[Name] asc, 
	r.[Description] asc, 
	s.[Label] asc, 
	u.Username asc

--Part 4 Programmability
--Problem 11
go
create function udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
returns int
as
begin
	if(@StartDate is null)
		return 0;
	if(@EndDate is null)
		return 0;
	return DATEDIFF(HOUR, @StartDate, @EndDate)
end

go
SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
   FROM Reports

--Problem 12
go
create or alter proc usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
as
begin
	declare @EmployeeDepartmentId int = (select DepartmentId from Employees where Id = @EmployeeId)
	declare @ReportDepartmentId int = (select c.DepartmentId from Reports as r 
										join Categories as c on r.CategoryId = c.Id
										where r.Id = @ReportId)
	if(@EmployeeDepartmentId != @ReportDepartmentId)
		throw 50000, 'Employee doesn''t belong to the appropriate department!', 1
	update Reports set EmployeeId = @EmployeeId
	where Id = @ReportId
end
go
EXEC usp_AssignEmployeeToReport 30, 1