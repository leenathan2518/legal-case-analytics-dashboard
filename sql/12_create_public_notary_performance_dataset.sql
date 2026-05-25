-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 12_create_public_notary_performance_dataset.sql
-- Purpose:
-- Create public-safe anonymized datasets for notary_performance
-- =====================================================

USE notary_project;

CREATE OR REPLACE VIEW v_public_notary_performance AS
SELECT
    sm.anonymized_name AS notary,
    nm.total_cases,
    nm.total_fee,
    nm.average_fee,
    nm.overseas_case_count,
    nm.domestic_case_count,
    nm.inheritance_case_count
FROM notary_metrics nm
LEFT JOIN staff_mapping sm
    ON nm.notary = sm.original_name;
    
SELECT *
FROM v_public_notary_performance;