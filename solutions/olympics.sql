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

-- 6. Identify the sport which was played in all summer olympics.
-- find number of summer games held
-- find games and sports games in summers
-- find games and their counts of the sports played in summers
-- match games,their counts where counts =  number of summer games held

WITH total_summer_games
AS (
	SELECT count(DISTINCT games) AS tot_games
	FROM olympics_history oh
	WHERE season = 'Summer'
	),
sport_count
AS (
	SELECT DISTINCT sport,
		games AS games_in_summer
	FROM olympics_history oh
	WHERE season = 'Summer'
	),
sport_game_count
AS (
	SELECT sport,
		count(1) AS number_of_games_in_summer
	FROM sport_count
	GROUP BY sport
	)
SELECT *
FROM sport_game_count sc
JOIN total_summer_games tsg ON sc.number_of_games_in_summer = tsg.tot_games;

-- 7. Which Sports were just played only once in the olympics?

WITH sport_year
AS (
	SELECT DISTINCT sport AS sport,
		games
	FROM olympics_history oh
	),
years_played
AS (
	SELECT sport,
		count(games) AS no_games_played
	FROM sport_year
	GROUP BY sport
	)
SELECT DISTINCT yp.sport,
	oh.games
FROM years_played yp
JOIN sport_year oh ON yp.sport = oh.sport
WHERE no_games_played = 1;

-- 8. Fetch the total no of sports played in each olympic games.

WITH game_sport
AS (
	SELECT games,
		sport
	FROM olympics_history oh
	GROUP BY games,
		sport
	)
SELECT games,
	count(sport)
FROM game_sport
GROUP BY games
ORDER BY count DESC;

-- 9. Fetch details of the oldest athletes to win a gold medal.

WITH gold_medal
AS (
	SELECT DISTINCT name,
		cast(CASE 
				WHEN age = 'NA'
					THEN '0'
				ELSE age
				END AS INT) AS age,
		sex,
		team,
		games,
		city,
		sport,
		event,
		medal
	FROM olympics_history oh
	WHERE medal = 'Gold'
	),
oldest
AS (
	SELECT *,
		rank() OVER (
			ORDER BY age DESC
			)
	FROM gold_medal
	)
SELECT *
FROM oldest
WHERE rank = 1;

-- 10. Find the Ratio of male and female athletes participated in all olympic games.
-- every record is a pariticipation

WITH sex_split
AS (
	SELECT sex,
		count(1) AS cnt
	FROM olympics_history oh
	GROUP BY sex
	),
sex_split_rank
AS (
	SELECT *,
		row_number() OVER (
			ORDER BY cnt
			)
	FROM sex_split
	),
min_cnt
AS (
	SELECT cnt
	FROM sex_split_rank
	WHERE row_number = 1
	),
max_cnt
AS (
	SELECT cnt
	FROM sex_split_rank
	WHERE row_number = 2
	)
SELECT CONCAT (
		'1 : ',
		round(max_cnt.cnt::NUMERIC / min_cnt.cnt, 2)
		) AS ratio_male_to_female
FROM min_cnt,
	max_cnt;

