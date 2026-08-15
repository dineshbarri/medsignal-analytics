-- MedSignal Analytics | Dinesh Barri
-- PostgreSQL analyst layer for table adverse_event_reports.

-- 1. Product-level safety outcome scorecard
SELECT
    drug_name,
    COUNT(*) AS reports,
    ROUND(100.0 * AVG((serious_label = 'Serious')::int), 2) AS serious_rate_pct,
    ROUND(100.0 * AVG((seriousnessdeath = 1)::int), 2) AS death_rate_pct,
    ROUND(100.0 * AVG((seriousnesshospitalisation = 1)::int), 2) AS hospitalisation_rate_pct
FROM adverse_event_reports
GROUP BY drug_name
ORDER BY reports DESC;

-- 2. Reporting trend with year-over-year change
WITH annual AS (
    SELECT year, COUNT(*) AS reports
    FROM adverse_event_reports
    GROUP BY year
)
SELECT
    year,
    reports,
    reports - LAG(reports) OVER (ORDER BY year) AS absolute_yoy_change,
    ROUND(100.0 * (reports::numeric / NULLIF(LAG(reports) OVER (ORDER BY year), 0) - 1), 2)
        AS yoy_change_pct
FROM annual
ORDER BY year;

-- 3. Demographic completeness by product
SELECT
    drug_name,
    ROUND(100.0 * AVG((patient_age IS NULL)::int), 2) AS missing_age_pct,
    ROUND(100.0 * AVG((sex_label IS NULL OR sex_label = 'Unknown')::int), 2) AS missing_sex_pct
FROM adverse_event_reports
GROUP BY drug_name
ORDER BY drug_name;
