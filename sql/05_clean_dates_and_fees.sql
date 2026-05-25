-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 05_clean_dates_and_fees.sql
-- Purpose:
-- Validate and clean date and fee fields
-- =====================================================

USE notary_project;

-- =====================================================
-- 1. Date validation
-- =====================================================

-- Check invalid date order
SELECT
    COUNT(*) AS invalid_date_order_count
FROM case_records
WHERE issue_date < accept_date;

-- Preview invalid date records
SELECT *
FROM case_records
WHERE issue_date < accept_date
LIMIT 20;


-- =====================================================
-- 2. Fee validation
-- =====================================================

-- Check missing fee values
SELECT
    COUNT(*) AS missing_fee_count
FROM case_records
WHERE notary_fee IS NULL;

-- Check zero-fee cases
SELECT
    COUNT(*) AS zero_fee_count
FROM case_records
WHERE notary_fee = 0;

-- Check abnormal fee values
SELECT *
FROM case_records
WHERE notary_fee < 0
   OR notary_fee > 10000
LIMIT 50;


-- =====================================================
-- 3. Fee status validation
-- =====================================================

-- Fee status distribution
SELECT
    fee_status,
    COUNT(*) AS case_count
FROM case_records
GROUP BY fee_status
ORDER BY case_count DESC;

-- 4. Change issue_data with 0000-00-00

SET SQL_SAFE_UPDATES = 0;

UPDATE case_records
SET issue_date = NULL
WHERE issue_date = '0000-00-00';

SET SQL_SAFE_UPDATES = 1;

SELECT COUNT(*) AS missing_issue_date
FROM case_records
WHERE issue_date IS NULL;

-- 5. Fee Status update

SELECT *
FROM case_records
WHERE fee_status IS NULL
   OR fee_status = ''
LIMIT 50;

SET SQL_SAFE_UPDATES = 0;

UPDATE case_records
SET fee_status = 'Unknown'
WHERE fee_status IS NULL
   OR fee_status = '';

SET SQL_SAFE_UPDATES = 1;

-- Check zero-fee cases by fee status
SELECT
    fee_status,
    COUNT(*) AS case_count
FROM case_records
WHERE notary_fee = 0
GROUP BY fee_status
ORDER BY case_count DESC;

-- Check fee status by fee amount group
SELECT
    CASE
        WHEN notary_fee = 0 THEN 'Zero fee'
        WHEN notary_fee > 0 THEN 'Positive fee'
        ELSE 'Missing fee'
    END AS fee_group,
    fee_status,
    COUNT(*) AS case_count
FROM case_records
GROUP BY fee_group, fee_status
ORDER BY fee_group, case_count DESC;

-- =====================================================
-- Cleaning Summary
-- =====================================================

SELECT
    COUNT(*) AS total_cases,
    
    SUM(CASE WHEN issue_date IS NULL THEN 1 ELSE 0 END)
        AS missing_issue_dates,

    SUM(CASE WHEN notary_fee = 0 THEN 1 ELSE 0 END)
        AS zero_fee_cases,

    SUM(CASE WHEN fee_status = 'Unknown' THEN 1 ELSE 0 END)
        AS unknown_fee_status_cases

FROM case_records;