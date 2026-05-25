USE data_2023;

-- Preview raw data
SELECT *
FROM 2023_whole
LIMIT 20;

-- Count rows
SELECT COUNT(*) AS total_rows
FROM 2023_whole;

-- Check columns with null values
SELECT
    COUNT(*) AS total_rows,
    COUNT(`卷宗号`) AS case_id_count,
    COUNT(`受理时间`) AS accept_date_count,
    COUNT(`公证费`) AS fee_count
FROM 2023_whole;

-- Distinct case types
SELECT DISTINCT `公证事项`
FROM 2023_whole
ORDER BY `公证事项`;

-- Check abnormal fee values
SELECT *
FROM 2023_whole
WHERE `公证费` < 0
   OR `公证费` > 10000;

-- Check date formats
SELECT DISTINCT `受理时间`
FROM 2023_whole
LIMIT 50;

-- Count case types
SELECT
    `公证事项`,
    COUNT(*) AS case_count
FROM data_2023.`2023_whole`
GROUP BY `公证事项`
ORDER BY case_count DESC;

-- Fee distribution
SELECT
    MIN(`公证费`) AS min_fee,
    MAX(`公证费`) AS max_fee,
    AVG(`公证费`) AS avg_fee
FROM data_2023.`2023_whole`;

-- Workflow status distribution
SELECT
    `流程状态`,
    COUNT(*) AS status_count
FROM data_2023.`2023_whole`
GROUP BY `流程状态`
ORDER BY status_count DESC;