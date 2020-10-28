/*DESCRIPTION:
1. Transformation Description:
This transformation creates an activity with the following name: Create Purchase Order Item

















2. Required Tables:
CDHDR
CDHDR
CDPOS
CDPOS
TMP_P2P_EKKO_EKPO
USR02
USR02

3. Required Columns:
CDHDR.CHANGENR
CDHDR.MANDANT
CDHDR.TCODE
CDHDR.UDATE
CDHDR.USERNAME
CDHDR.UTIME
CDPOS.CHANGENR
CDPOS.CHNGIND
CDPOS.FNAME
CDPOS.MANDANT
CDPOS.TABKEY
CDPOS.TABNAME
TMP_P2P_EKKO_EKPO.AEDAT
TMP_P2P_EKKO_EKPO.EBELN
TMP_P2P_EKKO_EKPO.EBELP
TMP_P2P_EKKO_EKPO.ERNAM
TMP_P2P_EKKO_EKPO.MANDT
TMP_P2P_EKKO_EKPO.TABKEY_EKKO
TMP_P2P_EKKO_EKPO._CASE_KEY
USR02.BNAME
...
Contact App Store support for the complete list.

4. Columns used for timestamp:
CDHDR.UDATE
CDHDR.UTIME
TMP_P2P_EKKO_EKPO.AEDAT

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
	,"TRANSACTION_CODE"
    ,"_ACTIVITY_KEY") 
SELECT DISTINCT 
    E._CASE_KEY AS "_CASE_KEY"
    ,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
    ,'Lege Bestellposition an' AS "ACTIVITY_DE"
    ,'Create Purchase Order Item' AS "ACTIVITY_EN"
    ,CASE
        WHEN coalesce(CDHDR_POS.UDATE,'') <> ''THEN CAST(CDHDR_POS.UDATE AS DATE) + CAST(CDHDR_POS.UTIME AS TIME)
        WHEN coalesce(CDHDR_HEAD.UDATE,'') <> '' THEN CAST(CDHDR_HEAD.UDATE AS DATE) + CAST(CDHDR_HEAD.UTIME AS TIME)
        ELSE CAST(E.AEDAT AS DATE) + CAST('00:00:01' AS TIME)
    END AS "EVENTTIME"
    ,500 AS "_SORTING"
    ,COALESCE(CDHDR_POS.USERNAME, CDHDR_HEAD.USERNAME, E.ERNAM) AS "USER_NAME"
    ,CASE
        WHEN coalesce(CDHDR_POS.USERNAME,'')<> '' THEN USR02_POS.USTYP
        WHEN coalesce(CDHDR_HEAD.USERNAME,'')<> '' THEN USR02_HEAD.USTYP
        ELSE USR02_EKKO.USTYP
    END AS "USER_TYPE"
    ,CDHDR_POS.TCODE AS "TRANSACTION_CODE"
    ,E.MANDT || E.EBELN || E.EBELP  AS "_ACTIVITY_KEY"
FROM
    TMP_P2P_EKKO_EKPO AS E
	LEFT JOIN CDPOS AS CDPOS_POS ON 1=1
		AND CDPOS_POS.TABKEY = E."_CASE_KEY" 
		AND CDPOS_POS.TABNAME = 'EKPO' 
		AND CDPOS_POS.CHNGIND = 'I' 
		AND CDPOS_POS.FNAME = 'KEY'
	LEFT JOIN CDHDR AS CDHDR_POS ON 1=1
	    AND CDPOS_POS.MANDANT = CDHDR_POS.MANDANT
	    AND CDPOS_POS.CHANGENR = CDHDR_POS.CHANGENR
	LEFT JOIN CDPOS AS CDPOS_HEAD ON 1=1
		AND CDPOS_HEAD.TABKEY = E."TABKEY_EKKO"
		AND CDPOS_HEAD.TABNAME = 'EKKO' 
		AND CDPOS_HEAD.CHNGIND = 'I' 
		AND CDPOS_HEAD.FNAME = 'KEY'
	LEFT JOIN CDHDR AS CDHDR_HEAD ON 1=1
	    AND CDPOS_HEAD.MANDANT = CDHDR_HEAD.MANDANT
	    AND CDPOS_HEAD.CHANGENR = CDHDR_HEAD.CHANGENR
	LEFT JOIN USR02  AS USR02_POS ON 1=1
		AND CDHDR_POS.MANDANT = USR02_POS.MANDT
		AND CDHDR_POS.USERNAME = USR02_POS.BNAME
	LEFT JOIN USR02  AS USR02_HEAD ON 1=1
		AND CDHDR_HEAD.MANDANT = USR02_HEAD.MANDT
		AND CDHDR_HEAD.USERNAME = USR02_HEAD.BNAME
    LEFT JOIN "USR02" AS USR02_EKKO On 1=1
        AND USR02_EKKO.MANDT = E.MANDT
        AND USR02_EKKO.BNAME = E.ERNAM
;
