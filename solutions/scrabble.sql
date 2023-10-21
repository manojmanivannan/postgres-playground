-- 1. How many games did Harriette Lakernick win in the first tournament and what was her average rating change?
select
    winnername,
    round(avg(winnernewrating - winneroldrating),2) as avg_rating_change
from
    scrabble
WHERE
    winnername = 'Harriette Lakernick'
    and tourneyid = 1
group by
    winnername;

-- 2.Which player had the highest rating in the dataset and how many games did they play ?
with t1 as (
    select
        distinct winnername as winnername,
        max(winnernewrating) as rating,
        count(1) as no_games
    from
        scrabble
    group by
        winnername
    order by
        winnername
),
t2 as (
    select
        *,
        RANK() over(
            order by
                rating DESC
        ) as rank
    from
        t1
)
select
    winnername,
    rating,
    no_games
from
    t2
where
    rank = 1;

--3. How many games ended in a tie and which division had the most ties?
WITH t1
AS (
    SELECT division,
        count(1) AS n_games
    FROM scrabble s
    WHERE tie = true
    GROUP BY division
    ),
t2
AS (
    SELECT *,
        rank() OVER (
            ORDER BY n_games DESC
            )
    FROM t1
    )
SELECT division,
    n_games
FROM t2
WHERE rank = 1;

--4. Which date had the most games played ?
WITH t1
AS (
    SELECT DATE,
        count(1) no_games
    FROM scrabble
    GROUP BY DATE
    ),
t2
AS (
    SELECT *,
        rank() OVER (
            ORDER BY no_games DESC
            )
    FROM t1
    )
SELECT DATE,
    no_games
FROM t2
WHERE rank = 1;


