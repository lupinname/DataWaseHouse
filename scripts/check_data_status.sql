/*
===============================================================================
Check Data Status in All Layers
===============================================================================
Script Purpose:
    This script checks if data exists in Bronze, Silver, and Gold layers.
    Use this to diagnose why Gold views are empty.

Usage:
    Run this script to see the data count in each layer.
===============================================================================
*/

-- =============================================================================
-- Check Bronze Layer (Raw Data)
-- =============================================================================
PRINT '================================================';
PRINT 'BRONZE LAYER - Raw Data from CSV Files';
PRINT '================================================';

SELECT 'bronze.crm_cust_info' AS table_name, COUNT(*) AS record_count FROM bronze.crm_cust_info
UNION ALL
SELECT 'bronze.crm_prd_info', COUNT(*) FROM bronze.crm_prd_info
UNION ALL
SELECT 'bronze.crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
UNION ALL
SELECT 'bronze.erp_loc_a101', COUNT(*) FROM bronze.erp_loc_a101
UNION ALL
SELECT 'bronze.erp_cust_az12', COUNT(*) FROM bronze.erp_cust_az12
UNION ALL
SELECT 'bronze.erp_px_cat_g1v2', COUNT(*) FROM bronze.erp_px_cat_g1v2;

-- =============================================================================
-- Check Silver Layer (Cleansed Data)
-- =============================================================================
PRINT '';
PRINT '================================================';
PRINT 'SILVER LAYER - Cleansed and Transformed Data';
PRINT '================================================';

SELECT 'silver.crm_cust_info' AS table_name, COUNT(*) AS record_count FROM silver.crm_cust_info
UNION ALL
SELECT 'silver.crm_prd_info', COUNT(*) FROM silver.crm_prd_info
UNION ALL
SELECT 'silver.crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL
SELECT 'silver.erp_loc_a101', COUNT(*) FROM silver.erp_loc_a101
UNION ALL
SELECT 'silver.erp_cust_az12', COUNT(*) FROM silver.erp_cust_az12
UNION ALL
SELECT 'silver.erp_px_cat_g1v2', COUNT(*) FROM silver.erp_px_cat_g1v2;

-- =============================================================================
-- Check Gold Layer (Analytical Views)
-- =============================================================================
PRINT '';
PRINT '================================================';
PRINT 'GOLD LAYER - Analytical Views';
PRINT '================================================';

SELECT 'gold.dim_customers' AS view_name, COUNT(*) AS record_count FROM gold.dim_customers
UNION ALL
SELECT 'gold.dim_products', COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'gold.fact_sales', COUNT(*) FROM gold.fact_sales;

-- =============================================================================
-- Summary
-- =============================================================================
PRINT '';
PRINT '================================================';
PRINT 'SUMMARY';
PRINT '================================================';
PRINT 'If Bronze = 0: Need to run EXEC bronze.load_bronze;';
PRINT 'If Silver = 0: Need to run EXEC silver.load_silver;';
PRINT 'If Gold = 0 but Silver > 0: Check view definitions';
PRINT '================================================';




