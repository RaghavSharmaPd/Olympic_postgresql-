select * from public.olympic_region
select * from public.olympic_history

--1.Gold Medalists: List all athletes who have won a gold medal.

select "name", "medal" from olympic_history
where "medal"='Gold'

--2.Athlete Count by Team: Count the number of athletes from each team.
select "team",count("team") as "number_of_athletes_from_each_team" from olympic_history
group by ("team")


--3.Average Age of Summer Athletes: Find the average age of athletes who participated in the Summer Olympics.
select count("age") is not null from olympic_history
	
select * from olympic_history
where "age" ='NA'

update olympic_history
set "age" ='0'
where "age" = 'NA'
	
alter table olympic_history
alter columns "age" type int using "age"::integer;

select ROUND(avg("age"),3) as average_age_Summer_Olympics
from olympic_history
where "season" = 'Summer';

--4.Unique Sports: List all unique sports that athletes participated in.
select distinct("sport")as "unique_sports","name" from olympic_history

--5.Medal Count by Team: Count the number of medals won by each team.
select "team",count("medal") as "number of medals" 
from olympic_history
group by ("team")

--6.Top 5 Teams by Medals: Identify the top 5 teams with the most medals.
select "team",count("medal") as "top 5 team"
from olympic_history
group by ("team")
order by "top 5 team"  desc
limit 5
--7.Athletes from Specific Country: List all athletes from a specific country (e.g., USA).
SELECT "name" as "Name of Athletes","Region" FROM olympic_history
INNER JOIN olympic_region ON olympic_region."NOC" = olympic_history."noc"

--8.Youngest and Oldest Medalists: Find the youngest and oldest athletes who have won a medal.
--Oldest Medalists athletes
select "name","age","medal",
rank() over(partition by "medal" order by "age" desc) as "O M A Rank"
from olympic_history
limit 1
--Youngest Medalists athletes
select "name","age","medal",
rank() over(partition by "medal" order by "age" asc) as "Y M A rank"
from olympic_history
where "age" != 0
limit 1

--9.Average Height and Weight by Sport: Calculate the average height and weight of athletes for each sport.

update olympic_history
set "height" = '0'
where "height" = 'false'

update olympic_history
set "weight" = '0'
where "weight" ='NA'

alter table olympic_history
alter column "height" type int using "height"::integer
 
ALTER TABLE "olympic_history"
ALTER COLUMN "weight" TYPE INT USING floor("weight"::numeric)::integer;

select "sport",ROUND(avg("height"),2) as "AVG Height athletes",ROUND(avg("weight"),2) as "AVG Weight athletes" from olympic_history
group by ("sport")

--10.Gender Distribution by Season: Determine the number of athletes by gender for each Olympic season (Summer and Winter).
select ("sex"),"season",count(*) as "athletes count" from olympic_history
group by ("season","sex")

--11.Top 3 Countries by Gold Medals in Each Sport: List the top 3 countries with the most gold medals in each sport.
WITH countmadels as (
	select olympic_region."Region" as "Country",olympic_history."sport" as Sport,
	count(olympic_history."medal") as "gold Medal",rank() over(partition by olympic_history."sport" order by count(olympic_history."medal")desc) as "rank_"
	from olympic_history
	inner join olympic_region on olympic_region."NOC"=olympic_history."noc"
	where olympic_history."medal"='Gold'
	group by olympic_region."Region",olympic_history."sport"
	)
SELECT "Country","sport","gold Medal"
FROM countmadels
WHERE "rank_" <= 3
ORDER BY "rank_";

---12.Total Medals by Region: Calculate the total number of medals won by each region, using the noc_regions table.
select count("medal") as "total number of medals",olympic_region."Region" from olympic_history
inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
group by  olympic_region."Region"

--13.Medal Count by Year and Country: Calculate the number of medals won by each country in a specific year.
select count("medal") as "total number of medals",olympic_region."Region",olympic_history."year" from olympic_history
inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
group by  olympic_region."Region",olympic_history."year"

--14.Common Age for Gold Medalists: Identify the most common age for athletes who have won a gold medal.
select count("age") as "cout the common athletes" from olympic_history
where "medal"='Gold'
group by "age"
order by "cout the common athletes" desc
limit 1
	
--15.Average Medals per Athlete: Determine the average number of medals won per athlete.
WITH avgnymuber as (
	select count("medal") as "medal_count" ,"name" from olympic_history
	where "medal" is not null
	group by ("name")	
)
select ROUND(avg("medal_count"),3) as "avg per athlete" from avgnymuber
	
--16.Athlete Count by Region: List the regions and the number of athletes they have.
select count("name") as "total number of athletes",olympic_region."Region" from olympic_history
inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
group by  olympic_region."Region"

--17.Regions with Highest Average Height: Find the regions with the highest average athlete height.
select ROUND(avg("height"),2) as "avg of athletes height",olympic_region."Region" from olympic_history
inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
group by  olympic_region."Region"
order by "avg of athletes height" desc
limit 1

--18.Medal Count by Region: Determine the number of medals won by athletes from each region.
select count("medal") as "number of medal",olympic_region."Region" from olympic_history
inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
group by  olympic_region."Region"

--19.Gold Medals by Region: List the regions and the total number of gold medals they have won.
select count("medal") as "number of  gold medal",olympic_region."Region" from olympic_history
inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
where "medal"='Gold'
group by  olympic_region."Region"

--20.Regions with Participation in Every Season: Identify the regions with athletes who have participated in every Olympic season.
WITH RegionSeasons as(
	select count(distinct(olympic_history."season")) as "season_count",olympic_region."Region" from olympic_history
	inner join olympic_region on olympic_region."NOC" = olympic_history."noc"
	group by  olympic_region."Region"
)
select "Region" 
from RegionSeasons
WHERE "season_count" = (SELECT COUNT(DISTINCT "season") FROM olympic_history);

	

