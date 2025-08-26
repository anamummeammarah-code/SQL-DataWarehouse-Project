/*
=================================
  Create Database and Schemas
=================================
Script Purpose:
  This script creates a new database named 'DataWareHouse' after first checking whether it already exists. 
  If the database does exist, it will be dropped and recreated toensure a clean environment. Once recreated, the script 
  sets up three schemas withinthe database: 'Bronze', 'Silver', and 'Gold'.

WARNING:
  Running this script will completely drop the 'DataWareHouse' database if it already exists. 
  All data contained within the database will be permanently deleted. Proceed with extreme caution and
  make sure you have a valid and verified backup before executing this script.
*/

USE master;
GO

-- 1. Drop database if it exists
IF DB_ID('DataWareHouse') IS NOT NULL
BEGIN
PRINT 'Dropping existing database: DataWareHouse';
ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DataWareHouse;
END
GO


-- 2. Create 'DataWarehouse' database
PRINT 'Creating new database: DataWareHouse';
CREATE DATABASE DataWareHouse;
GO


-- 3. Switch to the new database
USE DataWareHouse;
GO

-- 4. Create schemas
PRINT 'Creating schemas: Bronze, Silver, Gold';
CREATE SCHEMA Bronze;
GO
  
CREATE SCHEMA Silver;
GO
  
CREATE SCHEMA Gold;
GO


PRINT 'DataWareHouse recreated successfully with Bronze, Silver, Gold schemas.';
```
