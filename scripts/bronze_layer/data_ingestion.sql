EXEC bronze.load_bronze


/* ===========================================
    Importing Data from .csv files into Tables
==============================================*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	SET @start_time = GETDATE();                      -- Calculate whole batch duration
    BEGIN TRY
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT 'Loading cust_info.csv'
		BULK INSERT bronze.crm_cust_info 
		FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' 
		WITH (
			FIRSTROW = 2,             -- Specify the first row of useful data
			FIELDTERMINATOR = ',',    -- Data is saparated by comma (,) inside the file
			TABLOCK                   -- Lock the entire table for fast importing
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

		
		/* Check for correct import */
		--SELECT * FROM bronze.crm_cust_info
		--SELECT COUNT(*) FROM bronze.crm_cust_info

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT 'Loading prd_info.csv';
		BULK INSERT bronze.crm_prd_info
		FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' 
		WITH (
			FIRSTROW = 2,            
			FIELDTERMINATOR = ',',    
			TABLOCK                   
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT 'Loading sales_details.csv'
		BULK INSERT bronze.crm_sales_details
		FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' 
		WITH (
			FIRSTROW = 2,            
			FIELDTERMINATOR = ',',    
			TABLOCK                   
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT 'Loading CUST_AZ12.csv'
		BULK INSERT bronze.erp_cust_az12
		FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv' 
		WITH (
			FIRSTROW = 2,            
			FIELDTERMINATOR = ',',    
			TABLOCK                   
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT 'Loading LOC_A101.csv';
		BULK INSERT bronze.erp_loc_a101
		FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv' 
		WITH (
			FIRSTROW = 2,            
			FIELDTERMINATOR = ',',    
			TABLOCK                   
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT 'Loading PX_CAT_G1V2.csv';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv' 
		WITH (
			FIRSTROW = 2,            
			FIELDTERMINATOR = ',',    
			TABLOCK
		
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 
		
		SET @end_time = GETDATE();
		PRINT '>> Finishing Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

	
	END TRY
	 
	BEGIN CATCH 
		PRINT '=========================================';
		PRINT 'Error Occured During Loading Bronze Layer';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================';
	END CATCH 
	
END

