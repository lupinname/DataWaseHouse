/*
===============================================================================
Sample Queries: View Data from Gold Layer
===============================================================================
Script Purpose:
    This script provides sample queries to view data from the Gold layer views.
    Use these queries to explore and analyze the data warehouse.

Usage:
    - Run individual queries to see data from each view
    - Modify queries to filter or aggregate data as needed
===============================================================================
*/

-- =============================================================================
-- 1. View Customers Dimension (First 100 rows)
-- =============================================================================
SELECT TOP 100
    customer_key,
    customer_id,
    customer_number,
    first_name,
    last_name,
    country,
    marital_status,
    gender,
    birthdate,
    create_date
FROM gold.dim_customers
ORDER BY customer_key;

-- =============================================================================
-- 2. View Products Dimension (First 100 rows)
-- =============================================================================
SELECT TOP 100
    product_key,
    product_id,
    product_number,
    product_name,
    category_id,
    category,
    subcategory,
    maintenance,
    cost,
    product_line,
    start_date
FROM gold.dim_products
ORDER BY product_key;

-- =============================================================================
-- 3. View Sales Fact Table (First 100 rows)
-- =============================================================================
SELECT TOP 100
    order_number,
    product_key,
    customer_key,
    order_date,
    shipping_date,
    due_date,
    sales_amount,
    quantity,
    price
FROM gold.fact_sales
ORDER BY order_date DESC;

-- =============================================================================
-- 4. View All Views in Gold Schema
-- =============================================================================
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold'
    AND TABLE_TYPE = 'VIEW'
ORDER BY TABLE_NAME;

-- =============================================================================
-- 5. View Sales with Customer and Product Details (Sample Join)
-- =============================================================================
SELECT TOP 50
    fs.order_number,
    fs.order_date,
    fs.sales_amount,
    fs.quantity,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.country,
    c.gender,
    p.product_name,
    p.category,
    p.product_line
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c
    ON fs.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
    ON fs.product_key = p.product_key
ORDER BY fs.order_date DESC;

-- =============================================================================
-- 6. Count Records in Each View
-- =============================================================================
SELECT 'dim_customers' AS view_name, COUNT(*) AS record_count FROM gold.dim_customers
UNION ALL
SELECT 'dim_products' AS view_name, COUNT(*) AS record_count FROM gold.dim_products
UNION ALL
SELECT 'fact_sales' AS view_name, COUNT(*) AS record_count FROM gold.fact_sales;




