/*DESCRIPTION:
1. Transformation Description:
This transformation creates a view with the following name: P2P_BKPF















2. Required Tables:
BKPF
RSEG
_CEL_P2P_CASES

3. Required Columns:
BKPF.*
BKPF.AEDAT
BKPF.AWKEY
BKPF.BLDAT
BKPF.BUDAT
BKPF.CPUDT
BKPF.CPUTM
BKPF.INTDATE
BKPF.MANDT
BKPF.OFFSET_REFER_DAT
BKPF.PSOBT
BKPF.PSODT
BKPF.PSOTM
BKPF.REINDAT
BKPF.STODT
BKPF.UPDDT
BKPF.VATDATE
BKPF.WWERT
RSEG.BELNR
RSEG.EBELN
...
Contact App Store support for the complete list.

4. Columns used for timestamp:
None

5. Parameters used in where clause:
None

6. Parameters used in joins:
None
*/
DROP VIEW IF EXISTS P2P_BKPF;

CREATE VIEW P2P_BKPF AS 
SELECT DISTINCT 
    BKPF.*,
    CAST(BKPF.BLDAT AS DATE) AS TS_BLDAT, 
    CAST(BKPF.BUDAT AS DATE) AS TS_BUDAT, 
    CAST(BKPF.CPUDT AS DATE) AS TS_CPUDT,
    CAST(BKPF.CPUDT AS DATE) + CAST(BKPF.CPUTM AS TIME) AS TS_CPUDT_CPUTM,
    CAST(BKPF.AEDAT AS DATE) AS TS_AEDAT, 
    CAST(BKPF.UPDDT AS DATE) AS TS_UPDDT, 
    CAST(BKPF.WWERT AS DATE) AS TS_WWERT, 
    CAST(BKPF.STODT AS DATE) AS TS_STODT, 
    CAST(BKPF.REINDAT AS DATE) AS TS_REINDAT, 
    CAST(BKPF.VATDATE AS DATE) AS TS_VATDATE, 
    CAST(BKPF.INTDATE AS DATE) AS TS_INTDATE, 
    CAST(BKPF.PSOBT AS DATE) AS TS_PSOBT, 
    CAST(BKPF.PSODT AS DATE) AS TS_PSODT, 
    CAST(BKPF.PSODT AS DATE) + CAST(BKPF.PSOTM AS TIME) AS TS_PSODT_PSOTM,
    CAST(BKPF.OFFSET_REFER_DAT AS DATE) AS TS_OFFSET_REFER_DAT, 
    SUBSTRING(BKPF.AWKEY,1,14) AS RBKPKEY -- Join to MM (RBKP)
FROM    
	BKPF AS BKPF
    INNER JOIN RSEG AS RSEG ON 1=1
        AND BKPF.MANDT = RSEG.MANDT
		AND SUBSTRING(BKPF.AWKEY,1,14) = RSEG.BELNR || CAST(RSEG.GJAHR AS VARCHAR(4))
    INNER JOIN _CEL_P2P_CASES AS CASES ON 1=1
        AND RSEG.MANDT = CASES.MANDT
        AND RSEG.EBELN = CASES.EBELN
        AND RSEG.EBELP = CASES.EBELP
;