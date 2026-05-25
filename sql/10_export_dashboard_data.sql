-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 10_export_dashboard_data.sql
-- Purpose:
-- Export reporting datasets for dashboard visualization
-- =====================================================

USE notary_project;

-- =====================================================
-- 1. Monthly case summary export
-- =====================================================

SELECT *
FROM v_monthly_case_summary;


-- =====================================================
-- 2. Case type summary export
-- =====================================================

SELECT *
FROM v_case_type_summary;


-- =====================================================
-- 3. Notary performance export
-- =====================================================

SELECT *
FROM v_notary_performance;


-- =====================================================
-- 4. Fee status summary export
-- =====================================================

SELECT *
FROM v_fee_status_summary;


-- =====================================================
-- 5. Dashboard overview export
-- =====================================================

SELECT *
FROM v_dashboard_overview;

-- =====================================================
-- 6. Case record
-- =====================================================

SELECT *
FROM case_records;

-- =====================================================
-- 7. Case parites
-- =====================================================

SELECT *
FROM case_parties;

-- =====================================================
-- 8. Staff mapping
-- =====================================================

SELECT *
FROM staff_mapping;