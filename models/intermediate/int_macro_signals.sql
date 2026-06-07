with daily as (
    select * from {{ ref('stg_economy_pulse') }}
),

with_features as (
    select
        date,

        -- Headline AI proxies
        nvda_close,
        msft_close,
        googl_close,
        meta_close,

        -- Macro risk indicators
        vix_close as vix,
        tnx_close as us_10y_rate,
        dxy_close as dollar_index,
        gld_close as gold_price,

        -- AI interest momentum
        ai_total_interest,
        ai_interest_7d_avg,
        nvda_30d_return_pct,

        -- Rolling averages on key stocks (7-day)
        avg(nvda_close) over (order by date rows between 6 preceding and current row) as nvda_7d_avg,
        avg(msft_close) over (order by date rows between 6 preceding and current row) as msft_7d_avg,

        -- Daily returns
        (nvda_close / lag(nvda_close) over (order by date) - 1) * 100 as nvda_daily_return_pct,
        (msft_close / lag(msft_close) over (order by date) - 1) * 100 as msft_daily_return_pct,

        -- Risk regime: VIX > 25 = high-stress
        case
            when vix_close < 15 then 'Low'
            when vix_close < 25 then 'Medium'
            else 'High'
        end as volatility_regime

    from daily
)

select * from with_features
