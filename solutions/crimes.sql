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