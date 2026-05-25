-- =====================================================
-- Project: Notary Case Data Pipeline
-- File: 02_create_tables.sql
-- Purpose:
-- Create core project tables
-- =====================================================
USE notary_project;

-- =====================================================
-- Table: case_records
-- Purpose:
-- Store cleaned case-level records
-- =====================================================

CREATE TABLE case_records (
    
    case_id VARCHAR(100) PRIMARY KEY,
    
    certificate_number VARCHAR(100),
    
    client_name TEXT,
    
    case_type VARCHAR(255),
    
    notary VARCHAR(100),
    
    assistant_name VARCHAR(100),
    
    workflow_status VARCHAR(100),
    
    case_category VARCHAR(100),
    
    notarization_category VARCHAR(100),
    
    usage_country VARCHAR(100),
    
    accept_date DATE,
    
    issue_date DATE,
    
    notary_fee DECIMAL(10,2),
    
    fee_status VARCHAR(50),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- Table: case_parties
-- Purpose:
-- Store party-level information for each case
-- =====================================================

CREATE TABLE case_parties (

    party_id INT AUTO_INCREMENT PRIMARY KEY,

    case_id VARCHAR(100),

    party_name VARCHAR(255),

    id_type VARCHAR(100),

    id_number VARCHAR(255),

    phone_number VARCHAR(100),

    is_primary_party BOOLEAN,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (case_id)
        REFERENCES case_records(case_id)
);

-- =====================================================
-- Table: staff_mapping
-- Purpose:
-- Store anonymized staff identifiers
-- =====================================================

CREATE TABLE staff_mapping (

    staff_id INT AUTO_INCREMENT PRIMARY KEY,

    original_name VARCHAR(100) NOT NULL,

    anonymized_name VARCHAR(100) NOT NULL,

    staff_role VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- Table: fee_standard_rules
-- Purpose:
-- Store standard fee rules by case category
-- =====================================================

CREATE TABLE fee_standard_rules (

    rule_id INT AUTO_INCREMENT PRIMARY KEY,

    notarization_category VARCHAR(100),

    case_type VARCHAR(255),

    standard_fee DECIMAL(10,2),

    rule_description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- Table: notary_metrics
-- Purpose:
-- Store aggregated notary performance metrics
-- =====================================================

CREATE TABLE notary_metrics (

    metric_id INT AUTO_INCREMENT PRIMARY KEY,

    notary VARCHAR(100),

    total_cases INT,

    total_fee DECIMAL(12,2),

    average_fee DECIMAL(10,2),

    overseas_case_count INT,

    domestic_case_count INT,

    inheritance_case_count INT,

    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Check created tables
SHOW TABLES;