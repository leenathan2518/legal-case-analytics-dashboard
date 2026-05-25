-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 09_create_reporting_views.sql
-- Purpose:
-- Create reporting views for dashboard exports
-- =====================================================

USE notary_project;

-- =====================================================
-- 1. Monthly case summary
-- =====================================================

CREATE OR REPLACE VIEW v_monthly_case_summary AS
SELECT
    DATE_FORMAT(accept_date, '%Y-%m') AS month,
    COUNT(*) AS total_cases,
    SUM(notary_fee) AS total_fee,
    ROUND(AVG(notary_fee), 2) AS average_fee,
    SUM(CASE WHEN notarization_category LIKE '%涉外%' THEN 1 ELSE 0 END) AS overseas_cases,
    SUM(CASE WHEN notarization_category NOT LIKE '%涉外%' THEN 1 ELSE 0 END) AS domestic_cases
FROM case_records
WHERE accept_date IS NOT NULL
GROUP BY DATE_FORMAT(accept_date, '%Y-%m')
ORDER BY month;

SELECT *
FROM v_monthly_case_summary;

-- =====================================================
-- 2. Case type summary
-- =====================================================

CREATE OR REPLACE VIEW v_case_type_summary AS
SELECT
    case_type,
    COUNT(*) AS total_cases,
    SUM(notary_fee) AS total_fee,
    ROUND(AVG(notary_fee), 2) AS average_fee
FROM case_records
GROUP BY case_type
ORDER BY total_cases DESC;

SELECT *
FROM v_case_type_summary
LIMIT 20;

-- =====================================================
-- 3. Notary performance view
-- =====================================================

CREATE OR REPLACE VIEW v_notary_performance AS
SELECT
    notary,
    total_cases,
    total_fee,
    average_fee,
    overseas_case_count,
    domestic_case_count,
    inheritance_case_count
FROM notary_metrics
ORDER BY total_cases DESC;

SELECT *
FROM v_notary_performance
LIMIT 20;

-- =====================================================
-- 4. Fee status summary
-- =====================================================

CREATE OR REPLACE VIEW v_fee_status_summary AS
SELECT
    fee_status,
    COUNT(*) AS total_cases,
    SUM(notary_fee) AS total_fee,
    ROUND(AVG(notary_fee), 2) AS average_fee
FROM case_records
GROUP BY fee_status
ORDER BY total_cases DESC;

SELECT *
FROM v_fee_status_summary;

-- =====================================================
-- 5. Dashboard overview KPI view
-- =====================================================

CREATE OR REPLACE VIEW v_dashboard_overview AS
SELECT

    COUNT(*) AS total_cases,

    SUM(notary_fee) AS total_fee,

    ROUND(AVG(notary_fee), 2) AS average_fee,

    COUNT(DISTINCT notary) AS total_notaries,

    SUM(
        CASE
            WHEN notarization_category LIKE '%涉外%'
            THEN 1
            ELSE 0
        END
    ) AS overseas_cases,

    SUM(
        CASE
            WHEN case_type LIKE '%继承%'
            THEN 1
            ELSE 0
        END
    ) AS inheritance_cases

FROM case_records;

SELECT *
FROM v_dashboard_overview;

