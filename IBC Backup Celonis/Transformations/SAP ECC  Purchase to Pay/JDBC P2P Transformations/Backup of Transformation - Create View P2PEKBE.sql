/*DESCRIPTION:
1. Transformation Description:
This transformation creates a view with the following name: P2P_EKBE

















2. Required Tables:
EKBE
_CEL_P2P_CASES

3. Required Columns:
EKBE.*
EKBE.BLDAT
EKBE.BUDAT
EKBE.CPUDT
EKBE.EBELN
EKBE.EBELP
EKBE.MANDT
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
DROP VIEW IF EXISTS P2P_EKBE;

CREATE VIEW P2P_EKBE AS (
SELECT DISTINCT 
    EKBE.*,
    CAST(EKBE.BLDAT AS DATE) AS TS_BLDAT,
    CAST(EKBE.BUDAT AS DATE) AS TS_BUDAT,
    CAST(EKBE.CPUDT AS DATE) AS TS_CPUDT,
    CAST(EKBE.CPUTM AS DATETIME) AS TS_CPUTM
FROM 
    EKBE
    INNER JOIN _CEL_P2P_CASES AS CASES ON 1=1
        AND EKBE.MANDT = CASES.MANDT
        AND EKBE.EBELN = CASES.EBELN
        AND EKBE.EBELP = CASES.EBELP
);


