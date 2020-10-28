/*DESCRIPTION:
1. Transformation Description:
This transformation creates a view with the following name: P2P_EKES

















2. Required Tables:
EKES
_CEL_P2P_CASES

3. Required Columns:
EKES.*
EKES.EBELN
EKES.EBELP
EKES.EINDT
EKES.ERDAT
EKES.MANDT
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
DROP VIEW IF EXISTS P2P_EKES;

CREATE VIEW P2P_EKES AS 
SELECT DISTINCT 
    EKES.*,
    CAST(EKES.EINDT AS DATE) AS TS_EINDT, 
    CAST(EKES.ERDAT AS DATE) AS TS_ERDAT
FROM 
    EKES
    INNER JOIN _CEL_P2P_CASES AS CASES ON 1=1
        AND EKES.MANDT = CASES.MANDT
        AND EKES.EBELN = CASES.EBELN
        AND EKES.EBELP = CASES.EBELP
;