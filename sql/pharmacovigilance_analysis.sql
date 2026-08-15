
-- FDA Adverse Event Analysis: SQL Queries
-- Author: Dinesh Barri
-- Dataset: FDA FAERS 2022 to 2025
-- Database: PostgreSQL 16
-- Table: fda_adverse_events

-- Query 1: Total Records and Drug Distribution
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY total_reports DESC;

-- Query 2: Serious Event Distribution
SELECT 
    serious_label,
    COUNT(*) as total_reports,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM fda_adverse_events
GROUP BY serious_label
ORDER BY total_reports DESC;

-- Query 3: Death Reports by Drug
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) as death_reports,
    ROUND(SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as death_rate
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY death_rate DESC;

-- Query 4: Hospitalisation Rate by Drug
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    SUM(CASE WHEN seriousnesshospitalisation = '1' THEN 1 ELSE 0 END) as hosp_reports,
    ROUND(SUM(CASE WHEN seriousnesshospitalisation = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as hosp_rate
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY hosp_rate DESC;

-- Query 5: Sex Distribution
SELECT 
    sex_label,
    COUNT(*) as total_reports,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM fda_adverse_events
WHERE sex_label != 'Unknown'
GROUP BY sex_label
ORDER BY total_reports DESC;

-- Query 6: Age Group Distribution
SELECT 
    age_group,
    COUNT(*) as total_reports,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM fda_adverse_events
GROUP BY age_group
ORDER BY CASE age_group
    WHEN 'Under 18' THEN 1
    WHEN '18 to 44' THEN 2
    WHEN '45 to 64' THEN 3
    WHEN '65 to 84' THEN 4
    WHEN '85 and over' THEN 5
    WHEN 'Unknown' THEN 6
    ELSE 7
END;

-- Query 7: Serious Event Rate by Drug
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) as serious_reports,
    ROUND(SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as serious_rate
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY serious_rate DESC;

-- Query 8: Yearly Trend Analysis
SELECT 
    year,
    COUNT(*) as total_reports,
    SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) as serious_reports,
    ROUND(SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as serious_rate,
    SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) as death_reports,
    ROUND(SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as death_rate
FROM fda_adverse_events
GROUP BY year
ORDER BY year;

-- Query 9: Top 15 Reporting Countries
SELECT 
    CASE reporter_country
        WHEN 'US' THEN 'United States'
        WHEN 'CA' THEN 'Canada'
        WHEN 'GB' THEN 'United Kingdom'
        WHEN 'DE' THEN 'Germany'
        WHEN 'ES' THEN 'Spain'
        WHEN 'FR' THEN 'France'
        WHEN 'IT' THEN 'Italy'
        WHEN 'CN' THEN 'China'
        WHEN 'NL' THEN 'Netherlands'
        WHEN 'AU' THEN 'Australia'
        WHEN 'JP' THEN 'Japan'
        WHEN 'PL' THEN 'Poland'
        WHEN 'PT' THEN 'Portugal'
        WHEN 'BE' THEN 'Belgium'
        WHEN 'SE' THEN 'Sweden'
        WHEN 'BR' THEN 'Brazil'
        ELSE reporter_country
    END as country,
    COUNT(*) as total_reports,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentage
FROM fda_adverse_events
WHERE reporter_country != 'Unknown'
GROUP BY reporter_country
ORDER BY total_reports DESC, reporter_country ASC
LIMIT 15;

-- Query 10: Disabling Event Rate by Drug
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    SUM(CASE WHEN seriousnessdisabling = '1' THEN 1 ELSE 0 END) as disabling_reports,
    ROUND(SUM(CASE WHEN seriousnessdisabling = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as disabling_rate
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY disabling_rate DESC;

-- Query 11: Life Threatening Event Rate by Drug
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    SUM(CASE WHEN seriousnesslifethreatening = '1' THEN 1 ELSE 0 END) as lifethreat_reports,
    ROUND(SUM(CASE WHEN seriousnesslifethreatening = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as lifethreat_rate
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY lifethreat_rate DESC;

-- Query 12: Serious Event Rate by Age Group and Sex
SELECT 
    age_group,
    sex_label,
    COUNT(*) as total_reports,
    SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) as serious_reports,
    ROUND(SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as serious_rate
FROM fda_adverse_events
WHERE sex_label != 'Unknown'
AND age_group != 'Unknown'
GROUP BY age_group, sex_label
ORDER BY sex_label ASC, serious_rate DESC;

-- Query 13: Month on Month Change
WITH monthly AS (
    SELECT 
        year,
        month,
        COUNT(*) as total_reports
    FROM fda_adverse_events
    GROUP BY year, month
    ORDER BY year, month
)
SELECT 
    year,
    month,
    total_reports,
    LAG(total_reports) OVER (ORDER BY year, month) as previous_month,
    total_reports - LAG(total_reports) OVER (ORDER BY year, month) as change
FROM monthly
ORDER BY year, month;

-- Query 14: Comprehensive Drug Safety Summary
SELECT 
    drug_name,
    COUNT(*) as total_reports,
    ROUND(SUM(CASE WHEN serious_label = 'Serious' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as serious_rate,
    ROUND(SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as death_rate,
    ROUND(SUM(CASE WHEN seriousnesshospitalisation = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as hosp_rate,
    ROUND(SUM(CASE WHEN seriousnessdisabling = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as disabling_rate,
    ROUND(SUM(CASE WHEN seriousnesslifethreatening = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as lifethreat_rate
FROM fda_adverse_events
GROUP BY drug_name
ORDER BY serious_rate DESC;

-- Query 15: Yearly Death Rate Trend with LAG
WITH yearly AS (
    SELECT 
        year,
        COUNT(*) as total_reports,
        SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) as death_reports,
        ROUND(SUM(CASE WHEN seriousnessdeath = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as death_rate
    FROM fda_adverse_events
    GROUP BY year
)
SELECT 
    year,
    total_reports,
    death_reports,
    death_rate,
    LAG(death_rate) OVER (ORDER BY year) as previous_year_rate,
    ROUND(death_rate - LAG(death_rate) OVER (ORDER BY year), 2) as rate_change
FROM yearly
ORDER BY year;

