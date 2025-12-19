/*
===============================================================================
DDL Script: Create Additional Gold Views (Date & Region Dimensions, Regional Fact)
===============================================================================
Script Purpose:
    This script creates additional views in the 'gold' schema:
        - gold.dim_date              : Date dimension based on sales order dates
        - gold.dim_region            : Region (country-level) dimension
        - gold.fact_sales_region_daily : Aggregated daily sales by region

Usage:
    - Run this script after loading the Silver layer and creating the base Gold views.
    - Views can be queried directly for analytics and reporting.
===============================================================================
*/

USE DataWarehouse;
GO

-- =============================================================================
-- Create Dimension: gold.dim_date
-- =============================================================================
IF OBJECT_ID('gold.dim_date', 'V') IS NOT NULL
    DROP VIEW gold.dim_date;
GO

CREATE VIEW gold.dim_date AS
SELECT
    ROW_NUMBER() OVER (ORDER BY dt)     AS date_key,      -- Surrogate key
    dt                                  AS full_date,
    CAST(FORMAT(dt, 'yyyyMMdd') AS INT) AS yyyymmdd,
    YEAR(dt)                            AS year,
    MONTH(dt)                           AS month,
    DAY(dt)                             AS day,
    DATEPART(quarter, dt)               AS quarter,
    DATENAME(weekday, dt)               AS weekday_name,
    DATEPART(weekday, dt)               AS weekday_number
FROM (
    SELECT DISTINCT
        sd.sls_order_dt AS dt
    FROM silver.crm_sales_details sd
    WHERE sd.sls_order_dt IS NOT NULL
) d;
GO

-- =============================================================================
-- Create Dimension: gold.dim_region
--   Grain: One row per country available in ERP location data
-- =============================================================================
IF OBJECT_ID('gold.dim_region', 'V') IS NOT NULL
    DROP VIEW gold.dim_region;
GO

CREATE VIEW gold.dim_region AS
SELECT
    ROW_NUMBER() OVER (ORDER BY country) AS region_key,   -- Surrogate key
    country,
    -- Optional grouping of countries into higher-level sales regions
    CASE 
        WHEN country = 'United States' THEN 'North America'
        WHEN country IN ('France', 'Germany', 'United Kingdom') THEN 'Europe'
        WHEN country = 'Australia' THEN 'Oceania'
        ELSE 'Other'
    END AS sales_region
FROM (
    SELECT DISTINCT
        cntry AS country
    FROM silver.erp_loc_a101
    WHERE cntry IS NOT NULL
      AND cntry <> 'n/a'
) x;
GO

-- =============================================================================
-- Create Fact View: gold.fact_sales_region_daily
--   Grain: One row per (order_date, country)
-- =============================================================================
IF OBJECT_ID('gold.fact_sales_region_daily', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales_region_daily;
GO

CREATE VIEW gold.fact_sales_region_daily AS
SELECT
    dd.date_key,
    dr.region_key,
    dd.full_date          AS order_date,
    dr.country,
    dr.sales_region,
    COUNT(DISTINCT fs.order_number) AS order_count,
    SUM(fs.quantity)                AS total_quantity,
    SUM(fs.sales_amount)            AS total_sales_amount,
    AVG(fs.sales_amount)            AS avg_order_value
FROM gold.fact_sales fs
INNER JOIN gold.dim_customers c
    ON fs.customer_key = c.customer_key
INNER JOIN gold.dim_date dd
    ON fs.order_date = dd.full_date
INNER JOIN gold.dim_region dr
    ON c.country = dr.country
WHERE fs.sales_amount IS NOT NULL
GROUP BY
    dd.date_key,
    dr.region_key,
    dd.full_date,
    dr.country,
    dr.sales_region;
GO


