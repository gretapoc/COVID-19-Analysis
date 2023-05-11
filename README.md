# COVID-19 Analysis And Visualizations
### Greta Pocevičiūtė

![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/covid19.jpg)

## Table of Contents
- [Introduction](#introduction)
- [COVID-19 Analysis](#covid-19-analysis)
  - [Data Review](#data-review)
  - [SQL Queries](#sql-queries)
  - [Tableau Visualizations](#tableau-visualizations)

## Introduction

Throughout the past few years, COVID-19 has had a profound impact on individuals and communities worldwide. Unfortunately, numerous individuals have been infected, and countless lives have been lost to this devastating illness. 

This project aims to examine COVID-19 data both globally and locally, utilizing SQL to analyze the data and Tableau to present visualizations.

## COVID-19 Analysis

## Data Review

Our dataset, sourced from [Our World in Data](https://ourworldindata.org/covid-deaths), contains valuable information on the impact of COVID-19 across the world. To make it more manageable, we have split the dataset into two CSV files. 

The first file, [covid_deaths.csv](https://github.com/gretapoc/COVID-19-Analysis/blob/main/covid_deaths.csv), provides indicators on COVID-19 cases worldwide from January 3, 2020 to January 3, 2022. 

| Variable	 | Description | 
| ------- | ----------- |
| `iso_code` | 	ISO 3166-1 alpha-3 – three-letter country codes. | 
| `continent` | Continent of the geographical location. | 
| `location` | 	Geographical location. |
| `date` | Date of observation. |
| `population` | Population (latest available values). |
| `total_cases` | Total confirmed cases of COVID-19. Counts can include probable cases, where reported. |
| `new_cases` | New confirmed cases of COVID-19. Counts can include probable cases, where reported. |
| `total_deaths` | Total deaths attributed to COVID-19. Counts can include probable deaths, where reported. |
| `new_deaths` | 	New deaths attributed to COVID-19. Counts can include probable deaths, where reported. |
| `icu_patients` | 	Number of COVID-19 patients in intensive care units (ICUs) on a given day. |
| `hosp_patients` | Number of COVID-19 patients in hospital on a given day. |

The file contains 184 819 observations and 11 variables.

The second file, [covid_vaccinations.csv](https://github.com/gretapoc/COVID-19-Analysis/blob/main/covid_vaccinations.csv), covers the same time period and contains information on COVID-19 testing and vaccination rates. 

| Variable	 | Description | 
| ------- | ----------- |
| `iso_code` | 	ISO 3166-1 alpha-3 – three-letter country codes |
| `continent` | Continent of the geographical location  |
| `location` | 	Geographical location |
| `date` | Date of observation |
| `total_tests` | Total tests for COVID-19. |
| `new_tests` | New tests for COVID-19 (only calculated for consecutive days). |
| `total_vaccinations` | Total number of COVID-19 vaccination doses administered. |
| `people_vaccinated` | Total number of people who received at least one vaccine dose. |
| `new_vaccinations` | New COVID-19 vaccination doses administered (only calculated for consecutive days). |
| `median_age` | Median age of the population, UN projection for 2020. |
| `gdp_per_capita` | Gross domestic product at purchasing power parity (constant 2011 international dollars), most recent year available. |
| `female_smokers` | Share of women who smoke, most recent year available. |
| `male_smokers` | Share of men who smoke, most recent year available. |
| `life_expectancy` | Life expectancy at birth in 2019. |

The file contains 184 819 observations and 14 variables.

## SQL Queries

**To view the full SQL code for this project, [click here](https://github.com/gretapoc/COVID-19-Analysis-And-Visualizations/blob/main/COVID-19%20Analysis.sql).**

**Viewing covid_deaths:**
````sql
SELECT * 
FROM covid_deaths
ORDER BY location, date;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%201.PNG)


**Viewing covid_vaccinations:**
````sql
SELECT * 
FROM covid_vaccinations
ORDER BY location, date;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%202.PNG)


**Showing likelihood of dying if you contract COVID-19 in every country:**
````sql
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
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%203.PNG)


**The initial COVID-19 case was identified in December 2019 in Wuhan, China, however, the cases were not officially recorded until January 2020. This query showcases the first documented cases of COVID-19 worldwide:**
````sql
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
````
The earliest documented cases of COVID-19 were identified on January 4th, 2020 in China, Germany, and Finland.
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%204.PNG)


**Showing likelihood of dying if you contract COVID-19 in Lithuania:**
````sql
SELECT 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  ROUND((total_deaths/total_cases)*100, 2) AS death_rate
FROM covid_deaths
WHERE location = 'Lithuania'
ORDER BY date;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%205.PNG)


**Showing the first documented COVID-19 case in Lithuania:**
````sql
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
````
Lithuania's first documented case of COVID-19 was reported on February 28th, 2020.
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%206.PNG)


**Showing what percentage of population got COVID-19 worldwide:**
````sql
SELECT 
  location, 
  date, 
  total_cases,
  population, 
  ROUND((total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%207.PNG)


**Showing what percentage of population got COVID-19 in Lithuania:**
````sql
SELECT 
  location, 
  date, 
  total_cases,
  population, 
  ROUND((total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE location = 'Lithuania'
ORDER BY 1,2;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%208.PNG)


**Looking at countries with highest infection rate compared to population:**
````sql
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
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%209.PNG)


**Looking at Lithuania with highest infection rate compared to population:**
````sql
SELECT 
  location, 
  population, 
  MAX(total_cases) AS highest_infection_count, 
  ROUND(MAX(total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE location = 'Lithuania'
GROUP BY location, population;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2010.PNG)


**Showing countries with highest death count per population:**
````sql
SELECT 
  location, 
  population, 
  MAX(total_cases) AS highest_infection_count, 
  ROUND(MAX(total_cases/population)*100, 3) AS infection_rate
FROM covid_deaths
WHERE location = 'Lithuania'
GROUP BY location, population;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2011.PNG)


**Showing continents with the highest death count per population:**
````sql
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
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2012.PNG)


**Looking at global numbers by date:**
````sql
SELECT 
  date,
  SUM(new_cases) AS total_cases, 
  SUM(new_deaths) AS total_deaths, 
  CASE WHEN SUM(new_cases) = 0 THEN 0 ELSE ROUND(SUM(new_deaths)/SUM(new_cases)*100, 3) END AS death_rate
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date, total_cases;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2013.PNG)


**Showing total COVID-19 cases and deaths worldwide:**
````sql
SELECT
  SUM(new_cases) AS total_cases, 
  SUM(new_deaths) AS total_deaths, 
  ROUND(SUM(new_deaths)/SUM(new_cases)*100, 3) AS death_rate
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY total_cases;
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2014.PNG)


**Looking at the relationship between total population and vaccination rates:**
````sql
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
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2015.PNG)


**Looking at the rolling vaccinations in Lithuania:**
````sql
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
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2016.PNG)


**Looking at rolling vaccinations and the percentage of vaccinated population:**
````sql
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
````
![image](https://github.com/gretapoc/COVID-19-Analysis/blob/main/pictures/code%2017.PNG)

**Creating temp table:**
````sql
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
````

**Inserting into temp table:**
````sql
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
````

## Tableau Visualizations

The dashboard has been published on [Tableau Public](https://public.tableau.com/app/profile/greta.pocevi.i.t./viz/COVID-19Dashboard_16838156988660/Dashboard1?publish=yes).

![image](https://github.com/gretapoc/COVID-19-Analysis-And-Visualizations/blob/main/pictures/Dashboard%201.png)



