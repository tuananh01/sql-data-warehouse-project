/*========== Import Cleaned data into Siver table ============= */

INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)

------------Cleaned Data-------------
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'   
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'N/A'
END cst_marital_status,
CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'   
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'N/A'
END cst_gndr,
cst_create_date

FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t 
WHERE flag_last = 1
------------Cleaned Data-------------

