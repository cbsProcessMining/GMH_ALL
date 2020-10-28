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
	,"_CELONIS_CHANGE_DATE")
SELECT DISTINCT 
	E._CASE_KEY AS "_CASE_KEY"
	,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
	,'Ende Rechnungsfreigabe EASY' AS "ACTIVITY_DE"
	,'End Invoice Release EASY' AS "ACTIVITY_EN"
	,cast(CDHDR_POS.UDATE as date) + cast(CDHDR_POS.UTIME as time) AS "EVENTTIME"
	,2340 AS "_SORTING"
	,CDHDR_POS.USERNAME AS "USER_NAME"
	,NOW() AS "_CELONIS_CHANGE_DATE"
from  TMP_P2P_EKKO_EKPO AS E 
inner join "/WMD/FP_IVPO" as P on 1 = 1
        AND P.MANDT = E.MANDT
        AND P.EBELN = E.EBELN
        AND P.EBELP = E.EBELP
INNER JOIN "/WMD/FP_IVHD" AS H ON 1=1
    and H.MANDT = P.MANDT 
    and H."RECNO" = P.RECNO
inner join "/WMD/FP_IFIVH" as IFIVH on 1 = 1
    and H.MANDT = IFIVH.MANDT 
    and H."RECNO" = IFIVH.RECNO
    inner join CDPOS as CDPOS on 1 = 1
        and H.MANDT || H.APPL || H.RECNO = "CDPOS"."TABKEY"
        and CDPOS.TABNAME = '/WMD/FP_IVHD'
        and CDPOS.FNAME = 'STATEX'
        and CDPOS.VALUE_NEW in ('ZF','BE')
  inner JOIN CDHDR AS CDHDR_POS ON 1=1
	    AND CDPOS.MANDANT = CDHDR_POS.MANDANT
	    AND CDPOS.CHANGENR = CDHDR_POS.CHANGENR
inner join CDPOS as N_CDPOS on 1 = 1
         and H.MANDT || H.APPL || H.RECNO = "N_CDPOS"."TABKEY"
        and N_CDPOS.TABNAME = '/WMD/FP_IVHD'
        and N_CDPOS.FNAME = 'STATP'
         and N_CDPOS.VALUE_NEW = 'W';

-- NOT IN (Start Freigabe, --> dort, wo Freigabe nicht gestartet wurde auch keine Ende der Freigabe) 
-- Add Activity: Start Invoice Release EASY
/*
inner join CDPOS as CDPOS on 1 = 1
         and H.MANDT || H.APPL || H.RECNO = "CDPOS"."TABKEY"
        and CDPOS.TABNAME = '/WMD/FP_IVHD'
        and CDPOS.FNAME = 'STATP'
         and CDPOS.VALUE_NEW = 'W'
*/
    /*
old 
from  RSEG AS RSEG
    INNER JOIN TMP_P2P_EKKO_EKPO AS E ON 1=1
        AND RSEG.MANDT = E.MANDT
        AND RSEG.EBELN = E.EBELN
        AND RSEG.EBELP = E.EBELP
    INNER JOIN TMP_P2P_BKPF_BSEG AS B ON 1=1
        AND B.MANDT = RSEG.MANDT
        AND SUBSTRING(B.AWKEY,1,14) = RSEG.BELNR || CAST(RSEG.GJAHR AS VARCHAR(4))
    inner join "/WMD/FP_IVPO" as P on 1 = 1
        AND P.MANDT = E.MANDT
        AND P.EBELN = E.EBELN
        AND P.EBELP = E.EBELP    
    INNER JOIN "/WMD/FP_IVHD" AS H ON 1=1
        AND H.MANDT = RSEG.MANDT
        AND  RSEG.BELNR  = H."BELNR_FI"
    inner join CDPOS as CDPOS on 1 = 1
        and H.MANDT || H.APPL || H.RECNO = "CDPOS"."TABKEY"
        and CDPOS.TABNAME = '/WMD/FP_IVHD'
        and CDPOS.FNAME = 'STATEX'
        and CDPOS.VALUE_NEW in ('ZF','BE')
  inner JOIN CDHDR AS CDHDR_POS ON 1=1
	    AND CDPOS.MANDANT = CDHDR_POS.MANDANT
	    AND CDPOS.CHANGENR = CDHDR_POS.CHANGENR;


    */