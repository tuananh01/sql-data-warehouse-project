IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL         
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	cat_id NVARCHAR(50),
	product_key_sales NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);


INSERT INTO silver.crm_prd_info (
	prd_id,
	prd_key,
	cat_id,
	product_key_sales,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') cat_id,    --Product category
	SUBSTRING(prd_key, 7, LEN(prd_key))  prd_key_sales, 
	prd_nm,
	ISNULL(prd_cost, 0) prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'   
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'N/A'
	END prd_line,
	CAST(prd_start_dt AS DATE) prd_start_dt,
	CAST(LEAD(prd_start_dt - 1, 1) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE) prd_end_dt  
FROM bronze.crm_prd_info
