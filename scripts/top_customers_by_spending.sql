/*
===============================================================================
Analytics Query: Top 10 Khách Hàng Chi Tiêu Nhiều Nhất
===============================================================================
Script Purpose:
    Truy vấn này tìm top 10 khách hàng có tổng chi tiêu cao nhất
    dựa trên dữ liệu từ Gold layer (fact_sales và dim_customers).

Usage:
    - Chạy truy vấn này để xem top 10 khách hàng chi tiêu nhiều nhất
    - Kết quả bao gồm thông tin khách hàng và tổng chi tiêu
===============================================================================
*/

USE DataWarehouse;
GO

-- =============================================================================
-- Top 10 Khách Hàng Chi Tiêu Nhiều Nhất
-- =============================================================================
SELECT TOP 10
    c.customer_key,
    c.customer_id,
    c.customer_number,
    c.first_name + ' ' + c.last_name AS full_name,
    c.country,
    c.marital_status,
    c.gender,
    COUNT(DISTINCT fs.order_number) AS total_orders,
    SUM(fs.quantity) AS total_quantity,
    SUM(fs.sales_amount) AS total_spending,
    AVG(fs.sales_amount) AS avg_order_value,
    MIN(fs.order_date) AS first_order_date,
    MAX(fs.order_date) AS last_order_date
FROM gold.fact_sales fs
INNER JOIN gold.dim_customers c
    ON fs.customer_key = c.customer_key
WHERE fs.sales_amount IS NOT NULL
GROUP BY 
    c.customer_key,
    c.customer_id,
    c.customer_number,
    c.first_name,
    c.last_name,
    c.country,
    c.marital_status,
    c.gender
ORDER BY total_spending DESC;
GO

-- =============================================================================
-- Alternative Query: Chỉ hiển thị thông tin cơ bản và tổng chi tiêu
-- =============================================================================
/*
SELECT TOP 10
    c.customer_number,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.country,
    SUM(fs.sales_amount) AS total_spending
FROM gold.fact_sales fs
INNER JOIN gold.dim_customers c
    ON fs.customer_key = c.customer_key
WHERE fs.sales_amount IS NOT NULL
GROUP BY 
    c.customer_number,
    c.first_name,
    c.last_name,
    c.country
ORDER BY total_spending DESC;
*/
GO

