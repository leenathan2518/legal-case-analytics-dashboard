-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 07_build_staff_mapping.sql
-- Purpose:
-- Build anonymized staff mapping table
-- =====================================================

USE notary_project;

-- =====================================================
-- 1. Clear existing mapping records
-- =====================================================

SET SQL_SAFE_UPDATES = 0;

DELETE FROM staff_mapping;

DESCRIBE staff_mapping;

ALTER TABLE staff_mapping
CHANGE COLUMN staff_role staff_roles TEXT;

DESCRIBE staff_mapping;

-- =====================================================
-- 2. Build unified staff list from raw data
-- =====================================================

INSERT INTO staff_mapping (
    original_name,
    anonymized_name,
    staff_roles
)
SELECT
    original_name,

    CONCAT(
        'Staff_',
        LPAD(
            ROW_NUMBER() OVER (ORDER BY original_name),
            3,
            '0'
        )
    ) AS anonymized_name,

    GROUP_CONCAT(DISTINCT staff_role ORDER BY staff_role SEPARATOR ',') AS staff_roles

FROM (
    SELECT DISTINCT TRIM(`公证员`) AS original_name, 'notary' AS staff_role
    FROM data_2023.`2023_whole`
    WHERE `公证员` IS NOT NULL AND TRIM(`公证员`) <> ''

    UNION ALL

    SELECT DISTINCT TRIM(`助理`) AS original_name, 'assistant' AS staff_role
    FROM data_2023.`2023_whole`
    WHERE `助理` IS NOT NULL AND TRIM(`助理`) <> ''

    UNION ALL

    SELECT DISTINCT TRIM(`审批人`) AS original_name, 'approver' AS staff_role
    FROM data_2023.`2023_whole`
    WHERE `审批人` IS NOT NULL AND TRIM(`审批人`) <> ''

    UNION ALL

    SELECT DISTINCT TRIM(`协办人`) AS original_name, 'collaborator' AS staff_role
    FROM data_2023.`2023_whole`
    WHERE `协办人` IS NOT NULL AND TRIM(`协办人`) <> ''
) AS unified_staff

GROUP BY original_name;

SET SQL_SAFE_UPDATES = 1;

-- =====================================================
-- 3. Quality checks for staff mapping
-- =====================================================

-- Total mapped staff
SELECT COUNT(*) AS total_staff
FROM staff_mapping;

-- Staff with multiple roles
SELECT *
FROM staff_mapping
WHERE staff_roles LIKE '%,%'
ORDER BY original_name;

-- Role distribution
SELECT
    staff_roles,
    COUNT(*) AS staff_count
FROM staff_mapping
GROUP BY staff_roles
ORDER BY staff_count DESC;

-- Preview mapping
SELECT *
FROM staff_mapping
ORDER BY anonymized_name
LIMIT 50;



