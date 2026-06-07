with pulse as (
    select * from {{ ref('int_country_pulse') }}
)

select
    country,
    year,
    gdp_per_capita_usd,

    -- AI investment & policy
    ai_investment_billion_usd,
    round(ai_policy_index, 3) as ai_policy_index,
    round(avg_policy_score, 1) as govt_ai_policy_score,
    round(ai_readiness_score, 1) as ai_readiness_score,

    -- Workforce transition
    round(automation_rate_pct, 2) as automation_rate_pct,
    round(employment_rate_pct, 2) as employment_rate_pct,
    round(avg_pct_displaced * 100, 2) as pct_workforce_displaced,
    round(avg_pct_new_roles * 100, 2) as pct_workforce_new_roles,
    round(avg_net_workforce_change_pct * 100, 2) as net_workforce_change_pct,
    total_ai_layoffs,

    -- Labor market & productivity
    round(avg_salary_usd, 0) as avg_salary_usd,
    round(productivity_index, 1) as productivity_index,
    round(avg_ai_wage_premium_pct * 100, 2) as ai_wage_premium_pct,
    round(avg_tool_adoption_pct * 100, 2) as ai_tool_adoption_pct,

    -- Jobs (in millions)
    jobs_displaced_million,
    jobs_created_million,
    case
        when jobs_displaced_million is null or jobs_displaced_million = 0 then null
        else round(jobs_created_million / jobs_displaced_million, 2)
    end as jobs_balance_ratio,

    -- Country readiness tier
    case
        when ai_readiness_score >= 60 then '01_leader'
        when ai_readiness_score >= 45 then '02_competitive'
        when ai_readiness_score >= 30 then '03_emerging'
        else '04_lagging'
    end as readiness_tier

from pulse
where country is not null
  and year is not null
