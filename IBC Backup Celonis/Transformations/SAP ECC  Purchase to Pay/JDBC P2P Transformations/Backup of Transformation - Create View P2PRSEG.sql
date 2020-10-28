/*DESCRIPTION:
1. Transformation Description:
This transformation creates a view with the following name: P2P_RSEG

















2. Required Tables:
RSEG
_CEL_P2P_CASES

3. Required Columns:
RSEG.*
RSEG.BELNR
RSEG.EBELN
RSEG.EBELP
RSEG.GJAHR
RSEG.MANDT
_CEL_P2P_CASES.EBELN
_CEL_P2P_CASES.EBELP
_CEL_P2P_CASES.MANDT

4. Columns used for timestamp:
None

5. Parameters used in where clause:
None

6. Parameters used in joins:
None
*/
DROP VIEW IF EXISTS P2P_RSEG;

CREATE VIEW P2P_RSEG AS
SELECT DISTINCT 
	RSEG.*,
    CAST(RSEG.RETDUEDT AS DATE) AS TS_RETDUEDT
FROM 
    RSEG
    INNER JOIN _CEL_P2P_CASES AS CASES ON 1=1
        AND RSEG.MANDT = CASES.MANDT
        AND RSEG.EBELN = CASES.EBELN
        AND RSEG.EBELP = CASES.EBELP
;