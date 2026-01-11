                                                 -- Data Cleaning
-- Created database
create database insurance_project;

-- Changed inconsistent dates
-- INSR_BEGIN
select INSR_BEGIN,date_format(str_to_date(INSR_BEGIN,'%d-%b-%y'),'%Y/%m/%d') as insr
from motordata;

update motordata
set INSR_BEGIN = date_format(str_to_date(INSR_BEGIN,'%d-%b-%y'),'%Y/%m/%d');

-- INSR_END
update motordata
set INSR_END = date_format(str_to_date(INSR_END,'%d-%b-%y'),'%Y/%m/%d');

-- Changing inconsistent data
update motordata
set premium = round(premium,2);

-- Handling Blank and NULL values
update motordata
set PROD_YEAR = NULL
where PROD_YEAR='';

update motordata
set CARRYING_CAPACITY = 0
where CARRYING_CAPACITY='';

update motordata
set CLAIM_PAID = 0
where CLAIM_PAID='';

update motordata
set CLAIM_PAID = round(CLAIM_PAID,2);

-- Changed data type
alter table motordata
modify SEX text ,
modify INSR_BEGIN date ,
modify INSR_END date, 
modify INSR_TYPE text ,
modify PREMIUM decimal ,
modify OBJECT_ID text ,
modify PROD_YEAR text ,
modify SEATS_NUM int ,
modify CARRYING_CAPACITY int ,
modify TYPE_VEHICLE text ,
modify CCM_TON int ,
modify MAKE text ,
modify `USAGE` text ,
modify CLAIM_PAID decimal;

                                              -- Data Analysis
-- How many policies are sold?
select count(OBJECT_ID) as Total_policies
from motordata;											
              
-- How much Total premium was paid?
select sum(PREMIUM) as Premium_paid
from motordata;
    
-- How much Total claim was paid?
select sum(CLAIM_PAID) as Claim_paid
from motordata;    

-- How many policies were claimed?
select count(*) as Claimed_policies
from motordata
where CLAIM_PAID > 0;    

-- What is the average premium paid?
select avg(PREMIUM) as avg_premium
from motordata;    

-- What is the average claim paid?
select avg(CLAIM_PAID) as avg_premium
from motordata;    

-- What is the Premium to claim ratio?
select concat(round(100*sum(PREMIUM)/sum(CLAIM_PAID),2),'%') as Premium_to_claim_ratio
from motordata;  

-- How many policies are taken by each vehicle type?
select TYPE_VEHICLE,count(*) as Total_policies
from motordata
group by TYPE_VEHICLE
order by Total_policies desc;

-- How many policies are claimed by each sex type?
select sex,count(*) as Total_policies
from motordata
where CLAIM_PAID > 0
group by sex
order by Total_policies desc;

-- What are the TOP 3 Vehicle type claiming policies yearly?
with cte as
(select year(INSR_BEGIN) as `Year`,TYPE_VEHICLE,format(count(*),0) as Total_claims,
dense_rank() over(partition by year(INSR_BEGIN) order by count(*) desc) as ranks
from motordata
where CLAIM_PAID > 0
group by `Year`,TYPE_VEHICLE)

select `Year`,type_vehicle,total_claims
from cte
where ranks <= 3;

-- Identify vehicles with rising premiums year-over-year
-- Business Use-Case: Detect customers whose policy cost is increasing → target for retention.
with premium_years as
(select OBJECT_ID,year(INSR_BEGIN) as policy_year,premium, 
lag(premium) over(partition by OBJECT_ID order by year(INSR_BEGIN)) as last_paid_premium
from motordata)

select object_id,policy_year,premium,last_paid_premium,(premium-last_paid_premium) as premium_increase
from premium_years
where last_paid_premium is not null
 and premium > last_paid_premium;

