-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 08_build_notary_metrics.sql
-- Purpose:
-- Build aggregated notary performance metrics
-- =====================================================

USE notary_project;

-- =====================================================
-- 1. Clear existing metrics
-- =====================================================

TRUNCATE TABLE notary_metrics;


-- =====================================================
-- 2. Build aggregated performance metrics
-- =====================================================

INSERT INTO notary_metrics (
    notary,
    total_cases,
    total_fee,
    average_fee,
    overseas_case_count,
    domestic_case_count,
    inheritance_case_count
)

SELECT

    notary,

    COUNT(*) AS total_cases,

    SUM(notary_fee) AS total_fee,

    ROUND(AVG(notary_fee), 2) AS average_fee,

    SUM(
        CASE
            WHEN notarization_category LIKE '%涉外%'
            THEN 1
            ELSE 0
        END
    ) AS overseas_case_count,

    SUM(
        CASE
            WHEN notarization_category NOT LIKE '%涉外%'
            THEN 1
            ELSE 0
        END
    ) AS domestic_case_count,

    SUM(
        CASE
            WHEN case_type LIKE '%继承%'
            THEN 1
            ELSE 0
        END
    ) AS inheritance_case_count

FROM case_records

GROUP BY notary;

-- =====================================================
-- 3. Quality checks for notary metrics
-- =====================================================

-- Total notaries
SELECT COUNT(*) AS total_notaries
FROM notary_metrics;

-- Top notaries by case volume
SELECT
    notary,
    total_cases,
    total_fee,
    average_fee
FROM notary_metrics
ORDER BY total_cases DESC
LIMIT 10;

-- Top notaries by total fee
SELECT
    notary,
    total_cases,
    total_fee,
    average_fee
FROM notary_metrics
ORDER BY total_fee DESC
LIMIT 10;

-- Check total cases consistency
SELECT
    (SELECT COUNT(*) FROM case_records) AS case_records_count,
    (SELECT SUM(total_cases) FROM notary_metrics) AS metrics_total_cases;