--Select Count(*) FROM RSEG

Drop View If Exists AP_RSEG;
Create View AP_RSEG AS (Select 
"RSEG"."MANDT"
,"RSEG"."BELNR"
,"RSEG"."GJAHR"
,"RSEG"."BUZEI"
,"RSEG"."EBELN"
,"RSEG"."EBELP"
,"RSEG"."BUKRS"
FROM 
RSEG);

Drop View If Exists AP_RBKP;
Create View AP_RBKP AS (Select 
"RBKP"."MANDT"
,"RBKP"."BELNR"
,"RBKP"."GJAHR"
,"RBKP"."BUKRS"
FROM 
RBKP);