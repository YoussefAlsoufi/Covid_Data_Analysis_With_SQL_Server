
-- Show the whole Cases Count, Death Count , Death VS Cases in all the world.
with percentages (Total_Cases, Total_Deaths) as (
select  max (total_cases) as Total_Cases, max(cast (total_deaths as int)) as Total_Deaths from
dbo.Covid_Death$ )
select Total_Cases , Total_Deaths,(Total_Deaths/Total_Cases) *100 as Percentage_Death  from percentages ;



-- Show the whole Cases Count, Death Count , Death VS Cases in all the world By Date:
with percentages (Total_Cases, Total_Deaths, Date) as (
select  max (total_cases) as Total_Cases, max(cast (total_deaths as int)) as Total_Deaths 
, cast (date as date) as Date from dbo.Covid_Death$ where location ='World'  group by date)
select Total_Cases , Total_Deaths,Date, (Total_Deaths/Total_Cases) *100 as Percentage_Death  from percentages;

-- Show the whole Show the whole Cases Count, Death Count , Death VS Cases in each continent:
select location , max(total_cases) as Total_Cases, max(convert (int , total_deaths)) as Total_Deaths, max (convert(int, total_deaths)/ total_cases)*100  as Deaths_Percentages 
from dbo.Covid_Death$ where continent is Null and location not in ('World','Upper middle income','Low income','Lower middle income','High income') group by location ;


-- Show the whole Show the whole Cases Count, Death Count , Death VS Cases in each continent with Date:
select location , cast (date as date) as Date, max(total_cases) as Total_Cases, max(convert (int , total_deaths)) as Total_Deaths, max (convert(int, total_deaths)/ total_cases)*100  as Deaths_Percentages 
from dbo.Covid_Death$ where continent is Null and location not in ('World','Upper middle income','Low income','Lower middle income','High income','International') group by location,date ;

-- Show the whole Show the whole Cases Count, Death Count , Death VS Cases in each Country:
select location , max(total_cases) as Total_Cases, max(convert (int , total_deaths)) as Total_Deaths, max (convert(int, total_deaths)/ total_cases)*100  as Deaths_Percentages
from dbo.Covid_Death$ where continent is not Null group by location;


-- Show the whole Show the whole Cases Count, Death Count , Death VS Cases in each Country with date:
select location ,population, cast (date as date) as Date, max(total_cases) as Total_Cases, max(convert (int , total_deaths)) as Total_Deaths, max (total_cases/ population)*100  as Infection_Percentages
from dbo.Covid_Death$ where continent is not Null group by location,population, date;

-- Vaccination:
-- Show the vaccinated people Vs World population:
select max (cast (vaccination.people_fully_vaccinated as float)) as People_vaccinated,death.population,
max(cast(vaccination.people_fully_vaccinated as float))/death.population *100 as Fully_Vaccinated_People_Percentage
from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date=vaccination.date
where death.location ='World' group by death.population;


-- Show the vaccinated people Vs  population in Continents:
select death.location, max (cast (vaccination.people_fully_vaccinated as float)) as People_vaccinated,death.population,
max(cast(vaccination.people_fully_vaccinated as float))/death.population *100 as Fully_Vaccinated_People_Percentage
from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date=vaccination.date
where death.continent is null and death.location not in ('World','Upper middle income','Low income','Lower middle income','High income','International') group by death.location, death.population;

-- Show the vaccinated people Vs  population in each Country:
select death.location, max (cast (vaccination.people_fully_vaccinated as float)) as People_vaccinated,death.population,
max(cast(vaccination.people_fully_vaccinated as float))/death.population *100 as Fully_Vaccinated_People_Percentage
from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date=vaccination.date
where death.continent is not null group by death.location, death.population;


select death.location ,death.population,cast (death.date as date) as Date ,max (cast (vaccination.people_fully_vaccinated as float)) as People_vaccinated,
max(cast(vaccination.people_fully_vaccinated as float))/death.population *100 as Fully_Vaccinated_People_Percentage
from dbo.Covid_Death$ death join dbo.Covid_Vaccinations$ vaccination on death.location = vaccination.location and death.date=vaccination.date
where death.continent is not Null group by death.location,death.population, death.date;