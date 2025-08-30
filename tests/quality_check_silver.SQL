/*
======================================================================================
Quanlity Checks
======================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accurancy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and Consistency.
    - Invalid data ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
======================================================================================
*/

    -- ===============================================================
    -- Checking 'silver.crm_cust_info'
    -- ===============================================================
    -- Check for NULLS or Duplicates in Primary Key
    -- Expectation: No Results
    SELECT 
        cst_id,
        COUNT(*)
    FROM silver.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1 OR cst_id IS NULL;
    
    -- Check the unwanted Spaces
    -- Expectation: No Results
    SELECT 
        cst_key
    FROM silver.crm_cust_info
    WHERE cst_key != TRIM(cst_key);
    
    -- Data Standardization & Consistency
    SELECT DISTINCT 
        cst_marital_status
    FROM silver.crm_cust_info;
    
    -- ===============================================================
    -- Checking 'silver.crm_prd_info'
    -- ===============================================================
    -- Check for NULLS or Duplicates in Primary Key
    -- Expectation: No Results
    SELECT 
        prd_id,
        COUNT(*)
    FROM silver.crm_prd_info
    GROUP BY prd_id
    HAVING COUNT(*) > 1 OR prd_id IS NULL;
    
    -- Check the unwanted Spaces
    -- Expectation: No Results
    SELECT 
        prd_nm
    FROM silver.crm_prd_info
    WHERE prd_nm != TRIM(prd_nm);
    
    -- Checks the NULLS or Negative Numbers
    -- Expectation: No Results
    SELECT
        prd_cost
    FROM silver.crm_prd_info
    WHERE prd_cost < 0 OR prd_cost IS NULL;
    
    -- Data Standardization & Consistency
    SELECT DISTINCT
        prd_line 
    FROM silver.crm_prd_info;
    
    -- Check for Invalid Date Orders (Start Date > End Date)
    -- Expectation: No Results
    SELECT 
        *
    FROM silver.crm_prd_info
    WHERE prd_end_dt < prd_start_dt;
    
    -- ===============================================================
    -- Checking 'silver.crm_sales_details'
    -- ===============================================================
    -- Check for Invalid Date 
    -- Expectation: No Invalid Dates
    SELECT 
        NULLIF(sls_due_dt,0) AS sls_due_dt
    FROM silver.crm_sales_details 
    WHERE sls_due_dt <= 0 
        OR LEN(sls_due_dt) != 8
        OR sls_due_dt > 20500101
        OR sls_due_dt < 19000101;
    
    -- Check for Invalid Dates Orders (Order Date > Shipping/Due Dates)
    -- Excpectation: No Results
    SELECT 
        *
    FROM silver.crm_sales_details
    WHERE sls_order_dt > sls_ship_dt 
       OR sls_order_dt > sls_due_dt;
    
    -- Checks Data Consistency: Sales = Quantity * Price
    -- Expectation: No Results
    
    SELECT DISTINCT
        sls_sales,
        sls_quantity,
        sls_price
    FROM silver.crm_sales_details
    WHERE sls_sales != sls_quantity * sls_price 
        OR sls_sales IS NULL 
        OR sls_quantity IS NULL 
        OR sls_price IS NULL 
        OR sls_sales <= 0 
        OR sls_quantity <= 0 
        OR sls_price <= 0 
    ORDER BY sls_sales, sls_quantity, sls_price;
    
    SELECT * FROM silver.crm_sales_details
    
    -- ===============================================================
    -- Checking 'silver.erp_CUST_AZ12'
    -- ===============================================================
    -- Normalization Check
    SELECT 
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(cid))
         ELSE cid
    END AS 
        cid,
        bdate,
        gen
    FROM silver.erp_CUST_AZ12;
    
    --Identify Out-Of-Range Dates
    -- Expectation: Birthdates between 1924-01-01 and Today
    SELECT 
        bdate 
    FROM silver.erp_CUST_AZ12
    WHERE bdate < '1924-01-01' 
       OR bdate > GETDATE();
    
    -- Data Standarization & Consistency
    SELECT DISTINCT
        gen
    FROM silver.erp_CUST_AZ12
    
    -- ===============================================================
    -- Checking 'silver.erp_LOC_A101'
    -- ===============================================================
    -- Normalization Check
    SELECT 
        REPLACE(cid, '-' , '') AS cid,
        cntry
    FROM silver.erp_LOC_A101
    
    --Date standarization & Consistency
    SELECT DISTINCT
        cntry
    FROM silver.erp_LOC_A101
    ORDER BY cntry
    
    -- ===============================================================
    -- Checking 'silver.erp_PX_CAT_G1V2'
    -- ===============================================================
    -- Check the unwanted Spaces
    -- Expectation: No Results
    SELECT 
        *
    FROM silver.erp_PX_CAT_G1V2
    WHERE cat != TRIM(cat)
       OR subcat != TRIM(subcat)
       OR maintenance != TRIM(maintenance);
    
    -- Data standarization & Consistency
    SELECT DISTINCT 
        maintenance 
    FROM silver.erp_PX_CAT_G1V2
    
    
    
    
