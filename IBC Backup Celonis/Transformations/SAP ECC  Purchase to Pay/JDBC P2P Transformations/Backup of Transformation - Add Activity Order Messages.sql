/*DESCRIPTION:
1. Transformation Description:
This transformation creates the following activities: Send Overdue Notice, Send Purchase Order Update, Dun Order Confirmation, Send Purchase Order

















2. Required Tables:
DD07T
NAST
T685T
TMP_P2P_EKKO_EKPO
USR02

3. Required Columns:
DD07T.DDLANGUAGE
DD07T.DOMNAME
DD07T.DOMVALUE_L
DD07T.MESSAGETYPES
NAST.AENDE
NAST.DATVR
NAST.KAPPL
NAST.KSCHL
NAST.MANDT
NAST.NACHA
NAST.OBJKY
NAST.SPRAS
NAST.TCODE
NAST.UHRVR
NAST.USNAM
T685T.KAPPL
T685T.KSCHL
T685T.KVEWE
T685T.MANDT
T685T.SPRAS
...
Contact App Store support for the complete list.

4. Columns used for timestamp:
NAST.DATVR
NAST.UHRVR

5. Parameters used in where clause:
MessageTypes

6. Parameters used in joins:
primaryLanguageKey
*/
INSERT INTO _CEL_P2P_ACTIVITIES (
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
    ,"_ACTIVITY_KEY"
    ,"CHANGED_TABLE")

SELECT DISTINCT
	E._CASE_KEY AS "_CASE_KEY"
	,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
	,CASE WHEN NAST.KAPPL ='EF' AND NAST.KSCHL IN <%=messageTypes%> and NAST.KSCHL not in ('MAHN','AUFB')  THEN 'Sende Bestellung'  
        WHEN NAST.KAPPL ='EF' AND NAST.KSCHL IN <%=messageTypes%> and NAST.KSCHL not in ('MAHN','AUFB') AND NAST.AENDE = 'X' THEN 'Sende Bestelländerung'
		WHEN NAST.KAPPL LIKE 'EF' AND NAST.KSCHL = 'MAHN' THEN 'Sende Mahnung'
		WHEN NAST.KAPPL = 'EF' AND NAST.KSCHL = 'AUFB' THEN 'Mahne Auftragsbestätigung'
        ELSE 'Sende Nachricht: ' || T685T.VTEXT
	END AS "ACTIVITY_DE"
	,CASE WHEN  NAST.KAPPL ='EF' AND NAST.KSCHL IN <%=messageTypes%> and NAST.KSCHL not in ('MAHN','AUFB')  THEN 'Send Purchase Order' 
        WHEN NAST.KAPPL ='EF' AND NAST.KSCHL in <%=messageTypes%> and NAST.KSCHL not in ('MAHN','AUFB') AND NAST.AENDE = 'X' THEN 'Send Purchase Order Update' 
		WHEN NAST.KAPPL LIKE 'EF' AND NAST.KSCHL = 'MAHN' THEN 'Send Overdue Notice'
		WHEN NAST.KAPPL = 'EF' AND NAST.KSCHL = 'AUFB' THEN 'Dun Order Confirmation'
        ELSE 'Send Message: ' || T685T.VTEXT
	END AS "ACTIVITY_EN"
	, CAST(NAST.DATVR AS DATE) + CAST(NAST.UHRVR AS TIME)  AS "EVENTTIME"
	,CASE 
	    WHEN NAST.KAPPL ='EF' AND NAST.KSCHL IN <%=messageTypes%> and NAST.KSCHL not in ('MAHN','AUFB')  THEN 1310
        WHEN NAST.KAPPL ='EF' AND NAST.KSCHL IN <%=messageTypes%> and NAST.KSCHL not in ('MAHN','AUFB') AND NAST.AENDE = 'X' THEN 1320 
		WHEN NAST.KAPPL LIKE 'EF' AND NAST.KSCHL = 'MAHN' THEN 1330
		WHEN NAST.KAPPL = 'EF' AND NAST.KSCHL = 'AUFB' THEN 1340
        ELSE 1350
	END AS "_SORTING"
	,NAST.USNAM AS "USER_NAME"
	,USR02.USTYP AS "USER_TYPE"
    ,NULL AS "TRANSACTION_CODE"
    ,NAST.MANDT || NAST.KAPPL|| NAST.OBJKY || NAST.KSCHL|| NAST.PARNR AS "_ACTIVITY_KEY"
    ,CASE WHEN E.BSART = 'ZP4T' THEN '6' ELSE NAST.NACHA END AS NACHA
FROM 
    NAST AS NAST
    INNER JOIN TMP_P2P_EKKO_EKPO AS E ON 
    	NAST.MANDT = E.MANDT AND
    	NAST.OBJKY = E.EBELN
    LEFT JOIN USR02 AS USR02 ON
		NAST.MANDT = USR02.MANDT AND
		NAST.USNAM = USR02.BNAME
    LEFT JOIN T685T AS T685T ON
		T685T.MANDT = NAST.MANDT AND
		T685T.SPRAS = NAST.SPRAS AND
		T685T.KAPPL = NAST.KAPPL AND
		T685T.KSCHL = NAST.KSCHL AND
		T685T.KVEWE = 'B'
WHERE	
	coalesce(NAST.DATVR,'') <> '' AND
	NAST.KAPPL = 'EF' AND
	NAST.KSCHL IN <%=messageTypes%> AND 
    NAST.VSTAT = '1' -- 0 & 2 sind fehlerhaft und/oder gar nicht verarbeitet worden
    
;