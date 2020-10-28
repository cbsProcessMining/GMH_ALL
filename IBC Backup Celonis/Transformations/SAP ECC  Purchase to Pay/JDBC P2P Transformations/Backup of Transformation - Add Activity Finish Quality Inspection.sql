/*DESCRIPTION:
1. Transformation Description:
This transformation creates an activity with the following name: Finish Quality Inspection















2. Required Tables:
QALS
TMP_P2P_EKKO_EKPO
USR02

3. Required Columns:
QALS.EBELN
QALS.EBELP
QALS.ERSTELLER
QALS.MANDANT
QALS.NOW
QALS.PAENDTERM
QALS.PAENDZEIT
TMP_P2P_EKKO_EKPO.EBELN
TMP_P2P_EKKO_EKPO.EBELP
TMP_P2P_EKKO_EKPO.MANDT
TMP_P2P_EKKO_EKPO._CASE_KEY
USR02.BNAME
USR02.MANDT
USR02.USTYP

4. Columns used for timestamp:
QALS.PAENDTERM
QALS.PAENDZEIT

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
    , "_ACTIVITY_KEY") 
SELECT DISTINCT 
	E._CASE_KEY AS "_CASE_KEY"
	,E.MANDT AS "MANDT"
	,E.EBELN AS "EBELN"
	,E.EBELP AS "EBELP"
	,'Qualitätsprüfung Ende' AS "ACTIVITY_DE"
	,'Finish Quality Inspection' AS "ACTIVITY_EN"
	,CAST(QALS.PAENDTERM AS DATE) + CAST(QALS.PAENDZEIT AS TIME) AS "EVENTTIME"
	,2100 AS "_SORTING"
	,QALS.ERSTELLER AS "USER_NAME"
	,USR02.USTYP AS "USER_TYPE"
	,NOW() AS "_CELONIS_CHANGE_DATE"
    , QALS.MANDANT || QALS.PRUEFLOS AS "_ACTIVITY_KEY"
FROM
	TMP_P2P_EKKO_EKPO AS E
	JOIN QALS as QALS on 1=1
		AND QALS.EBELN = E.EBELN
		AND QALS.EBELP = E.EBELP
		AND QALS.MANDANT = E.MANDT
	LEFT JOIN USR02 AS USR02 ON 1=1
		AND QALS.MANDANT = USR02.MANDT
		AND QALS.ERSTELLER = USR02.BNAME;