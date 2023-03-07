SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

-- SELECT *
-- FROM PortfolioProject..CovidVaccinations
-- ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%nepal%'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid
SELECT location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%nepal%'
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population
SELECT location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%nepal%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Let's break things down by continent

-- Showing countries with highest death count per population
SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%nepal%'
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global numbers
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS Total_deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%nepal%'
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2

-- USE CTE
WITH PopvsVac (continent, location, date, Population, new_vaccinations, RollingPeopleVaccinated) 
AS (
-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location 
     AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *
FROM PopvsVac


