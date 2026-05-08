IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL         
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_product_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

INSERT INTO silver.crm_sales_details (
	
	sls_ord_num,
	sls_product_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)

--================CLEANED DATA===================--
SELECT 
	sls_ord_num,
	sls_product_key,
	sls_cust_id,
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
	END sls_order_dt,
	CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) sls_ship_dt,
	CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) sls_due_dt,

	CASE 
        WHEN NULLIF(sls_quantity, 0) IS NOT NULL AND NULLIF(sls_price, 0) IS NOT NULL 
            THEN ABS(sls_quantity) * ABS(sls_price)
        ELSE NULLIF(ABS(sls_sales), 0) -- Returns NULL if sales is 0, negative, or NULL
    END AS sls_sales,

    CASE 
        -- If Quantity is missing/invalid, calculate it: Sales / Price
        WHEN (sls_quantity IS NULL OR sls_quantity <= 0) 
             AND NULLIF(sls_price, 0) IS NOT NULL 
             AND NULLIF(sls_sales, 0) IS NOT NULL
            THEN ABS(sls_sales) / ABS(sls_price)
        ELSE NULLIF(ABS(sls_quantity), 0)
    END AS sls_quantity,

    CASE 
        -- If Price is missing/invalid, calculate it: Sales / Quantity
        WHEN (sls_price IS NULL OR sls_price <= 0) 
             AND NULLIF(sls_quantity, 0) IS NOT NULL 
             AND NULLIF(sls_sales, 0) IS NOT NULL
            THEN ABS(sls_sales) / ABS(sls_quantity)
        ELSE NULLIF(ABS(sls_price), 0)
    END AS sls_price
FROM bronze.crm_sales_details
--================CLEANED DATA===================--



SELECT *
FROM silver.crm_sales_details



