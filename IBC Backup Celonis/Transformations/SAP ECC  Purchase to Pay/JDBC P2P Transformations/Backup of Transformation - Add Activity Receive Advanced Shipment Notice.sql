/*DESCRIPTION:
1. Transformation Description:
This transformation creates an activity with the following name: Receive advanced shipment notice ( ASN ) 











2. Required Tables:
EKES
TMP_P2P_EKKO_EKPO

3. Required Columns:
EKES.EBELN
EKES.EBELP
EKES.EBTYP
EKES.ERDAT
EKES.EZEIT
EKES.MANDT
TMP_P2P_EKKO_EKPO.EBELN
TMP_P2P_EKKO_EKPO.EBELP
TMP_P2P_EKKO_EKPO.MANDT
TMP_P2P_EKKO_EKPO._CASE_KEY

4. Columns used for timestamp:
EKES.ERDAT
EKES.EZEIT

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
    ,"_ACTIVITY_KEY") 
SELECT DISTINCT
	E._CASE_KEY AS "_CASE_KEY"
	,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
	,'Erhalte Lieferavis' AS "ACTIVITY_DE"
	,'Receive advanced shipment notice (ASN)' AS "ACTIVITY_EN"
	,CAST(EKES.ERDAT AS DATE) + CAST(EKES.EZEIT AS TIME) AS "EVENTTIME"
	,1700 AS "_SORTING"
    ,EKES.MANDT || EKES.EBELN || EKES.EBELP  AS "_ACTIVITY_KEY"
FROM
	TMP_P2P_EKKO_EKPO AS E
	INNER JOIN EKES AS EKES ON
		 EKES.MANDT = E.MANDT
        AND EKES.EBELN = E.EBELN
        AND EKES.EBELP = E.EBELP
    WHERE EKES.EBTYP LIKE 'L%'
;
