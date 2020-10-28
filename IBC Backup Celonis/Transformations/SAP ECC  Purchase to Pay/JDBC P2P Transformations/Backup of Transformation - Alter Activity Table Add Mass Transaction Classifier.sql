/*A mass transaction is a process of changing multiple master data entries at once in the system. 
  Mass transaction of master records is required when there are a lot of existing master records and you need to change certain data fields in those records. 
  For example, in multiple customer or material masters at one time. A mass transactions is triggered by a manual user, the updates of the different masters are then performed in the background. 
  All those transactions are labeled by the manual user type 'A'. There is no automatic way to identify mass transactions. 
  In this transformation, a heuristic is applied that labels transactions of the same activity and the same user name with user type 'R' in case it was performed within 10 seconds. 
  Then it is assumed to be a mass transaction.
  
  This transformation might take some time to execute as the complete activity table is scanned for activities happening in a certain timeframe.*/

--- ADD COLUMN WITH ROW NUMBER TO ACTIVITY TABLE
ALTER TABLE _CEL_P2P_ACTIVITIES
ADD COLUMN ROW_NUM INT;

--- FILL COLUMN WITH ROW NUMBERS IN ACTIVITY TABLE
UPDATE _CEL_P2P_ACTIVITIES
SET ROW_NUM = ACT.ROW_NR
  FROM (SELECT _CASE_KEY, ACTIVITY_EN, EVENTTIME, ROW_NUMBER() OVER (ORDER BY ACTIVITY_EN, USER_NAME, EVENTTIME) AS ROW_NR FROM _CEL_P2P_ACTIVITIES) AS ACT
    WHERE _CEL_P2P_ACTIVITIES._CASE_KEY = ACT._CASE_KEY
      AND _CEL_P2P_ACTIVITIES.ACTIVITY_EN = ACT.ACTIVITY_EN
      AND _CEL_P2P_ACTIVITIES.EVENTTIME = ACT.EVENTTIME
;


--- HEADER LEVEL ACTIVITIES
UPDATE "_CEL_P2P_ACTIVITIES"
SET USER_TYPE = 'R'
  WHERE _CEL_P2P_ACTIVITIES.ROW_NUM IN (
    SELECT DISTINCT ACTB.ROW_NUM
      FROM "_CEL_P2P_ACTIVITIES" ACTA
        JOIN "_CEL_P2P_ACTIVITIES" ACTB ON 1=1
          AND ACTA."ACTIVITY_EN" = ACTB."ACTIVITY_EN"
          AND ACTA."USER_NAME" = ACTB."USER_NAME"
          AND ACTA."EVENTTIME" <= TIMESTAMPADD('ss',10,ACTB."EVENTTIME")
          AND ACTA."EVENTTIME" >= TIMESTAMPADD('ss',-10,ACTB."EVENTTIME")
          AND ACTA."EBELN" <> ACTB."EBELN"
        WHERE 1=1
          AND ACTA.USER_TYPE = 'A'
          AND ACTB.USER_TYPE = 'A'
          AND ACTA.ROW_NUM > ACTB.ROW_NUM
  );


--- ITEM LEVEL ACTIVITIES
UPDATE "_CEL_P2P_ACTIVITIES"
SET USER_TYPE = 'R'
  WHERE _CEL_P2P_ACTIVITIES.ROW_NUM IN (
    SELECT DISTINCT ACTB.ROW_NUM
      FROM "_CEL_P2P_ACTIVITIES" ACTA
        JOIN "_CEL_P2P_ACTIVITIES" ACTB On 1=1
          AND ACTA."ACTIVITY_EN" = ACTB."ACTIVITY_EN"
          AND ACTA."USER_NAME" = ACTB."USER_NAME"
          AND ACTA."EVENTTIME" <= TIMESTAMPADD('ss',10,ACTB."EVENTTIME")
          AND ACTA."EVENTTIME" >= TIMESTAMPADD('ss',-10,ACTB."EVENTTIME")
          AND NOT (ACTA."EBELN" = ACTB."EBELN" AND ACTA."EBELP" <> ACTB."EBELP")
        WHERE 1=1
          AND ACTA.USER_TYPE IN ('A','R')
          AND ACTB.USER_TYPE = 'A'
          AND ACTA.ROW_NUM < ACTB.ROW_NUM
  );

--- ITEM LEVEL ACTIVITIES (ROUND 2)
UPDATE "_CEL_P2P_ACTIVITIES"
SET USER_TYPE = 'R'
  WHERE _CEL_P2P_ACTIVITIES.ROW_NUM IN (
    SELECT DISTINCT ACTB.ROW_NUM
      FROM "_CEL_P2P_ACTIVITIES" ACTA
        JOIN "_CEL_P2P_ACTIVITIES" ACTB On 1=1
          AND ACTA."ACTIVITY_EN" = ACTB."ACTIVITY_EN"
          AND ACTA."USER_NAME" = ACTB."USER_NAME"
          AND ACTA."EVENTTIME" <= TIMESTAMPADD('ss',10,ACTB."EVENTTIME")
          AND ACTA."EVENTTIME" >= TIMESTAMPADD('ss',-10,ACTB."EVENTTIME")
          AND NOT (ACTA."EBELN" = ACTB."EBELN" AND ACTA."EBELP" <> ACTB."EBELP")
        WHERE 1=1
          AND ACTA.USER_TYPE IN ('A','R')
          AND ACTB.USER_TYPE = 'A'
          AND ACTA.ROW_NUM > ACTB.ROW_NUM
  );