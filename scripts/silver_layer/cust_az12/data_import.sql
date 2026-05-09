INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)


SELECT 
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END cid,
	CASE 
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END bdate,
	CASE 
		WHEN UPPER(gen) = 'M' THEN  'Male' 
		WHEN UPPER(gen) = 'F' THEN 'Female'
		WHEN UPPER(gen) IS NULL OR TRIM(gen) = '' THEN 'N/A'
		ELSE gen
	END gen
FROM bronze.erp_cust_az12


-- Integration Capability check --
--WHERE CASE
--		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
--		ELSE cid
--	END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)