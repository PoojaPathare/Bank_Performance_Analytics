DROP PROCEDURE IF EXISTS  dbo.Get_FY_KPI_YoY;


-----------------------------------------------------------------------------------------
-- Procedure Name: dbo.YoY_Calculation
-- Business Goal:  Generates Changes over year & Performance Report. 
--                 Calculates Banking KPIs profitability metrics including are Net Interest Margin (NIM),
--                 (ROA), (ROE).
-- Author:         [Pooja Pathare]
-- Parameter :     @Fiscal_year - Defaults to the latest available data.
-----------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.Get_FY_KPI_YoY
    @Fiscal_Year NVARCHAR(9) = NULL 
AS
BEGIN
    SET NOCOUNT ON;

 
    -- Default Fiscal Year = latest in table
   
    IF @Fiscal_Year IS NULL
    BEGIN
        SELECT TOP 1 @Fiscal_Year = Fiscal_Year
        FROM Date$
        ORDER BY Fiscal_Year DESC;
    END

   
    -- CTEs for KPI Calculation
 
    ;WITH FY_BASE AS (
        SELECT
            D.Fiscal_Year,
            F.Branch_Name,

            SUM(F.NII) AS Total_NII,
            SUM(F.PAT) AS Total_PAT,

            AVG(F.Avg_earning_assets) AS Total_Avg_Earning_Assets,
            AVG(F.Avg_Total_Asset)    AS Total_Avg_Total_Asset,
            AVG(F.Avg_Equity)         AS Total_Avg_Equity
        FROM Performance$ F
        JOIN Date$ D
            ON F.Date_Key = D.Date_Key
        GROUP BY
            D.Fiscal_Year,
            F.Branch_Name
    ),

    BRANCH_KPI AS (
        SELECT
            Fiscal_Year,
            Branch_Name,
            'BRANCH' AS Level_Type,

            Total_NII,
            Total_PAT,

            Total_NII / NULLIF(Total_Avg_Earning_Assets, 0) AS NIM,
            Total_PAT / NULLIF(Total_Avg_Total_Asset, 0)    AS ROA,
            Total_PAT / NULLIF(Total_Avg_Equity, 0)         AS ROE
        FROM FY_BASE
    ),

    BANK_KPI AS (
        SELECT
            Fiscal_Year,
            'ALL_BRANCHES' AS Branch_Name,
            'BANK' AS Level_Type,

            SUM(Total_NII) AS Total_NII,
            SUM(Total_PAT) AS Total_PAT,

            SUM(Total_NII) / NULLIF(SUM(Total_Avg_Earning_Assets), 0) AS NIM,
            SUM(Total_PAT) / NULLIF(SUM(Total_Avg_Total_Asset), 0)    AS ROA,
            SUM(Total_PAT) / NULLIF(SUM(Total_Avg_Equity), 0)         AS ROE
        FROM FY_BASE
        GROUP BY Fiscal_Year
    ),

    ALL_KPI AS (
        SELECT * FROM BRANCH_KPI
        UNION ALL
        SELECT * FROM BANK_KPI
    ),

    YoY AS (
        SELECT
            C.Fiscal_Year,
            C.Level_Type,
            C.Branch_Name,

            C.Total_NII,
            C.Total_PAT,

            C.NIM*100 AS NIM,
            C.ROA*100 AS ROA,
            C.ROE*100 AS ROE,

            ROUND((C.NIM - P.NIM) * 10000, 2) AS NIM_YoY_Bps,
            ROUND((C.ROA - P.ROA) * 10000, 2) AS ROA_YoY_Bps,
            ROUND((C.ROE - P.ROE) * 10000, 2) AS ROE_YoY_Bps
        FROM ALL_KPI C
        LEFT JOIN ALL_KPI P
            ON C.Branch_Name = P.Branch_Name
           AND C.Level_Type = P.Level_Type
           AND P.Fiscal_Year = CONCAT(
                CAST(LEFT(C.Fiscal_Year,4) AS INT) - 1,
                '-',
                LEFT(C.Fiscal_Year,4)
           )
    )

    
    -- Final Result

    SELECT
        Fiscal_Year,
        Level_Type,
        Branch_Name,

        Total_NII,
        Total_PAT,

        NIM,
        ROA,
        ROE,

        NIM_YoY_Bps,
        ROA_YoY_Bps,
        ROE_YoY_Bps
    FROM YoY
    WHERE Fiscal_Year = @Fiscal_Year
    ORDER BY
        Level_Type ,   
        Branch_Name;
END;
GO

EXEC  dbo.Get_FY_KPI_YoY
