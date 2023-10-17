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

-- 11. Fetch the top 5 athletes who have won the most gold medals.

WITH gold_medal_ath
AS (
	SELECT name,
		team,
		count(1) AS no_medals
	FROM olympics_history oh
	WHERE medal = 'Gold'
	GROUP BY name,
		team
	),
gold_count
AS (
	SELECT *,
		dense_rank() OVER (
			ORDER BY no_medals DESC
			) AS rank
	FROM gold_medal_ath
	)
SELECT name,
	team,
	no_medals
FROM gold_count
WHERE rank <= 5;

-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

WITH gold_medal_ath
AS (
	SELECT name,
		team,
		count(1) AS no_medals
	FROM olympics_history oh
	WHERE medal IN (
			'Gold',
			'Silver',
			'Bronze'
			)
	GROUP BY name,
		team
	),
gold_count
AS (
	SELECT *,
		dense_rank() OVER (
			ORDER BY no_medals DESC
			) AS rank
	FROM gold_medal_ath
	)
SELECT name,
	team,
	no_medals
FROM gold_count
WHERE rank <= 5;

-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

WITH gold_medal_ath
AS (
	SELECT team,
		noc,
		count(1) AS no_medals
	FROM olympics_history oh
	WHERE medal IN (
			'Gold',
			'Silver',
			'Bronze'
			)
	GROUP BY team,
		noc
	),
gold_count
AS (
	SELECT *,
		rank() OVER (
			ORDER BY no_medals DESC
			) AS rank
	FROM gold_medal_ath
	)
SELECT ohnr.region AS Country,
	no_medals,
	rank
FROM gold_count gc
JOIN olympics_history_noc_regions ohnr ON gc.noc = ohnr.noc
WHERE rank <= 5;

-- 14. List down total gold, silver and bronze medals won by each country.
WITH medals
AS (
	SELECT noc,
		medal,
		count(1) AS no_medals
	FROM olympics_history oh
	WHERE medal IN (
			'Gold',
			'Silver',
			'Bronze'
			)
	GROUP BY noc,
		medal
	),
gold
AS (
	SELECT noc,
		sum(no_medals) AS gold_medals
	FROM medals
	WHERE medal = 'Gold'
	GROUP BY noc
	),
silver
AS (
	SELECT noc,
		sum(no_medals) AS silver_medals
	FROM medals
	WHERE medal = 'Silver'
	GROUP BY noc
	),
bronze
AS (
	SELECT noc,
		sum(no_medals) AS bronze_medals
	FROM medals
	WHERE medal = 'Bronze'
	GROUP BY noc
	),
combined
AS (
	SELECT b.noc,
		bronze_medals,
		silver_medals,
		gold_medals
	FROM bronze b
	JOIN gold g ON b.noc = g.noc
	JOIN silver s ON s.noc = b.noc
	)
SELECT ohnr.region,
	bronze_medals,
	silver_medals,
	gold_medals
FROM combined c
JOIN olympics_history_noc_regions ohnr ON c.noc = ohnr.noc
ORDER BY gold_medals DESC;



-- Using crosstab feature
SELECT country,
	coalesce(gold, 0) AS gold,
	coalesce(silver, 0) AS silver,
	coalesce(bronze, 0) AS bronze
