with kpis as (
    select * from {{ ref('int_company_kpis') }}
)

select
    survey_year as year,
    region,
    country,
    industry,
    company_size,
    companies_surveyed,
    total_employees,
    avg_revenue_musd,

    -- Adoption maturity
    round(avg_adoption_rate, 2) as avg_adoption_rate_pct,
    round(avg_maturity_score, 2) as avg_maturity_score,
    round(avg_budget_pct, 2) as avg_ai_budget_pct,
    round(avg_failure_rate, 2) as avg_failure_rate_pct,
    round(avg_investment_per_employee, 0) as avg_investment_per_employee_usd,

    -- Workforce impact
    total_jobs_displaced,
    total_jobs_created,
    total_reskilled,
    net_jobs_impact,
    case
        when total_jobs_displaced = 0 then null
        else round(total_jobs_created::float / total_jobs_displaced, 2)
    end as jobs_created_to_displaced_ratio,

    -- ROI signals
    round(avg_productivity_change_pct, 2) as avg_productivity_change_pct,
    round(avg_time_saved_per_week, 2) as avg_hours_saved_per_week,
    round(avg_revenue_growth_pct, 2) as avg_revenue_growth_pct,
    round(avg_cost_reduction_pct, 2) as avg_cost_reduction_pct,
    round(avg_innovation_score, 1) as avg_innovation_score,
    round(avg_customer_satisfaction, 2) as avg_customer_satisfaction,

    -- AI maturity tier
    case
        when avg_maturity_score >= 70 then '01_leader'
        when avg_maturity_score >= 50 then '02_adopter'
        when avg_maturity_score >= 30 then '03_explorer'
        else '04_laggard'
    end as ai_maturity_tier

from kpis
where companies_surveyed >= 3  -- exclude noise from tiny samples
