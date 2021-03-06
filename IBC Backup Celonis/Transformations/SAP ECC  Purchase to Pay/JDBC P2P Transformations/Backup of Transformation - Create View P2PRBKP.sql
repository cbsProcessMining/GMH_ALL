/*DESCRIPTION:
1. Transformation Description:
This transformation creates a view with the following name: P2P_RBKP

















2. Required Tables:
RBKP
RSEG
_CEL_P2P_CASES

3. Required Columns:
RBKP.*
RBKP.BELNR
RBKP.GJAHR
RBKP.MANDT
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
DROP VIEW IF EXISTS P2P_RBKP;

CREATE VIEW P2P_RBKP AS
SELECT DISTINCT 
	RBKP.*,
    CAST(RBKP.BLDAT AS DATE) AS TS_BLDAT,
    CAST(RBKP.BUDAT AS DATE) AS TS_BUDAT,
    CAST(RBKP.CPUDT AS DATE) AS TS_CPUDT,
    CAST(RBKP.ZFBDT AS DATE) AS TS_ZFBDT,
    CAST(RBKP.VATDATE AS DATE) AS TS_VATDATE,
    CAST(RBKP.REINDAT AS DATE) AS TS_REINDAT,
    CAST(RBKP.FDTAG AS DATE) AS TS_FDTAG,
    CAST(RBKP.ASSIGN_NEXT_DATE AS DATE) AS TS_ASSIGN_NEXT_DATE,
    CAST(RBKP.ASSIGN_END_DATE AS DATE) AS TS_ASSIGN_END_DATE,
    CAST(RBKP.WWERT AS DATE) AS TS_WWERT
    ,RBKP.BELNR || CAST(RBKP.GJAHR AS VARCHAR(4)) AS BKPFKEY -- to join with FI (BKPF)
FROM 
    RBKP
    INNER JOIN RSEG AS RSEG ON 1=1
        AND RSEG.MANDT = RBKP.MANDT
        AND RSEG.BELNR = RBKP.BELNR
        AND RSEG.GJAHR = RBKP.GJAHR
    INNER JOIN _CEL_P2P_CASES AS CASES ON 1=1
        AND RSEG.MANDT = CASES.MANDT
        AND RSEG.EBELN = CASES.EBELN
        AND RSEG.EBELP = CASES.EBELP
;