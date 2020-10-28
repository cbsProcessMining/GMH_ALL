/*DESCRIPTION:
View for Metadata in Reporting Layer
*/
DROP VIEW IF EXISTS "P2P_/WMD/FP_IFIVH";
CREATE VIEW "P2P_/WMD/FP_IFIVH" AS 
SELECT DISTINCT 
    "IFIVH".*,
 	CAST(IFIVH.BLDAT AS DATE) AS TS_BLDAT, 
    CAST(IFIVH.BUDAT AS DATE) AS TS_BUDAT,
    cast(IFIVH.ZFBDT as Date) as TS_ZFBDT,
    cast(IFIVH.SCANDATE as Date) as TS_SCANDATE,
    P.EBELN as "EBELN", 
    P.EBELP as "EBELP" 
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
    and H."RECNO" = IFIVH.RECNO;

    