FROM CROSSTAB('SELECT nr.region as country
			, medal
			, count(1) as total_medals
			FROM olympics_history oh
			JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
			where medal <> ''NA''
			GROUP BY nr.region,medal
			order BY nr.region,medal', 'values (''Bronze''), (''Gold''), (''Silver'')') AS FINAL_RESULT(country VARCHAR, bronze BIGINT, gold BIGINT, silver BIGINT)
ORDER BY gold DESC,
	silver DESC,
	bronze DESC;


-- 15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
-- My solution
SELECT games,
	country,
	sum(coalesce(bronze, 0)) AS bronze,
	sum(coalesce(gold, 0)) AS gold,
	sum(coalesce(silver, 0)) AS silver
FROM crosstab('
	select games,nr.region as country, medal,count(1) as total_medals 
	from olympics_history oh 
	join olympics_history_noc_regions nr on nr.noc=oh.noc 
	where medal <> ''NA'' 
	group by games,nr.region,medal
	order by nr.region,medal', 'values(''Bronze''),(''Gold''),(''Silver'')') AS final_result(games VARCHAR, country VARCHAR, bronze BIGINT, gold BIGINT, silver BIGINT)
GROUP BY games,
	country
ORDER BY games,
	gold DESC,
	silver DESC,
	bronze DESC;



-- online solution
SELECT substring(games, 1, position(' - ' IN games) - 1) AS games,
	substring(games, position(' - ' IN games) + 3) AS country,
	coalesce(gold, 0) AS gold,
	coalesce(silver, 0) AS silver,
	coalesce(bronze, 0) AS bronze
FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
            , medal
            , count(1) as total_medals
            FROM olympics_history oh
            JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
            where medal <> ''NA''
            GROUP BY games,nr.region,medal
            order BY games,medal', 'values (''Bronze''), (''Gold''), (''Silver'')') AS FINAL_RESULT(games TEXT, bronze BIGINT, gold BIGINT, silver BIGINT);

-- 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.

WITH TEMP
AS (
	SELECT substring(games, 1, position(' - ' IN games) - 1) AS games,
		substring(games, position(' - ' IN games) + 3) AS country,
		coalesce(gold, 0) AS gold,
		coalesce(silver, 0) AS silver,
		coalesce(bronze, 0) AS bronze
	FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
					, medal
				  	, count(1) as total_medals
				  FROM olympics_history oh
				  JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
				  where medal <> ''NA''
				  GROUP BY games,nr.region,medal
				  order BY games,medal', 'values (''Bronze''), (''Gold''), (''Silver'')') AS FINAL_RESULT(games TEXT, bronze BIGINT, gold BIGINT, silver BIGINT)
	)
SELECT DISTINCT games,
	CONCAT (
		first_value(country) OVER (
			PARTITION BY games ORDER BY gold DESC
			),
		' - ',
		first_value(gold) OVER (
			PARTITION BY games ORDER BY gold DESC
			)
		) AS Max_Gold,
	CONCAT (
		first_value(country) OVER (
			PARTITION BY games ORDER BY silver DESC
			),
		' - ',
		first_value(silver) OVER (
			PARTITION BY games ORDER BY silver DESC
			)
		) AS Max_Silver,
	CONCAT (
		first_value(country) OVER (
			PARTITION BY games ORDER BY bronze DESC
			),
		' - ',
		first_value(bronze) OVER (
			PARTITION BY games ORDER BY bronze DESC
			)
		) AS Max_Bronze
FROM TEMP
ORDER BY games;

--   17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
WITH temp as
	(SELECT substring(games, 1, position(' - ' in games) - 1) as games
	 	, substring(games, position(' - ' in games) + 3) as country
        , coalesce(gold, 0) as gold
        , coalesce(silver, 0) as silver
        , coalesce(bronze, 0) as bronze
        , coalesce(bronze, 0)+coalesce(silver, 0)+coalesce(gold, 0) as total_medals
	FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
					, medal
				  	, count(1) as total_medals
				  FROM olympics_history oh
				  JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
				  where medal <> ''NA''
				  GROUP BY games,nr.region,medal
				  order BY games,medal',
              'values (''Bronze''), (''Gold''), (''Silver'')')
			   AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint))
	select distinct games
		,concat(first_value(country) over (partition by games order by gold desc),'-',first_value(gold) over (partition by games order by gold desc)) as max_gold
		,concat(first_value(country) over (partition by games order by silver desc),'-',first_value(silver) over (partition by games order by silver desc)) as max_silver
		,concat(first_value(country) over (partition by games order by bronze desc),'-',first_value(bronze) over (partition by games order by bronze desc)) as max_bronze
		,concat(first_value(country) over (partition by games order by total_medals desc),'-',first_value(total_medals) over (partition by games order by total_medals desc)) as max_medals
	from temp order by games;

-- 18. Which countries have never won gold medal but have won silver/bronze medals?

SELECT *
FROM (
	SELECT country,
		coalesce(gold, 0) AS gold,
		coalesce(silver, 0) AS silver,
		coalesce(bronze, 0) AS bronze
	FROM CROSSTAB('SELECT nr.region as country
    					, medal, count(1) as total_medals
    					FROM OLYMPICS_HISTORY oh
    					JOIN OLYMPICS_HISTORY_NOC_REGIONS nr ON nr.noc=oh.noc
    					where medal <> ''NA''
    					GROUP BY nr.region,medal order BY nr.region,medal', 'values (''Bronze''), (''Gold''), (''Silver'')') AS FINAL_RESULT(country VARCHAR, bronze BIGINT, gold BIGINT, silver BIGINT)
	) x
WHERE gold = 0
	AND (
		silver > 0
		OR bronze > 0
		)
ORDER BY gold DESC nulls last,
	silver DESC nulls last,
	bronze DESC nulls last;

-- 19. In which Sport/event, India has won highest medals.
WITH india
AS (
	SELECT sport,
		count(1)
	FROM olympics_history oh
	WHERE team = 'India'
		AND medal <> 'NA'
	GROUP BY sport
	),
ranked
AS (
	SELECT *,
		rank() OVER (
			ORDER BY count DESC
			)
	FROM india
	)
SELECT sport,
	count AS medals
FROM ranked
WHERE rank = 1;

--   20. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.

WITH india
AS (
	SELECT team,
		sport,
		games,
		count(1) AS medals
	FROM olympics_history oh
	WHERE team = 'India'
		AND sport = 'Hockey'
		AND medal <> 'NA'
	GROUP BY team,
		sport,
		games
	ORDER BY games
	)
SELECT *
FROM india