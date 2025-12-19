# Hướng Dẫn Load Dữ Liệu vào Data Warehouse

## Vấn đề: Gold views không có dữ liệu

**Nguyên nhân:** Chưa load dữ liệu vào Bronze và Silver layers.

## Các bước để load dữ liệu:

### Bước 1: Kiểm tra trạng thái dữ liệu hiện tại
Chạy script: `scripts/check_data_status.sql`
- Xem số lượng records trong từng layer
- Xác định layer nào đang trống

### Bước 2: Load dữ liệu vào Bronze Layer (Từ CSV files)
1. Mở file: `scripts/bronze/proc_load_bronze.sql`
2. Chạy toàn bộ script để tạo stored procedure
3. Thực thi stored procedure:
   ```sql
   EXEC bronze.load_bronze;
   ```
4. Kiểm tra kết quả trong Messages tab
5. Nếu có lỗi về đường dẫn file, kiểm tra lại đường dẫn trong script

### Bước 3: Load dữ liệu vào Silver Layer (Từ Bronze)
1. Mở file: `scripts/silver/proc_load_silver.sql`
2. Chạy toàn bộ script để tạo stored procedure
3. Thực thi stored procedure:
   ```sql
   EXEC silver.load_silver;
   ```
4. Kiểm tra kết quả trong Messages tab

### Bước 4: Kiểm tra lại Gold Views
Sau khi load xong Silver, các Gold views sẽ tự động có dữ liệu (vì chúng là views query từ Silver).

Chạy lại:
```sql
SELECT COUNT(*) FROM gold.fact_sales;
SELECT COUNT(*) FROM gold.dim_customers;
SELECT COUNT(*) FROM gold.dim_products;
```

## Lưu ý quan trọng:

1. **Thứ tự thực hiện:** Phải load Bronze trước, sau đó mới load Silver
2. **Đường dẫn file:** Đã được cập nhật trong `proc_load_bronze.sql` theo đường dẫn project của bạn
3. **Quyền truy cập:** SQL Server cần có quyền đọc file CSV từ thư mục datasets
4. **Nếu lỗi BULK INSERT:** Có thể cần cấp quyền cho SQL Server service account để đọc file

## Troubleshooting:

- **Lỗi "Cannot bulk load":** Kiểm tra quyền truy cập file và đường dẫn
- **Lỗi "Invalid column":** Kiểm tra định dạng CSV có đúng không
- **Không có dữ liệu sau khi load:** Chạy `check_data_status.sql` để kiểm tra từng layer




