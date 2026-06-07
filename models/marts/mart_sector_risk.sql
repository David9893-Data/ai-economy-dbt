with risk as (
    select * from {{ ref('int_sector_risk') }}
)

select
    year,
    region,
    income_group,
    country,
    industry_sector,

    -- Risk components
    round(automation_risk_score, 3) as automation_risk_score,
    round(workforce_ai_adoption, 3) as ai_adoption_index,
    total_ai_layoffs,
    round(avg_pct_displaced * 100, 2) as pct_workforce_displaced,
    round(avg_pct_new_roles * 100, 2) as pct_workforce_new_roles,

    -- Corporate side (may be null where industry names don't match)
    round(corporate_ai_adoption, 2) as corporate_ai_adoption_rate,
    round(corporate_ai_maturity, 2) as corporate_ai_maturity_score,
    corporate_jobs_displaced,
    corporate_jobs_created,

    -- Composite risk score (already computed in intermediate)
    composite_risk_score,

    -- Risk tier
    case
        when composite_risk_score >= 0.7 then '01_critical'
        when composite_risk_score >= 0.5 then '02_high'
        when composite_risk_score >= 0.3 then '03_moderate'
        else '04_low'
    end as risk_tier

from risk
where country is not null
  and industry_sector is not null
