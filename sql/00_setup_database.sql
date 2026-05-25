-- Project: Notary Case Data Pipeline
-- File: 00_setup_database.sql
-- Purpose:
-- Create project database and initialize environment

-- Create database
CREATE DATABASE IF NOT EXISTS notary_project;

-- Use database
USE notary_project;

-- Optional: check current database
SELECT DATABASE();

-- Optional: set SQL mode
SET sql_mode = 'STRICT_TRANS_TABLES';

-- Optional: set timezone
SET time_zone = '+00:00';

-- Show existing tables
SHOW TABLES;