with adoption as (
    select * from {{ ref('stg_company_adoption') }}
)

select
    survey_year,
    region,
    country,
    industry,
    company_size,

    -- Volume signals
    count(distinct company_id) as companies_surveyed,
    count(*) as total_responses,
    sum(num_employees) as total_employees,
    avg(annual_revenue_usd_millions) as avg_revenue_musd,

    -- AI adoption
    avg(ai_adoption_rate) as avg_adoption_rate,
    avg(ai_maturity_score) as avg_maturity_score,
    avg(ai_budget_percentage) as avg_budget_pct,
    avg(ai_failure_rate) as avg_failure_rate,
    avg(ai_investment_per_employee) as avg_investment_per_employee,

    -- Workforce impact
    sum(jobs_displaced) as total_jobs_displaced,
    sum(jobs_created) as total_jobs_created,
    sum(reskilled_employees) as total_reskilled,
    sum(jobs_created) - sum(jobs_displaced) as net_jobs_impact,

    -- Productivity & financial
    avg(productivity_change_percent) as avg_productivity_change_pct,
    avg(time_saved_per_week) as avg_time_saved_per_week,
    avg(revenue_growth_percent) as avg_revenue_growth_pct,
    avg(cost_reduction_percent) as avg_cost_reduction_pct,
    avg(innovation_score) as avg_innovation_score,
    avg(customer_satisfaction) as avg_customer_satisfaction

from adoption
group by survey_year, region, country, industry, company_size