-- Find the most profitable vehicle segments
-- Business Goal: What type of vehicle produces the most total premium?
with cte as
(select TYPE_VEHICLE,count(*) as Total_policies,sum(premium) as Total_premium_paid,
    round(avg(premium),2) as average_premium_paid,sum(CLAIM_PAID) as total_claimed_amount
from motordata
group by TYPE_VEHICLE
order by total_premium_paid desc)

select *
from cte;

-- Analyze claim percentage by vehicle make
-- Business Goal: Identify risky manufacturers.    
select make,
count(*) as total_policies,
sum(case when CLAIM_PAID > 0 then 1 else 0 end) as Total_claims,
concat(round(100*sum(case when CLAIM_PAID > 0 then 1 else 0 end)/count(*),2),'%') as claim_percentage,
sum(CLAIM_PAID) claimed_amount
from motordata
group by make
having claimed_amount > 0 
order by claimed_amount desc;

-- Identify aging vehicle portfolio risk
-- Business Goal: Older vehicles → higher breakdown and claim likelihood.
select PROD_YEAR,count(*) as total_policies,
sum(PREMIUM) as total_premium,
sum(CLAIM_PAID) as total_claimed_amount,     
    round(AVG(CLAIM_PAID),2) AS avg_claim
from motordata
group by PROD_YEAR
having total_claimed_amount > 0
order by total_claimed_amount desc;

-- Policy renewal behavior analysis
-- Business Goal: How many years do customers stay with the insurer?
select OBJECT_ID,TYPE_VEHICLE,PROD_YEAR,
count(*) as Total_renewals,
min(year(INSR_BEGIN)) as Insurance_start_date, 
max(year(INSR_END)) as Insurance_last_ended
from motordata
group by OBJECT_ID,TYPE_VEHICLE,PROD_YEAR
having Total_renewals > 1
order by Total_renewals desc;

-- Detect customers with repeated claims
-- Business Goal: Identify customers with consistent claim behavior.
select OBJECT_ID,TYPE_VEHICLE,PROD_YEAR,
count(*) as Total_claims,
sum(CLAIM_PAID) as Total_amount_claimed              
from motordata
where CLAIM_PAID > 0
group by OBJECT_ID,TYPE_VEHICLE,PROD_YEAR
having Total_claims > 1
order by Total_claims desc;

-- Correlate engine capacity with claim behavior
-- Business Goal: Determine if larger vehicles are riskier.
select 
case when CCM_TON <= 1500 then 'Small'
     when CCM_TON between 1500 and 3000 then 'Medium'
     else 'Large' end as Engine_type,
     count(*) as Total_policies,
     sum(CLAIM_PAID) as Total_amount_claimed,
     avg(CLAIM_PAID) as Average_claim
from motordata
group by Engine_type
order by Total_amount_claimed desc;

-- Which vehicles repeatedly pay lower-than-average premiums within the same segment?
with vehicle_segment as
(select TYPE_VEHICLE,round(avg(PREMIUM),2) as Average_premium
from motordata
group by TYPE_VEHICLE)

select m.OBJECT_ID,m.TYPE_VEHICLE,count(*) as years_underpriced,
v.Average_premium as segment_average_premium,
round(avg(m.PREMIUM),2) as average_premium_paid
from vehicle_segment as v
join motordata as m
 on v.TYPE_VEHICLE = m.TYPE_VEHICLE
 where m.PREMIUM < v.Average_premium   
 group by m.OBJECT_ID,m.TYPE_VEHICLE
 having years_underpriced > 2
 order by years_underpriced desc;
 
 -- Which vehicles cost the insurer more than they earn?
 SELECT 
    OBJECT_ID,TYPE_VEHICLE,
    sum(PREMIUM) AS total_premium_paid,
    sum(CLAIM_PAID) AS total_claimed_amount,
    (sum(PREMIUM) - sum(CLAIM_PAID)) AS net_profit
FROM motordata
GROUP BY OBJECT_ID,TYPE_VEHICLE
HAVING sum(CLAIM_PAID) > sum(PREMIUM)
ORDER BY net_profit;

