------------------------------------------------------
--- 1. Handling Data Types (String to Date)
------------------------------------------------------


-- Standardize month format and alter column to DATE

SELECT *
FROM Internal_Bank_Data..Fact_Performance$;

SELECT CONVERT(DATE, Date_Key,112)
FROM Internal_Bank_Data..Fact_Performance$;

SELECT CONVERT(date, CAST(CAST(DATE_KEY AS int) AS char(8)), 112) AS Converted_Date
FROM Internal_Bank_Data..Fact_Performance$;

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ADD Date AS
    CONVERT(date, CAST(CAST(FLOOR(DATE_KEY) AS int) AS char(8)), 112) PERSISTED;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Fact_Performance$';


ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN PAT DECIMAL(18,4);


ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN Interest_Expense DECIMAL(18,4);

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN Interest_Income DECIMAL(18,4);

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN NII DECIMAL(18,4);

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN Avg_earning_assets DECIMAL(18,4);

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN Avg_Equity DECIMAL(18,4);

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN Avg_Total_Asset DECIMAL(18,4);

ALTER TABLE Internal_Bank_Data..Fact_Performance$
ALTER COLUMN Provisions DECIMAL(18,4);


------------------------------------------------------
--- 2. Handling NULLs 
------------------------------------------------------

SELECT SUM( CASE WHEN PAT IS NULL THEN 1 ELSE 0 END ) AS NULLS_PAT,
       SUM( CASE WHEN Interest_Income IS NULL THEN 1 ELSE 0 END ) AS NULLS_Interest_Income,
       SUM( CASE WHEN Interest_Expense IS NULL THEN 1 ELSE 0 END ) AS NULLS_Interest_Expense,
       SUM( CASE WHEN NII IS NULL THEN 1 ELSE 0 END ) AS NULLS_NII,
       SUM( CASE WHEN Avg_earning_assets IS NULL THEN 1 ELSE 0 END ) AS NULLS_Avg_earning_assets,
       SUM( CASE WHEN Avg_Equity IS NULL THEN 1 ELSE 0 END ) AS NULLS_Avg_Equity,
       SUM( CASE WHEN Avg_Total_Asset IS NULL THEN 1 ELSE 0 END ) AS NULLS_Avg_Total_Asset,
       SUM( CASE WHEN Provisions IS NULL THEN 1 ELSE 0 END ) AS NULLS_Provisions
FROM Internal_Bank_Data..Fact_Performance$;

UPDATE Internal_Bank_Data..Fact_Performance$
SET 
    NII = ISNULL(NII, 0),
    Provisions = ISNULL(Provisions, 0)
WHERE
    NII IS NULL
   OR Provisions IS NULL;

------------------------------------------------------
--- 3. Removing Duplicates
------------------------------------------------------

 SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Branch_Name, [Date] ORDER BY (SELECT NULL)) AS rn
    FROM Internal_Bank_Data..Fact_Performance$;

WITH CTE_Performance AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Branch_Name, [Date]  ORDER BY (SELECT NULL)) AS rn
    FROM Internal_Bank_Data..Fact_Performance$
)
DELETE FROM CTE_Performance
WHERE rn > 1;


WITH CTE_Date AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Date_key, Month, Year, Fiscal_year  ORDER BY (SELECT NULL)) AS rn
    FROM Internal_Bank_Data..Fact_Performance$
)
DELETE FROM CTE_Date
WHERE rn > 1;


WITH CTE_Branch AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY branch_name, region  ORDER BY (SELECT NULL)) AS rn
    FROM Internal_Bank_Data..Fact_Performance$
)
DELETE FROM CTE_Branch
WHERE rn > 1;

------------------------------------------------------
--- 4. Text standerdization
------------------------------------------------------

UPDATE Internal_Bank_Data..Fact_Performance$
SET Branch_NAME = LTRIM(RTRIM(Branch_Name));