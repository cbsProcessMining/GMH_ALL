/*DESCRIPTION:
View for Metadata in Reporting Layer
*/
DROP VIEW IF EXISTS "P2P_/WMD/FP_IVPO";

CREATE VIEW "P2P_/WMD/FP_IVPO" AS 
SELECT DISTINCT 
    P.*,
 	CAST(P.BZDAT AS DATE) AS TS_BLDAT
  from  TMP_P2P_EKKO_EKPO AS E 
        inner join "/WMD/FP_IVPO" as P on 1 = 1
        AND P.MANDT = E.MANDT
        AND P.EBELN = E.EBELN
        AND P.EBELP = E.EBELP;



    