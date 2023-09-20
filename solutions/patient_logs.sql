-- Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
-- Note: Prefer the account id with the least value in case of same number of unique patients

-- select * from patient_logs order by account_id;

select  account_id,
        month,
        uniq_patients 
from (
    select  
        account_id, 
        month, 
        uniq_patients, 
        row_number() over(PARTITION BY month order by account_id) as rank
    from (
        select 
            account_id,
            to_char(date,'month') as month,
            count(distinct(patient_id)) as uniq_patients 
        from 
            patient_logs 
        group by account_id, to_char(date,'month')
    ) pl 
    order by rank
) s 
where rank <=2 
order by uniq_patients desc;
