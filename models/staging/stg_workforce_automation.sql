with source as (
    select * from {{ source('raw', 'workforce_automation') }}
),

renamed as (
    select
        year,
        country,
        ai_investment_billionusd            as ai_investment_billion_usd,
        automation_rate_percent             as automation_rate_pct,
        employment_rate_percent             as employment_rate_pct,
        average_salary_usd                  as avg_salary_usd,
        productivity_index,
        reskilling_investment_millionusd    as reskilling_investment_million_usd,
        ai_policy_index,
        job_displacement_million            as jobs_displaced_million,
        job_creation_million                as jobs_created_million,
        ai_readiness_score
    from source
)

select * from renamed
