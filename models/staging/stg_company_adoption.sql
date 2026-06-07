with source as (
    select * from {{ source('raw', 'company_adoption') }}
),

renamed as (
    select
        response_id,
        company_id,
        survey_year,
        quarter,
        country,
        region,
        industry,
        company_size,
        num_employees,
        annual_revenue_usd_millions,
        company_founding_year,
        company_age,
        company_age_group,

        -- AI adoption metrics
        ai_adoption_rate,
        ai_adoption_stage,
        years_using_ai,
        ai_primary_tool,
        num_ai_tools_used,
        ai_use_case,
        ai_projects_active,
        ai_training_hours,
        ai_budget_percentage,
        ai_maturity_score,
        ai_failure_rate,
        ai_investment_per_employee,

        -- Governance
        regulatory_compliance_score,
        data_privacy_level,
        ai_ethics_committee,
        ai_risk_management_score,

        -- Operational outcomes
        remote_work_percentage,
        employee_satisfaction_score,
        task_automation_rate,
        time_saved_per_week,
        productivity_change_percent,
        jobs_displaced,
        jobs_created,
        reskilled_employees,

        -- Financial outcomes
        revenue_growth_percent,
        cost_reduction_percent,
        innovation_score,
        customer_satisfaction
    from source
)

select * from renamed
