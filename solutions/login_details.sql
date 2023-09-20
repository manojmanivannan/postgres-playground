-- From the login_details table, fetch the users who logged in consecutively 3 or more times.
select distinct user_name from (

    select *,
        case 
            when user_name = lead(user_name) over(order by login_id)
                and user_name = lead(user_name,2) over(order by login_id)
            then 'Yes' 
            else 'No'
        end as flag
            from login_details) a where flag = 'Yes';

-- select * from login_details;