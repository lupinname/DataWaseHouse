/*
===============================================================================
Analytics Query: Top 10 Sản Phẩm Bán Chạy
===============================================================================
Script Purpose:
    Truy vấn này tìm top 10 sản phẩm bán chạy nhất
    dựa trên dữ liệu từ Gold layer (fact_sales và dim_products).
    Sản phẩm được xếp hạng theo tổng số lượng bán (quantity).

Usage:
    - Chạy truy vấn này để xem top 10 sản phẩm bán chạy nhất
    - Kết quả bao gồm thông tin sản phẩm và các metrics bán hàng
===============================================================================
*/

USE DataWarehouse;
GO

-- =============================================================================
-- Top 10 Sản Phẩm Bán Chạy (Theo Số Lượng)
-- =============================================================================
SELECT TOP 10
    p.product_key,
    p.product_id,
    p.product_number,
    p.product_name,
    p.category,
    p.subcategory,
    p.product_line,
    p.cost AS product_cost,
    COUNT(DISTINCT fs.order_number) AS total_orders,
    SUM(fs.quantity) AS total_quantity_sold,
    SUM(fs.sales_amount) AS total_revenue,
    AVG(fs.price) AS avg_selling_price,
    AVG(fs.quantity) AS avg_quantity_per_order,
    MIN(fs.order_date) AS first_sale_date,
    MAX(fs.order_date) AS last_sale_date
FROM gold.fact_sales fs
INNER JOIN gold.dim_products p
    ON fs.product_key = p.product_key
WHERE fs.quantity IS NOT NULL 
    AND fs.quantity > 0
GROUP BY 
    p.product_key,
    p.product_id,
    p.product_number,
    p.product_name,
    p.category,
    p.subcategory,
    p.product_line,
    p.cost
ORDER BY total_quantity_sold DESC;
GO

-- =============================================================================
-- Alternative Query 1: Top 10 Sản Phẩm Theo Doanh Thu
-- =============================================================================
/*
SELECT TOP 10
    p.product_number,
    p.product_name,
    p.category,
    p.subcategory,
    SUM(fs.quantity) AS total_quantity_sold,
    SUM(fs.sales_amount) AS total_revenue,
    COUNT(DISTINCT fs.order_number) AS total_orders
FROM gold.fact_sales fs
INNER JOIN gold.dim_products p
    ON fs.product_key = p.product_key
WHERE fs.sales_amount IS NOT NULL
GROUP BY 
    p.product_number,
    p.product_name,
    p.category,
    p.subcategory
ORDER BY total_revenue DESC;
*/
GO

-- =============================================================================
-- Alternative Query 2: Top 10 Sản Phẩm Theo Số Đơn Hàng
-- =============================================================================
/*
SELECT TOP 10
    p.product_number,
    p.product_name,
    p.category,
    SUM(fs.quantity) AS total_quantity_sold,
    SUM(fs.sales_amount) AS total_revenue,
    COUNT(DISTINCT fs.order_number) AS total_orders
FROM gold.fact_sales fs
INNER JOIN gold.dim_products p
    ON fs.product_key = p.product_key
WHERE fs.order_number IS NOT NULL
GROUP BY 
    p.product_number,
    p.product_name,
    p.category
ORDER BY total_orders DESC;
*/
GO

