with source as (
    select * from {{ source('raw', 'economy_pulse') }}
),

renamed as (
    select
        date::date as date,

        -- AI-focused stocks
        nvda_close, nvda_volume,
        amd_close,  amd_volume,
        intc_close, intc_volume,
        avgo_close, avgo_volume,
        ai_close,   ai_volume,
        pltr_close, pltr_volume,
        soun_close, soun_volume,
        ionq_close, ionq_volume,

        -- Big tech
        msft_close,  msft_volume,
        googl_close, googl_volume,
        meta_close,  meta_volume,
        amzn_close,  amzn_volume,
        orcl_close,  orcl_volume,

        -- Macro indicators
        vix_close, vix_volume,
        tnx_close, tnx_volume,
        dxy_close, dxy_volume,
        gld_close, gld_volume,

        -- AI interest signals
        ai_total_interest,
        ai_interest_7d_avg,
        nvda_30d_return_pct
    from source
)

select * from renamed
