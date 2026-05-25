-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 11_create_public_dashboard_dataset.sql
-- Purpose:
-- Create public-safe anonymized datasets for dashboard
-- =====================================================

USE notary_project;

CREATE OR REPLACE VIEW v_public_case_records AS
SELECT
    c.case_id,
    'REDACTED_CLIENT' AS client_name,
    c.case_type,
    sm.anonymized_name AS notary,
    c.workflow_status,
    c.case_category,
    c.notarization_category,
    c.usage_country,
    c.accept_date,
    c.issue_date,
    c.notary_fee,
    c.fee_status
FROM case_records c
LEFT JOIN staff_mapping sm
    ON c.notary = sm.original_name;
    
SELECT *
FROM v_public_case_records
LIMIT 50;