-------------------------------------
-------------------------------------
-- Statement: Create Table: Temporary BKPF BSEG

-- Query No: 1
DROP TABLE IF EXISTS "TMP_AP_BKPF_BSEG";
-- Query No: 2
CREATE TABLE "TMP_AP_BKPF_BSEG" AS(
SELECT DISTINCT
	BKPF."MANDT"
	,BKPF."BUKRS"
	,BKPF."BELNR"
	,BKPF."GJAHR"
	,CAST(BKPF."BLDAT" AS DATE) AS "BLDAT"
	,CAST(BKPF."CPUDT" AS DATE) AS "CPUDT"
	,CAST(BKPF."CPUTM" AS TIME) AS "CPUTM"
	,BKPF."USNAM"
    ,BKPF."AWTYP"
    ,BKPF."XREVERSAL"
	,BSEG."BUZEI"
	,BSEG."BSCHL"
	,CAST(BSEG."AUGDT" AS DATE) AS "AUGDT"
	,BSEG."AUGBL"
	,CAST(BSEG."ZFBDT" AS DATE) AS "ZFBDT"
	,BSEG."ZBD1T"
	,BSEG."ZBD1P"
	,BSEG."ZBD2T"
	,BSEG."ZBD3T"
	,BSEG."DMBTR"
	,BKPF."WAERS"
	,BKPF."BUDAT"
	,BSEG."KUNNR"
	,BSEG."LIFNR"
    ,BSEG."SKFBT"
    ,BSEG."WSKTO"
	,BKPF."KURSF"
	,BSEG."WRBTR"
	,BKPF."MANDT" || BKPF."BUKRS" || BKPF."BELNR" || BKPF."GJAHR" || BSEG."BUZEI" AS "_CASE_KEY"
	,BKPF."MANDT" || BKPF."BUKRS" || BKPF."BELNR" || BKPF."GJAHR" AS "OBJID"
    ,BSEG."SKNTO"
  	,BKPF."TCODE"
  	,BSEG."AUGGJ"
FROM 
    "BKPF" AS BKPF
	JOIN "BSEG" AS BSEG ON
		BKPF."MANDT" = BSEG."MANDT"
		AND BKPF."BUKRS" = BSEG."BUKRS"
		AND BKPF."BELNR" = BSEG."BELNR"
		AND BKPF."GJAHR" = BSEG."GJAHR"
	/*JOIN "TTYP" AS TTYP ON
        BKPF."AWTYP" = TTYP."AWTYP"		*/
WHERE 1=1
    AND BSEG."BSCHL" IN ('31')
);