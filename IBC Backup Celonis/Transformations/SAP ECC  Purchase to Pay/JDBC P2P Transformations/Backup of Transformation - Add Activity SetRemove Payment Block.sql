/*DESCRIPTION:
1. Transformation Description:
This transformation creates the following activities: Set Payment Block, Remove Payment Block

















2. Required Tables:
CDHDR
CDPOS
RSEG
TMP_P2P_BKPF_BSEG
TMP_P2P_EKKO_EKPO
USR02

3. Required Columns:
CDHDR.CHANGENR
CDHDR.MANDANT
CDHDR.TCODE
CDHDR.UDATE
CDHDR.USERNAME
CDHDR.UTIME
CDPOS.CHANGENR
CDPOS.FNAME
CDPOS.MANDANT
CDPOS.TABKEY
CDPOS.TABNAME
CDPOS.VALUE_NEW
CDPOS.VALUE_OLD
RSEG.BELNR
RSEG.EBELN
RSEG.EBELP
RSEG.GJAHR
RSEG.MANDT
TMP_P2P_BKPF_BSEG.AWKEY
TMP_P2P_BKPF_BSEG.MANDT
...
Contact App Store support for the complete list.

4. Columns used for timestamp:
CDHDR.UDATE
CDHDR.UTIME

5. Parameters used in where clause:
None

6. Parameters used in joins:
None
*/
INSERT INTO _CEL_P2P_ACTIVITIES(
    "_CASE_KEY"
    ,"MANDT"
	,"EBELN"
	,"EBELP"
    ,"ACTIVITY_DE"
    ,"ACTIVITY_EN"
    ,"EVENTTIME"
    ,"_SORTING"
    ,"USER_NAME"
    ,"USER_TYPE"
    ,"CHANGED_TABLE"
    ,"CHANGED_FIELD"
    ,"CHANGED_FROM"
    ,"CHANGED_TO"
    ,"CHANGE_NUMBER"
    ,"TRANSACTION_CODE"
    ,"_ACTIVITY_KEY") 
SELECT DISTINCT 
    E."_CASE_KEY" AS "_CASE_KEY" 
    ,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
    ,CASE
        WHEN coalesce(CDPOS.VALUE_NEW,'') = '' THEN 'Entferne Zahlsperre'
        WHEN coalesce(CDPOS.VALUE_OLD,'') = '' THEN 'Setze Zahlsperre'
    END AS "ACTIVITY_DE"
    ,CASE
        WHEN coalesce(CDPOS.VALUE_NEW,'') = '' THEN 'Remove Payment Block'
        WHEN coalesce(CDPOS.VALUE_OLD,'') = '' THEN 'Set Payment Block'
    END AS "ACTIVITY_EN"
    ,CAST(CDHDR.UDATE AS DATE) + CAST(CDHDR.UTIME AS TIME) AS "EVENTTIME"
    ,CASE
        WHEN coalesce(CDPOS.VALUE_NEW,'') = ''THEN 2410
        WHEN coalesce(CDPOS.VALUE_OLD,'') = ''THEN 2420
    END AS _SORTING
    ,CDHDR.USERNAME AS "USER_NAME"
    ,USR02.USTYP AS "USER_TYPE"
    ,CDPOS.TABNAME AS "CHANGED_TABLE"
    ,CDPOS.FNAME AS "CHANGED_FIELD"
    ,CDPOS.VALUE_OLD AS "CHANGED_FROM"
    ,CDPOS.VALUE_NEW AS "CHANGED_TO"
    ,CDPOS.CHANGENR AS "CHANGE_NUMBER"
    ,CDHDR.TCODE AS "TRANSACTION_CODE"
    ,CDHDR."MANDANT" || CDHDR."OBJECTCLAS" || CDHDR."OBJECTID" || CDHDR."CHANGENR" AS "_ACTIVITY_KEY"
FROM 
	RSEG AS RSEG
	INNER JOIN TMP_P2P_EKKO_EKPO AS E ON 1=1
	    AND RSEG.MANDT = E.MANDT
	    AND RSEG.EBELN = E.EBELN
	    AND RSEG.EBELP = E.EBELP
    LEFT JOIN TMP_P2P_BKPF_BSEG AS B ON 1=1
        AND RSEG.MANDT = B.MANDT
        AND SUBSTRING(B.AWKEY,1,14) = RSEG.BELNR || CAST(RSEG.GJAHR AS VARCHAR(4))
    JOIN CDPOS AS CDPOS ON 1=1
        AND CDPOS.MANDANT = B.MANDT 
        AND CAST(SUBSTRING(CDPOS.TABKEY,4,4) AS CHAR(4)) = CAST(B.BUKRS AS CHAR(4)) -- This is necessary in case BUKRS only has three digits but requires further validation. 
        AND SUBSTRING(CDPOS.TABKEY,8,10) = B.BELNR
        AND SUBSTRING(CDPOS.TABKEY,18,4) = B.GJAHR
        AND SUBSTRING(CDPOS.TABKEY,22,3) = B.BUZEI
    JOIN CDHDR AS CDHDR ON 1=1
        AND CDPOS.MANDANT = CDHDR.MANDANT
        AND CDPOS.CHANGENR = CDHDR.CHANGENR
    LEFT JOIN USR02 AS USR02 ON 1=1
        AND CDHDR.MANDANT = USR02.MANDT
        AND CDHDR.USERNAME = USR02.BNAME
WHERE 1=1
    AND CDPOS.FNAME = 'ZLSPR'
    AND CDPOS.TABNAME = 'BSEG'
    AND (coalesce(CDPOS.VALUE_OLD,'') = '' OR coalesce(CDPOS.VALUE_NEW,'') = '')
;
