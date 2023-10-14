-- 1. How many olympics games have been held?

select count(distinct games) as total_olympic_games 
from olympics_history oh ;

-- 2. List down all Olympics games held so far.

SELECT DISTINCT year,
	season,
	city
FROM olympics_history oh
ORDER BY year,
	season,
	city;

-- 3. Mention the total no of nations who participated in each olympics game?

SELECT oh.games,
	count(DISTINCT ohr.region) AS total_countries
FROM olympics_history oh
JOIN olympics_history_noc_regions ohr ON oh.noc = ohr.noc
GROUP BY oh.games
ORDER BY games;

-- 4. Which year saw the highest and lowest no of countries participating in olympics?
-- Slower solution
SELECT games,
	total_countries
FROM (
	SELECT *,
		rank() OVER (
			ORDER BY total_countries DESC
			)
	FROM (
		SELECT oh.games,
			count(DISTINCT ohr.region) AS total_countries
		FROM olympics_history oh
		JOIN olympics_history_noc_regions ohr ON oh.noc = ohr.noc
		GROUP BY oh.games
		) t1
	) t2
WHERE rank = 1

UNION ALL

SELECT games,
	total_countries
FROM (
	SELECT *,
		rank() OVER (
			ORDER BY total_countries
			)
	FROM (
		SELECT oh.games,
			count(DISTINCT ohr.region) AS total_countries
		FROM olympics_history oh
		JOIN olympics_history_noc_regions ohr ON oh.noc = ohr.noc
		GROUP BY oh.games
		) t1
	) t2
WHERE rank = 1;

-- Faster solution

WITH all_countries
AS (
	SELECT games,
		ohr.region
	FROM olympics_history oh
	JOIN olympics_history_noc_regions ohr ON oh.noc = ohr.noc
	GROUP BY oh.games,
		ohr.region
	ORDER BY games
	),
tot_countries
AS (
	SELECT games,
		count(region) AS total_countries
	FROM all_countries
	GROUP BY games
	)
SELECT DISTINCT CONCAT (
		first_value(games) OVER (
			ORDER BY total_countries
			),
		' - ',
		first_value(total_countries) OVER (
			ORDER BY total_countries
			)
		) AS lowest_countries,
	CONCAT (
		first_value(games) OVER (
			ORDER BY total_countries DESC
			),
		' - ',
		first_value(total_countries) OVER (
			ORDER BY total_countries DESC
			)
		) AS highest_countries
FROM tot_countries;

-- 5. Which nation has participated in all of the olympic games?

WITH tot_games
AS (
	SELECT count(DISTINCT games) AS total_games
	FROM olympics_history
	),
countries
AS (
	SELECT games,
		ohr.region AS country
	FROM olympics_history oh
	JOIN olympics_history_noc_regions ohr ON oh.noc = ohr.noc
	GROUP BY games,
		ohr.region
	),
countries_participated
AS (
	SELECT country,
		count(games) AS total_participated
	FROM countries
	GROUP BY country
	)
SELECT country,
	cp.total_participated
FROM countries_participated cp
JOIN tot_games tg ON cp.total_participated = tg.total_games;