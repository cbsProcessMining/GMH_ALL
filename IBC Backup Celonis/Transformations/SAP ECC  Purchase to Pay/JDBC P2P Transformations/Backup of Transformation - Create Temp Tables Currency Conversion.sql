/*DESCRIPTION:
#########################
  S T A T E M E N T  1:
#########################
#########################

1. Transformation Description:
This transformation creates a temporary table with the following name: TCURF_TMP



1. Transformation Description:
This transformation creates a temporary table with the following name: TCURF_TMP

2. Required Tables:
TCURF

3. Required Columns:
TCURF.FCURR
TCURF.GDATU
TCURF.KURST
TCURF.MANDT
TCURF.TCURR

4. Columns used for timestamp:
None

5. Parameters used in where clause:
None

6. Parameters used in joins:
None

#########################
  S T A T E M E N T  2:
#########################

1. Transformation Description:
This transformation creates a table with the following name: TCURF_CC

2. Required Tables:
TCURF_TMP

3. Required Columns:
None

4. Columns used for timestamp:
None

5. Parameters used in where clause:
None

6. Parameters used in joins:
None

#########################
  S T A T E M E N T

WARNING: DESCRIPTION TOO LONG AND WAS CUT OFF!
*/
-- Query No: 1
DROP TABLE IF EXISTS "TCURF_CC";
-- Query No: 2
DROP TABLE IF EXISTS "TCURF_TMP";
-- Query No: 3
CREATE TABLE "TCURF_TMP" AS(
	SELECT DISTINCT
    *
	,CAST(NULL AS TIMESTAMP) AS "VALID_START"
	,CAST(NULL AS TIMESTAMP) AS "VALID_END"
	,DENSE_RANK() OVER (ORDER BY 
		TCURF."MANDT"
		,TCURF."KURST"
		,TCURF."FCURR"
		,TCURF."TCURR"
		) AS "TCURF_KEY"
	,ROW_NUMBER() OVER (PARTITION BY 
		TCURF."MANDT"
		,TCURF."KURST"
		,TCURF."FCURR"
		,TCURF."TCURR"
		ORDER BY (99999999-CAST(TCURF."GDATU" AS INT)) ASC) AS "TCURF_ROWNR"
FROM 
	"TCURF" as TCURF
WHERE 1=1 
	AND (99999999-cast(TCURF."GDATU" as int)) >= 18000000
    AND (99999999-cast(TCURF."GDATU" as int)) <= 20990000
);
-- Query No: 4
CREATE TABLE "TCURF_CC" AS(
SELECT 
	*
FROM 
	"TCURF_TMP");
-- Query No: 5
UPDATE 
	"TCURF_CC"
SET 
	"VALID_START" = CAST(LPAD(CAST((99999999-CAST("GDATU" AS INT)) AS VARCHAR(10)),8,'0') || ' ' || '00:00:00' AS TIMESTAMP);
-- Query No: 6
UPDATE 
	"TCURF_CC" AS TCURF_CC
SET 
	"VALID_END" = CAST(LPAD(CAST((99999999-CAST(TCURF_TMP."GDATU" AS INT)) AS VARCHAR(10)),8,'0') || ' ' || '00:00:00' AS TIMESTAMP) 
FROM 
	"TCURF_TMP" AS TCURF_TMP 
WHERE 1=1
	AND TCURF_CC."TCURF_KEY" = TCURF_TMP."TCURF_KEY" 
	AND	TCURF_CC."TCURF_ROWNR" + 1 = TCURF_TMP."TCURF_ROWNR";
-- Query No: 7
UPDATE 
	"TCURF_CC" 
SET 
	"VALID_END" = '2099-01-01' 
WHERE 
	"VALID_END" is null;
-- Query No: 8
DROP TABLE IF EXISTS "TCURF_TMP";

-------------------------------------
-------------------------------------
-- Statement: Database Preparation: Create Table: TCURR_CC

-- Query No: 1
DROP TABLE IF EXISTS "TCURR_CC";
-- Query No: 2
DROP TABLE IF EXISTS "TCURR_TMP";

-- Query No: 3
CREATE TABLE "TCURR_TMP" AS(
SELECT 
    TCURR."MANDT"
    ,TCURR."KURST"
    ,TCURR."FCURR"
    ,TCURR."TCURR"
    ,TCURR."GDATU"
    ,TCURR."UKURS"
    ,TCURR."FFACT"
    ,TCURR."TFACT"
	,CAST(NULL AS TIMESTAMP) AS "VALID_START"
	,CAST(NULL AS TIMESTAMP) AS "VALID_END"
	,DENSE_RANK() OVER (ORDER BY 
		TCURR."MANDT"
		,TCURR."KURST"
		,TCURR."FCURR"
		,TCURR."TCURR"
		) AS "TCURR_KEY"
	,ROW_NUMBER() OVER (PARTITION BY 
		TCURR."MANDT"
		,TCURR."KURST"
		,TCURR."FCURR"
		,TCURR."TCURR"
		ORDER BY (99999999-CAST(TCURR."GDATU" AS INT)) ASC) AS "TCURR_ROWNR"
FROM 
	"TCURR" AS TCURR
WHERE 1=1 
	AND (99999999-CAST(TCURR."GDATU" AS INT)) >= 18000000
    AND (99999999-CAST(TCURR."GDATU" AS INT)) <= 20990000
);


-- Query No: 4
CREATE TABLE "TCURR_CC" AS(
SELECT 
	* 
FROM 
	"TCURR_TMP"
);
-- Query No: 5
UPDATE 
	"TCURR_CC" AS TCURR_CC
SET 
	"VALID_START" = CAST(LPAD(CAST((99999999-cast(TCURR_CC."GDATU" AS INT)) AS VARCHAR(10)),8,'0') || ' ' || '00:00:00' AS TIMESTAMP)
;
-- Query No: 6
UPDATE 
	"TCURR_CC"  AS TCURR_CC
SET 
	"VALID_END" = CAST(LPAD(CAST((99999999-CAST(TCURR_TMP."GDATU" AS INT)) AS VARCHAR(10)),8,'0') || ' ' || '00:00:00' AS timestamp) 
FROM 
	"TCURR_TMP" AS TCURR_TMP
WHERE 1=1
	AND TCURR_CC."TCURR_KEY" = TCURR_TMP."TCURR_KEY"  
	AND TCURR_CC."TCURR_ROWNR" + 1=TCURR_TMP."TCURR_ROWNR"
;
-- Query No: 7
UPDATE 
	"TCURR_CC" AS TCURR_CC
SET 
	"VALID_END" = '2099-01-01' 
WHERE 
	"VALID_END" is null
;

-- Query No: 8
DROP TABLE IF EXISTS "TCURR_TMP";