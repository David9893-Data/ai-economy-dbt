with source as (
    select * from {{ source('raw', 'workforce_displacement') }}
),

renamed as (
    select
        record_id,
        country,
        iso3_code,
        region,
        income_group,
        year,
        quarter,
        quarter_label,
        industry_sector,
        sector_automation_risk_score,
        gdp_per_capita_usd,
        ai_adoption_index,
        pct_sector_workforce_displaced,
        pct_sector_workforce_new_roles_created,
        net_workforce_change_pct,
        ai_cited_layoff_announcements,
        ai_skill_wage_premium_pct,
        pct_workforce_female,
        pct_displaced_roles_female,
        reskilling_programs_count,
        govt_ai_policy_score_1_to_10,
        ai_tool_adoption_pct
    from source
)

select * from renamed
