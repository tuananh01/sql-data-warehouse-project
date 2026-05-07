/*===================================
	     Data Quality Check
=====================================*/

-- Check for duplicates & NULL value in the Primary KEY

SELECT 
	cst_id,
	COUNT(*) duplicate_check     
--FROM bronze.crm_cust_info
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for any whitespaces
SELECT 
 cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
 cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

--So on for other columns--

--Data Standardization & Consistency
SELECT cst_gndr,
	CASE 
		WHEN cst_gndr = 'M' THEN 'Male'     --Normalize Data into useful, user-friendly data
		WHEN cst_gndr = 'F' THEN 'Female'
	END AS cst_gndr
FROM bronze.crm_cust_info

-- Check any NULL in the table
SELECT *
FROM #test_bronze_crm_cust_info 
WHERE cst_id IS NULL
OR cst_key IS NULL
OR cst_firstname IS NULL
OR cst_lastname IS NULL
OR cst_marital_status IS NULL
OR cst_gndr IS NULL
OR cst_create_date IS NULL

-- Return a list of Columns in the Table
SELECT COLUMN_NAME + ','
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'crm_cust_info'
  AND TABLE_SCHEMA = 'bronze';



/*======== Cleansing Data =========*/

-- Remove NULL in cst_id and retrieve the latest entry 

SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,         -- Remove whitespaces
TRIM(cst_lastname) AS cst_lastname,
CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'    -- Normalize Data
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'N/A'
END cst_marital_status,
CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'   
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'N/A'
END cst_gndr,
cst_create_date

-- Remove NULL in cst_id and retrieve the latest entry 
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t 
WHERE flag_last = 1

