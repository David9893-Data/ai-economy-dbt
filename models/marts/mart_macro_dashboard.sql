with signals as (
    select * from {{ ref('int_macro_signals') }}
)

select
    date,
    extract(year from date) as year,
    extract(quarter from date) as quarter,
    extract(month from date) as month,

    -- Headline AI stocks
    round(nvda_close, 2) as nvda_close,
    round(msft_close, 2) as msft_close,
    round(googl_close, 2) as googl_close,
    round(meta_close, 2) as meta_close,

    -- Rolling averages
    round(nvda_7d_avg, 2) as nvda_7d_avg,
    round(msft_7d_avg, 2) as msft_7d_avg,

    -- Daily returns
    round(nvda_daily_return_pct, 2) as nvda_daily_return_pct,
    round(msft_daily_return_pct, 2) as msft_daily_return_pct,
    round(nvda_30d_return_pct, 2) as nvda_30d_return_pct,

    -- Macro indicators
    round(vix, 2) as vix,
    round(us_10y_rate, 3) as us_10y_rate,
    round(dollar_index, 2) as dollar_index,
    round(gold_price, 2) as gold_price,
    volatility_regime,

    -- AI interest signals
    ai_total_interest,
    round(ai_interest_7d_avg, 1) as ai_interest_7d_avg

from signals
order by date
