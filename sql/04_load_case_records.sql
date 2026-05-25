-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 04_load_case_records.sql
-- Purpose:
-- Load raw case data into structured case_records table
-- =====================================================

USE notary_project;

-- Clear existing records before reloading
DELETE FROM case_records;

-- Insert cleaned case-level records
INSERT INTO case_records (
    case_id,
    certificate_number,
    client_name,
    case_type,
    notary,
    assistant_name,
    workflow_status,
    case_category,
    notarization_category,
    usage_country,
    accept_date,
    issue_date,
    notary_fee,
    fee_status
)
SELECT
    TRIM(`卷宗号`) AS case_id,
    MAX(TRIM(`公证书编号`)) AS certificate_number,
    MAX(TRIM(`当事人`)) AS client_name,
    MAX(TRIM(`公证事项`)) AS case_type,
    MAX(TRIM(`公证员`)) AS notary,
    MAX(TRIM(`助理`)) AS assistant_name,
    MAX(TRIM(`流程状态`)) AS workflow_status,
    MAX(TRIM(`案件类型`)) AS case_category,
    MAX(TRIM(`公证类别`)) AS notarization_category,
    MAX(TRIM(`使用地`)) AS usage_country,
    MIN(convert_to_date(`受理时间`)) AS accept_date,
    MIN(convert_to_date(`出证时间`)) AS issue_date,
    MAX(CAST(`公证费` AS DECIMAL(10,2))) AS notary_fee,
    MAX(TRIM(`收费状态`)) AS fee_status
FROM data_2023.`2023_whole`
GROUP BY TRIM(`卷宗号`);

-- Check loaded records
SELECT COUNT(*) AS loaded_case_count
FROM case_records;

-- Preview loaded data
SELECT *
FROM case_records
LIMIT 20;

-- Check missing certificate numbers
SELECT COUNT(*) AS missing_certificate_number
FROM case_records
WHERE certificate_number IS NULL
   OR certificate_number = '';
   
-- Preview missing certificate numbers
SELECT *
FROM case_records
WHERE certificate_number IS NULL
   OR certificate_number = ''
LIMIT 20;

-- Missing issue dates
SELECT COUNT(*) AS missing_issue_date
FROM case_records
WHERE issue_date IS NULL;

-- Missing notary names
SELECT COUNT(*) AS missing_notary
FROM case_records
WHERE notary IS NULL
   OR notary = '';