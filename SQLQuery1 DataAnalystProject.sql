select * 
from DataAnalystProject..CovidDeaths$
where continent is not null
order by 3,4

--select * 
--from DataAnalystProject..CovidVaccinations$
--order by 3,4

--Selecting Data

Select Location, Date, Total_cases, new_cases, total_deaths, population
from DataAnalystProject..CovidDeaths$
order by 1,2

-- Total cases vs Total deaths
-- Showing estitmates of people dying at your country

Select Location, Date, Total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from DataAnalystProject..CovidDeaths$
where location like '%states%'
order by 1,2

-- Total cases vs Population
-- Showing percentage of population got Covid

Select Location, Date, population, total_cases,(total_cases/population)*100 as Population_percent
from DataAnalystProject..CovidDeaths$
where location like '%India%'
order by 1,2

-- Looking at Countries with highest Infection rate compared to Population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as Infected
from DataAnalystProject..CovidDeaths$
--where location like '%India%'
group by location,population
order by Infected desc

--Looking at Countries with highest Death count as per Population

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from DataAnalystProject..CovidDeaths$
--where location like '%India%'
where continent is not null
group by location,population
order by TotalDeathCount desc

--Lets do as per ContinentWise

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from DataAnalystProject..CovidDeaths$
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Showing continents with Highest Death counts

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from DataAnalystProject..CovidDeaths$
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from DataAnalystProject..CovidDeaths$
--where location like '%India%'
where continent is not null
--group by date
order by 1,2

--Total Popullation vs Vaccinations

With PopvsVac (Continent, location, date, popullation,new_vaccinations, CumulativePeopleVaccinated)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location Order by dea.location, dea.date) as CumulativePeopleVaccinated
-- (CumulativePeopleVaccinated
from DataAnalystProject..CovidDeaths$ dea
join DataAnalystProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3)
)
Select *, (CumulativePeopleVaccinated/popullation)*100
from PopvsVac

create view CumulativePeopleVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location Order by dea.location, dea.date) as CumulativePeopleVaccinated
-- (CumulativePeopleVaccinated
from DataAnalystProject..CovidDeaths$ dea
join DataAnalystProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3)

select * from CumulativePeopleVaccinated