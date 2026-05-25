-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 03_create_functions.sql
-- Purpose:
-- Create reusable data cleaning functions
-- =====================================================

USE notary_project;

-- Remove existing function if exists
DROP FUNCTION IF EXISTS convert_to_date;

DELIMITER $$

CREATE FUNCTION convert_to_date(raw_date TEXT)
RETURNS DATE
DETERMINISTIC

BEGIN

    DECLARE cleaned_date TEXT;

    -- Replace Chinese date characters
    SET cleaned_date = REPLACE(raw_date, '年', '-');
    SET cleaned_date = REPLACE(cleaned_date, '月', '-');
    SET cleaned_date = REPLACE(cleaned_date, '日', '');

    -- Return standardized DATE
    RETURN STR_TO_DATE(cleaned_date, '%Y-%m-%d');

END$$

DELIMITER ;

SELECT convert_to_date('2023年8月4日');