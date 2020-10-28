/*DESCRIPTION:















2. Required Tables:
QALS
QAVE
TMP_P2P_EKKO_EKPO
USR02

3. Required Columns:
QALS.EBELN
QALS.EBELP
QALS.MANDANT
QALS.NOW
QALS.PRUEFLOS
QAVE.MANDANT
QAVE.PRUEFLOS
QAVE.VBEWERTUNG
QAVE.VDATUM
QAVE.VEZEITERF
QAVE.VNAME
TMP_P2P_EKKO_EKPO.EBELN
TMP_P2P_EKKO_EKPO.EBELP
TMP_P2P_EKKO_EKPO.MANDT
TMP_P2P_EKKO_EKPO._CASE_KEY
USR02.BNAME
USR02.MANDT
USR02.USTYP

4. Columns used for timestamp:
QAVE.VDATUM
QAVE.VEZEITERF

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
	,"_CELONIS_CHANGE_DATE"
    ,"_ACTIVITY_KEY") 
SELECT DISTINCT 
	E._CASE_KEY AS "_CASE_KEY"
	,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
	,'Starte SAP Anfrage' AS "ACTIVITY_DE"
    ,'Quality: Accepted' AS "ACTIVITY_EN"
	,CAST(E.AEDAT AS DATE) + CAST('00:00:01' AS TIME) AS "EVENTTIME"
	,2200 AS "_SORTING"
	,Q.VNAME AS "USER_NAME"
	,USR02.USTYP AS "USER_TYPE"
	,NOW() AS "_CELONIS_CHANGE_DATE"
 FROM
	TMP_P2P_EKKO_EKPO AS E

    where E.BSTYP = 'A';


-- Auch kein Bezug
Select * from TMP_P2P_EKKO_EKPO as "E"
inner join "EKKO" on
E.MANDT = "EKKO".MANDT 
AND E.KONNR = "EKKO".EBELN
 where EKKO.BSTYP = 'A'

--Analyse
--kein Objekt im System
/*Select CAST(E.AEDAT AS DATE) + CAST('00:00:01' AS TIME) AS "EVENTTIME"from 
	TMP_P2P_EKKO_EKPO AS E 
    where E.BSTYP = 'A' -> Fehler gefunden, da in der TMP_P2P_EKKO hart auf F gefilter wird. 
*/


-- Auch kein Objekt vorhanden, das einen Bezug mit BSTYP = 'A' hatte  
/*
Select *
FROM TMP_P2P_EKKO_EKPO AS E
INNER JOIN EKPO AS EKPO_CONTRACT ON 1=1
	AND E.MANDT = EKPO_CONTRACT.MANDT 
	AND E.KONNR = EKPO_CONTRACT.EBELN
	AND E.KTPNR = EKPO_CONTRACT.EBELP
INNER JOIN EKKO AS EKKO_CONTRACT ON 1=1
	AND EKPO_CONTRACT.MANDT = EKKO_CONTRACT.MANDT 
	AND EKPO_CONTRACT.EBELN = EKKO_CONTRACT.EBELN
    AND EKKO_CONTRACT.BSTYP='A'

LEFT JOIN CDPOS AS CDPOS_HEAD ON 1=1
	AND CDPOS_HEAD.TABKEY = EKKO_CONTRACT.MANDT || EKKO_CONTRACT.EBELN 
	AND CDPOS_HEAD.TABNAME = 'EKKO' 
	--AND CDPOS_HEAD.CHNGIND = 'I' 
	--AND CDPOS_HEAD.FNAME = 'KEY'
LEFT JOIN CDHDR AS CDHDR_HEAD ON 1=1
	AND CDPOS_HEAD.MANDANT = CDHDR_HEAD.MANDANT
	AND CDPOS_HEAD.CHANGENR = CDHDR_HEAD.CHANGENR
LEFT JOIN USR02 AS USR02_HEAD ON 1=1
	AND CDHDR_HEAD.MANDANT = USR02_HEAD.MANDT
	AND CDHDR_HEAD.USERNAME = USR02_HEAD.BNAME;

    */