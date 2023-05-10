# COVID-19-Analysis


Our dataset, sourced from [Our World in Data](https://ourworldindata.org/covid-deaths), contains valuable information on the impact of Covid-19 across the world. To make it more manageable, we have split the dataset into two CSV files. 

The first file, covid_deaths.csv, provides indicators on Covid-19 cases worldwide from January 3, 2020 to January 3, 2022. 

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

The second file, covid_vaccinations.csv, covers the same time period and contains information on COVID-19 testing and vaccination rates.

| Variable	 | Description | 
| ------- | ----------- |
| `iso_code` | 	ISO 3166-1 alpha-3 – three-letter country codes |
| `continent` | Continent of the geographical location  |
| `location` | 	Geographical location |
| `date` | Date of observation |
| `total_tests` | Total tests for COVID-19. |
| `new_tests` | New tests for COVID-19 (only calculated for consecutive days). |
| `positive_rate` | The share of COVID-19 tests that are positive, given as a rolling 7-day average (this is the inverse of tests_per_case). |
| `tests_per_case` | Tests conducted per new confirmed case of COVID-19, given as a rolling 7-day average (this is the inverse of positive_rate). |
| `tests_units` | Units used by the location to report its testing data. A country file can't contain mixed units. All metrics concerning testing data use the specified test unit. Valid units are 'people tested' (number of people tested), 'tests performed' (number of tests performed. a single person can be tested more than once in a given day) and 'samples tested' (number of samples tested. In some cases, more than one sample may be required to perform a given test.) |
| `total_vaccinations` | Total number of COVID-19 vaccination doses administered. |
| `people_vaccinates` | Total number of people who received at least one vaccine dose. |
| `people_fully_vaccinated` | Total number of people who received all doses prescribed by the initial vaccination protocol. |
| `total_boosters` | Total number of COVID-19 vaccination booster doses administered (doses administered beyond the number prescribed by the vaccination protocol). |
| `new_vaccinations` | New COVID-19 vaccination doses administered (only calculated for consecutive days). |
| `population_density` | Number of people divided by land area, measured in square kilometers, most recent year available. |
| `median_age` | Median age of the population, UN projection for 2020. |
| `gdp_per_capita` | Gross domestic product at purchasing power parity (constant 2011 international dollars), most recent year available. |
| `female_smokers` | Share of women who smoke, most recent year available. |
| `male_smokers` | Share of men who smoke, most recent year available. |
| `life_expectancy` | Life expectancy at birth in 2019. |


````sql
SELECT * 
FROM covid_deaths
ORDER BY location, date;

SELECT * 
FROM covid_vaccinations
ORDER BY location, date;
````
![image](https://user-images.githubusercontent.com/81607668/129737993-710198bd-433d-469f-b5de-14e4022a3a45.png)



````sql
SELECT * 
FROM covid_deaths
ORDER BY location, date;
````




````sql
SELECT * 
FROM covid_deaths
ORDER BY location, date;
````
