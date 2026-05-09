INSERT INTO silver.erp_loc_a101 (
	cid,
	country
)
-------------Cleaned Data----------------
SELECT 
	REPLACE(cid,'-','') cid, 
	CASE 
		WHEN UPPER(country) IN ('USA', 'US') THEN 'United States'
		WHEN UPPER(country) = 'DE' THEN 'Germany'
		WHEN country IS NULL OR TRIM(country) = '' THEN 'N/A' 
		ELSE country
	END AS country
FROM bronze.erp_loc_a101

-------------Cleaned Data----------------

--WHERE REPLACE(cid,'-','') NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)