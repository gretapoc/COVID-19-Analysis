-- COVID-19 ANALYSIS AND VISUALIZATION
-- Greta Poceviciute


-- Viewing covid_deaths
SELECT * 
FROM covid_deaths
ORDER BY location, date;


-- Viewing covid_vaccinations
SELECT * 
FROM covid_vaccinations
ORDER BY location, date;


-- Showing first documented cases in the world
SELECT 
	location, 
	MIN(date) AS first_case_date, 
	total_cases
FROM covid_deaths
WHERE total_cases > 0 
	AND continent IS NOT NULL
GROUP BY location, total_cases
HAVING MIN(date) = (
	SELECT MIN(date)
	FROM covid_deaths
	WHERE total_cases > 0
)
ORDER BY first_case_date;


-- Showing first documented case in Lithuania
SELECT 
	location, 
	MIN(date) AS first_case_date, 
	total_cases
FROM covid_deaths
WHERE total_cases > 0
	AND location = 'Lithuania'
GROUP BY location, total_cases
HAVING MIN(date) = (
	SELECT MIN(date)
	FROM covid_deaths
	WHERE total_cases > 0
	AND location = 'Lithuania'
)
ORDER BY MIN(date);


-- Showing likelihood of dying if you contract Covid-19 in every country
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	ROUND((total_deaths/total_cases)*100, 2) AS death_rate
FROM covid_deaths
WHERE continent IS NOT NULL
	AND total_cases IS NOT NULL
ORDER BY location, date;


-- Showing likelihood of dying if you contract Covid-19 in Lithuania
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	ROUND((total_deaths/total_cases)*100, 2) AS death_rate
FROM covid_deaths
WHERE location = 'Lithuania'
ORDER BY date;


-- Showing what percentage of population got Covid-19 worldwide
SELECT 
	location, 
	date, 
	total_cases,
	population, 
	ROUND((total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;


-- Showing what percentage of population got Covid-19 in Lithuania
SELECT 
	location, 
	date, 
	total_cases,
	population, 
	ROUND((total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE location = 'Lithuania'
ORDER BY 1,2;


-- Looking at countries with highest infection rate compared to population
SELECT 
	location, 
	population, 
	MAX(total_cases) AS highest_infection_count, 
	ROUND(MAX(total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
--WHERE location like '%Lithuania%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infection_rate desc;


-- Looking at Lithuania with highest infection rate compared to population
SELECT 
	location, 
	population, 
	MAX(total_cases) AS highest_infection_count, 
	ROUND(MAX(total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE location = 'Lithuania'
GROUP BY location, population;


-- Showing countries with highest death count per population
SELECT 
	location, 
	population,
	MAX(total_deaths) as total_deaths,
	(MAX(total_deaths)/population) * 100 AS death_rate_by_pop
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_rate_by_pop DESC;


-- Showing continents with the highest death count per population
SELECT 
	location, 
	MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent IS NULL
	AND location NOT LIKE '%income%'
	AND location NOT LIKE '%union%'
	AND location NOT LIKE '%world%'
GROUP BY location
ORDER BY total_death_count DESC;


-- Looking at global numbers
SELECT 
	date,
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    CASE WHEN SUM(new_cases) = 0 THEN 0 ELSE ROUND(SUM(new_deaths)/SUM(new_cases)*100, 3) END AS death_rate
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date, total_cases;


-- Showing total cases and deaths worldwide
SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(new_deaths) AS total_deaths, 
	ROUND(SUM(new_deaths)/SUM(new_cases)*100, 3) AS death_rate
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY total_cases;


-- Looking at the rolling vaccinations worldwide
SELECT 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cd.date;


-- Looking at the rolling vaccinations in Lithuania
SELECT 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.location = 'Lithuania'
ORDER BY cd.location, cd.date;


-- Looking at rolling vaccinations and the percentage of vaccinated population
WITH pop_vac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS
(SELECT 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL)
SELECT *, 
	(rolling_vaccinations/population)*100 AS vaccinated_per_pop
FROM pop_vac;


-- Creating temp table
DROP TABLE IF EXISTS percent_pop_vaccinated
CREATE TABLE percent_pop_vaccinated
	(
	continent NVARCHAR(255),
	location NVARCHAR(255),
	date DATETIME,
	population NUMERIC,
	new_vaccinations NUMERIC,
	rolling_vaccinations NUMERIC
	)

-- Inserting into temp table
INSERT INTO percent_pop_vaccinated
SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	cv.new_vaccinations,
	SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date

SELECT *,
	(rolling_vaccinations/population)*100 AS vaccinated_per_pop
FROM percent_pop_vaccinated
WHERE continent IS NOT NULL
ORDER BY location, date;


-- THE END