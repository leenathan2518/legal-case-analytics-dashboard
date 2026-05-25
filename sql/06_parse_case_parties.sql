-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 06_parse_case_parties.sql
-- Purpose:
-- Parse multi-party case records into normalized party-level table
-- =====================================================

USE notary_project;

-- =====================================================
-- 1. Create helper numbers table
-- =====================================================

DROP TEMPORARY TABLE IF EXISTS temp_numbers;

CREATE TEMPORARY TABLE temp_numbers (
    n INT PRIMARY KEY
);

INSERT INTO temp_numbers (n)
VALUES
    (0), (1), (2), (3), (4),
    (5), (6), (7), (8), (9);
    
-- =====================================================
-- 2. Parse party names into case_parties
-- =====================================================

SET SQL_SAFE_UPDATES = 0;

SELECT
    MAX(CHAR_LENGTH(`证件号码`)) AS max_id_number_length
FROM data_2023.`2023_whole`;

SELECT
    `卷宗号`,
    `当事人`,
    `证件类型`,
    `证件号码`,
    CHAR_LENGTH(`证件号码`) AS id_number_length
FROM data_2023.`2023_whole`
WHERE CHAR_LENGTH(`证件号码`) > 255
ORDER BY id_number_length DESC
LIMIT 20;

ALTER TABLE case_parties
MODIFY COLUMN id_number TEXT;

DELETE FROM case_parties;

INSERT INTO case_parties (
    case_id,
    party_name,
    id_type,
    id_number,
    phone_number,
    is_primary_party
)
SELECT
    TRIM(w.`卷宗号`) AS case_id,

    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(w.`当事人`, '、', nums.n + 1),
            '、',
            -1
        )
    ) AS party_name,

    TRIM(w.`证件类型`) AS id_type,
    TRIM(w.`证件号码`) AS id_number,
    TRIM(w.`联系电话`) AS phone_number,

    CASE
        WHEN nums.n = 0 THEN TRUE
        ELSE FALSE
    END AS is_primary_party

FROM data_2023.`2023_whole` w
JOIN temp_numbers nums
    ON nums.n < 1 + LENGTH(w.`当事人`) - LENGTH(REPLACE(w.`当事人`, '、', ''))

WHERE w.`当事人` IS NOT NULL
  AND TRIM(w.`当事人`) <> '';
  
SET SQL_SAFE_UPDATES = 1;

-- =====================================================
-- 3. Quality checks for parsed parties
-- =====================================================

-- Total parsed party records
SELECT COUNT(*) AS total_party_records
FROM case_parties;

-- Cases with multiple parties
SELECT
    case_id,
    COUNT(*) AS party_count
FROM case_parties
GROUP BY case_id
HAVING COUNT(*) > 1
ORDER BY party_count DESC
LIMIT 20;

-- Check missing party names
SELECT COUNT(*) AS missing_party_names
FROM case_parties
WHERE party_name IS NULL
   OR party_name = '';

-- Preview parsed parties
SELECT *
FROM case_parties
LIMIT 50;