with annual as (
    select * from {{ ref('stg_workforce_automation') }}
),

quarterly as (
    select
        country,
        year,
        avg(ai_adoption_index) as avg_ai_adoption_index,
        avg(pct_sector_workforce_displaced) as avg_pct_displaced,
        avg(pct_sector_workforce_new_roles_created) as avg_pct_new_roles,
        avg(net_workforce_change_pct) as avg_net_workforce_change_pct,
        sum(ai_cited_layoff_announcements) as total_ai_layoffs,
        avg(ai_skill_wage_premium_pct) as avg_ai_wage_premium_pct,
        avg(govt_ai_policy_score_1_to_10) as avg_policy_score,
        avg(ai_tool_adoption_pct) as avg_tool_adoption_pct,
        max(gdp_per_capita_usd) as gdp_per_capita_usd
    from {{ ref('stg_workforce_displacement') }}
    group by country, year
)

select
    coalesce(a.country, q.country) as country,
    coalesce(a.year, q.year) as year,

    -- From annual macro aggregates
    a.ai_investment_billion_usd,
    a.automation_rate_pct,
    a.employment_rate_pct,
    a.avg_salary_usd,
    a.productivity_index,
    a.ai_policy_index,
    a.jobs_displaced_million,
    a.jobs_created_million,
    a.ai_readiness_score,

    -- From quarterly displacement (aggregated to year)
    q.avg_ai_adoption_index,
    q.avg_pct_displaced,
    q.avg_pct_new_roles,
    q.avg_net_workforce_change_pct,
    q.total_ai_layoffs,
    q.avg_ai_wage_premium_pct,
    q.avg_policy_score,
    q.avg_tool_adoption_pct,
    q.gdp_per_capita_usd

from annual a
full outer join quarterly q
    on a.country = q.country
   and a.year = q.year
