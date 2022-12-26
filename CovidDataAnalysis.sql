select * from dbo.Covid_Death$ order by 1

-- Select Data that we are going to be using :
select location, date, total_cases, new_cases, total_cases, population from dbo.Covid_Death$ order by 1,2;

-- Select Total cases Vs Total Deaths:
select location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage from
dbo.Covid_Death$ where location like '%czech%' order by 1,2;

-- Select the total cases Vs the population:
select location, date , total_cases, population, (total_cases/population)*100 as cases_percentage from
dbo.Covid_Death$ where location like '%czech%' order by 1,2;

-- select the countries with Highest infection percentage rate compared the population:
select location, Max (total_cases) as Highest_Infection, population ,max ((total_cases/population))*100 as cases_percentage from
dbo.Covid_Death$ group by location, population order by cases_percentage desc;

-- select the countries with Highest infection rate compared the population without Continents:
select location, Max (total_cases) as Highest_Infection, population ,max ((total_cases/population))*100 as cases_percentage from
dbo.Covid_Death$  where location not in ('World','Europe','Asia','European Union', 'Upper middle income','High income','North America','Lower middle income','South America')  
group by location, population order by Highest_Infection desc;

-- Countries with highest death count per population:
select location, max (cast (total_deaths as int)) as Max_Total_Death , max (cast (total_deaths as int)/population)*100 as Percentage_Total_Death from dbo.Covid_Death$ 
where continent is not Null group by location order by Percentage_Total_Death desc;
 

 -- All Deaths in each Contintent (highest death count per population):
 select location as Contentient, population, max (cast (total_deaths as int)) as Max_Death, max (cast(total_deaths as int)/population) *100 as Percentage_Death from dbo.Covid_Death$ 
 where continent is null group by location, population order by Max_Death desc;

 -- Join two tables:
 select * from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date = vaccination.date;


 -- show the time of highest deaths:
  select location as Contentient, population,max (cast (date as date)), max (cast (total_deaths as int)) as Max_Death, max (cast(total_deaths as int)/population) *100 as Percentage_Death from dbo.Covid_Death$ 
 where continent is null group by location, population order by Max_Death desc;


 -- Looking at total population VS Vaccination:
 select death.location, death.population,max (cast (death.date as date)) as date, max (cast (vaccination.people_fully_vaccinated as float)) as new_Vaccinations, 
 max(cast(vaccination.people_fully_vaccinated as float))/death.population *100 as Fully_Vaccinated_People
 from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date=vaccination.date
 where death.continent is not null group by death.location, death.population order by Fully_Vaccinated_People desc

 -- Partition Over:
 select death.location , death.population, sum(Convert (float, vaccination.new_vaccinations)) Over (partition by death.location order by death.location, death.date) as Total_Vaccinations
 ,vaccination.new_vaccinations ,death.date --,max(cast (death.date as date)) Over (partition by death.location)
 from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date = vaccination.date
 where death.continent is not null and death.location='Albania' order by 1,2 desc;


 -- Using the created table in another line:  1- using CTE approach
 -- We want to show the number of people have been vaccinated Vs Population:

  select death.location , death.population, sum(Convert (float, vaccination.new_vaccinations)) Over (partition by death.location order by death.location, death.date) as Total_Vaccinations
 ,vaccination.new_vaccinations ,death.date , Total_Vaccinations/death.population*100 as Percantage_people_vacccinated
 from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date = vaccination.date
 where death.continent is not null and death.location='Albania' order by 1,2 desc;


 --Want to see the max percentage with the date:
 with max_Percetage (location,population,Total_Vaccinations,new_vaccinations,date,Percantage_people_vacccinated ) as 
 (
  select death.location , death.population, sum(Convert (float, vaccination.new_vaccinations)) Over (partition by death.location order by death.location, death.date) as Total_Vaccinations
 ,vaccination.new_vaccinations ,death.date , Total_Vaccinations/death.population*100 as Percantage_people_vacccinated 
 from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date = vaccination.date
 where death.continent is not null and death.location='Albania' --order by 1,2 desc;
 )
 select date, max (Percantage_people_vacccinated)  Over (partition by date) as max_per from max_Percetage order by max_per desc ;

 -- 2- Using Temp Teble: (Not necesary in this section since CTE is easier).
  

  -- Creating a View to store data for Visualization:
  create View PeopleVaccinatedPercentage as 
    select death.location , death.population, sum(Convert (float, vaccination.new_vaccinations)) Over (partition by death.location order by death.location, death.date) as Total_Vaccinations
 ,vaccination.new_vaccinations ,death.date , Total_Vaccinations/death.population*100 as Percantage_people_vacccinated
 from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date = vaccination.date
 where death.continent is not null;

