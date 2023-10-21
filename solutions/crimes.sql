-- 1. How many crimes were reported in each area and what was the most common crime type?

WITH tmp1
AS (
	SELECT area_name
		,crime_description
		,count(1) n_crimes
	FROM crime_data cd
	GROUP BY area_name
		,crime_description
	)
	,tmp2
AS (
	SELECT *
		,rank() OVER (
			PARTITION BY area_name ORDER BY n_crimes DESC
			) AS rnk
	FROM tmp1
	)
	,top_crime_by_area
AS (
	SELECT *
	FROM tmp2
	WHERE rnk = 1
	)
	,total_crimes_by_area
AS (
	SELECT area_name
		,sum(n_crimes) AS total_crimes
	FROM tmp1
	GROUP BY area_name
	)
SELECT tpc.area_name
	,CONCAT (
		tpc.crime_description
		,' - '
		,tpc.n_crimes
		) AS top_crime
	,toc.total_crimes AS total_crimes
FROM top_crime_by_area AS tpc
JOIN total_crimes_by_area AS toc ON tpc.area_name = toc.area_name;

--  2. Which are the months with highest reported crimes?
WITH tmp1
AS (
	SELECT extract(year FROM date_reported)::VARCHAR AS year
		,date_trunc('month', date_reported) AS date_month
		,count(1) AS crimes
	FROM crime_data cd
	GROUP BY year
		,date_month
	)
	,tmp2
AS (
	SELECT year
		,to_char(date_month, 'Month') AS month
		,crimes
		,rank() OVER (
			PARTITION BY year ORDER BY crimes DESC
			)
	FROM tmp1
	ORDER BY year
		,date_month
	)
SELECT year
	,month
	,crimes AS no_crimes
FROM tmp2
WHERE rank = 1;

--3. What is the percentage of male and female victims and how does it vary by crime type?
WITH crime_sex
AS (
	SELECT crime_description
		,victim_sex
		,count(1) AS no_crimes
	FROM crime_data cd
	WHERE victim_sex IN (
			'M'
			,'F'
			)
	GROUP BY crime_description
		,victim_sex
	)
	,crime_sex_split
AS (
	SELECT *
		,row_number() OVER (
			PARTITION BY crime_description ORDER BY victim_sex
			)
	FROM crime_sex
	)
	,female_split
AS (
	SELECT *
	FROM crime_sex_split
	WHERE row_number = 1
	)
	,male_split
AS (
	SELECT *
	FROM crime_sex_split
	WHERE row_number = 2
	)
SELECT ms.crime_description
	-- ,ms.no_crimes AS male_victims
	-- ,fs.no_crimes AS female_victims
	,CONCAT (
		'1 : '
		,round(ms.no_crimes::NUMERIC / fs.no_crimes, 2)
		) AS f_m_ratio
FROM male_split ms
JOIN female_split fs ON ms.crime_description = fs.crime_description
ORDER BY ms.no_crimes::numeric/fs.no_crimes DESC;

--4. Which weapon was used the most in violent crimes and what was the average victim age?

WITH weapon_list
AS (
	SELECT weapon_used_description AS weapon_used
		,count(1) n_crimes
	FROM crime_data cd
	WHERE weapon_used_description IS NOT NULL
	GROUP BY weapon_used_description
	)
	,top_weapons
AS (
	SELECT *
		,rank() OVER (
			ORDER BY n_crimes DESC
			)
	FROM weapon_list
	)
	,top_weapon
AS (
	SELECT weapon_used
	FROM top_weapons
	WHERE rank = 1
	)
SELECT cd.weapon_used_description AS weapon_used
	,round(avg(victim_age), 2) AS avg_vic_age
FROM crime_data cd
	,top_weapon
WHERE weapon_used_description = top_weapon.weapon_used
GROUP BY cd.weapon_used_description;