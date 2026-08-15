# Methodology

## Analytical flow

1. Acquire public adverse-event reports through the openFDA drug-event endpoint.
2. Parse report-, patient-, product-, and outcome-level fields into an analytical table.
3. Standardize dates, products, demographic labels, and serious-outcome flags.
4. Measure completeness and reporting concentration before interpreting KPIs.
5. Compare report counts and outcome proportions by product, time, geography, and demographic group.
6. Screen drug–event pairs with Reporting Odds Ratio (ROR) and 95% confidence intervals.

## ROR

For a 2×2 table, `ROR = (a × d) / (b × c)`. A potential signal is often prioritized when the lower confidence bound is greater than 1 and sufficient cases are present. This is a screening rule, not proof of causation.

## Interpretation limits

Spontaneous reports are affected by under-reporting, stimulated reporting, duplicates, missing fields, coding variation, co-medications, indication bias, and absent exposure denominators. Rates in this project are proportions of submitted reports—not incidence rates in treated populations.
