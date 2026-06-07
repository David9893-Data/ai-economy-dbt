with workforce as (
    select
        country,
        region,
        income_group,
        year,
        industry_sector,
        avg(sector_automation_risk_score) as automation_risk_score,
        avg(ai_adoption_index) as workforce_ai_adoption,
        sum(ai_cited_layoff_announcements) as total_ai_layoffs,
        avg(pct_sector_workforce_displaced) as avg_pct_displaced,
        avg(pct_sector_workforce_new_roles_created) as avg_pct_new_roles
    from {{ ref('stg_workforce_displacement') }}
    group by country, region, income_group, year, industry_sector
),

corporate as (
    select
        country,
        survey_year as year,
        industry,
        avg(ai_adoption_rate) as corporate_ai_adoption,
        avg(ai_maturity_score) as corporate_ai_maturity,
        sum(jobs_displaced) as corporate_jobs_displaced,
        sum(jobs_created) as corporate_jobs_created
    from {{ ref('stg_company_adoption') }}
    group by country, survey_year, industry
)

select
    w.country,
    w.region,
    w.income_group,
    w.year,
    w.industry_sector,

    -- Workforce-side risk indicators
    w.automation_risk_score,
    w.workforce_ai_adoption,
    w.total_ai_layoffs,
    w.avg_pct_displaced,
    w.avg_pct_new_roles,

    -- Corporate-side (industry name may not always match exactly — left join)
    c.corporate_ai_adoption,
    c.corporate_ai_maturity,
    c.corporate_jobs_displaced,
    c.corporate_jobs_created,

    -- Composite risk: automation + low new roles + high layoffs
    round(
        w.automation_risk_score * 0.4
        + (1 - w.avg_pct_new_roles) * 0.3
        + least(w.total_ai_layoffs / 100.0, 1.0) * 0.3,
        3
    ) as composite_risk_score

from workforce w
left join corporate c
    on w.country = c.country
   and w.year = c.year
   and w.industry_sector = c.industry
