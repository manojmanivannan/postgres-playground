
-- Find the top 5 countries who had the highest inflation rates 
-- and whose inflation increased or remained same for 3 or more consecutive years
-- optionally, give the year range where this increase occured

select regionalmember as country,inflation as max_inflation,increase as year_range from
(
select *
from (
    select regionalmember,year,inflation,
            case when inflation>=inflation_1 and inflation_1>=inflation_2 then concat(year-2,'-',year)
            else 'No'
            end as increase
    from (
        select 
            regionalmember, year, inflation,
            lag(inflation,1) over(PARTITION BY regionalmember ORDER BY year ) as inflation_1,
            lag(inflation,2) over(PARTITION BY regionalmember ORDER BY year) as inflation_2
        from
            inflation_data ) a 
) b where increase<>'No' ) c order by inflation desc limit 5;
