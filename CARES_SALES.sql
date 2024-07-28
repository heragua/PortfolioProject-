-- cleaning data in sql 
 
select * from CARES_SALES ; 
 
 --Exploring popular property data on PRICE_IN_THOUSANDS.
 
SELECT * 
FROM CARES_SALES 
WHERE PRICE_IN_THOUSANDS IS NULL;

--Update Null Prices with Average Price in CARES_SALES"

UPDATE CARES_SALES 
SET PRICE_IN_THOUSANDS = (
    SELECT AVG(PRICE_IN_THOUSANDS)
    FROM CARES_SALES
    WHERE PRICE_IN_THOUSANDS IS NOT NULL
)
WHERE PRICE_IN_THOUSANDS IS NULL;


-- Delete unused column 
ALTER TABLE CARES_SALES
DROP COLUMN DDD;

ALTER TABLE CARES_SALES
DROP COLUMN ENGINE_SIZE;

ALTER TABLE CARES_SALES
DROP COLUMN POWER_PERF_FACTOR;

select *from CARES_SALES; 

--RENAME DE LA COLONNE LATEST_LAUNCH

ALTER TABLE CARES_SALES
RENAME COLUMN LATEST_LAUNCH TO "DATE";

select * from CARES_SALES;

--séparation de type date 

ALTER TABLE CARES_SALES
ADD (YEAR NUMBER,
     MONTH NUMBER, 
     DAY NUMBER); 
 
--Split DATE into Year, Month, and Day Columns and Drop Original DATE Column in CARES_SALES     
UPDATE CARES_SALES 
SET YEAR = EXTRACT(YEAR FROM "DATE"),
    MONTH =EXTRACT (MONTH FROM "DATE"),
    DAY =EXTRACT (DAY FROM "DATE");
    
ALTER TABLE CARES_SALES
DROP column "DATE"; 

select *from CARES_SALES ;

--Select Records with Null Curb Weight from CARES_SALES
select curb_weight from CARES_SALES 
WHERE curb_weight  is null ; 


-- Count Sales by Manufacturer with Distinct Manufacturers from CARES_SALES

SELECT distinct(MANUFACTURER), count(SALES_IN_THOUSANDS) 
from CARES_SALES 
GROUP BY MANUFACTURER;

--Classify Manufacturers as 'Yes' or 'No' in CARES_SALES
SELECT MANUFACTURER
, CASE when MANUFACTURER ='I' THEN 'yes'
       when MANUFACTURER ='A' THEN 'NO'
       ELSE MANUFACTURER
       END 
FROM CARES_SALES;

-- Standardize Manufacturer Values and Select All Records from CARES_SALES
Update CARES_SALES
SET MANUFACTURER = CASE When MANUFACTURER = 'Y' THEN 'Yes'
	   When MANUFACTURER = 'N' THEN 'No'
	   ELSE MANUFACTURER
	   END;

select*from CARES_SALES

 
