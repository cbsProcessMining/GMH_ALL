INSERT INTO "_CEL_AP_ACTIVITIES" (
"_CASE_KEY"
,"ACTIVITY_DE"
,"ACTIVITY_EN"
,"EVENTTIME"
,"_SORTING"
,"MANDT"
,"BUKRS"
,"BELNR"
,"GJAHR"
,"BUZEI"
,"TRANSACTION_CODE")
SELECT DISTINCT
    B."_CASE_KEY" AS "_CASE_KEY"
    ,'Lieferant erstellt Rechnung' AS "ACTIVITY_DE"
    ,'Vendor Creates Invoice' AS "ACTIVITY_EN"
    , CAST(B."BLDAT" as DATE) + CAST('00:00:01' AS TIME) AS "EVENTTIME"
    ,10 AS "_SORTING"
    ,B."MANDT" AS "MANDT"
    ,B."BUKRS" AS "BUKRS"
    ,B."BELNR" AS "BELNR"
    ,B."GJAHR" AS "GJAHR"
    ,B."BUZEI" AS "BUZEI"
    ,B."TCODE" AS "TRANSACTION_CODE"
FROM
    "TMP_AP_BKPF_BSEG" AS B
;