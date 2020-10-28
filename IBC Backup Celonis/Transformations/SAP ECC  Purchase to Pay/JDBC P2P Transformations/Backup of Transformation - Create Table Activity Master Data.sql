/*DESCRIPTION:
1. Transformation Description:
This transformation creates a table with the following name: _CEL_P2P_ACTIVITY_MASTER_DATA

















2. Required Tables:
_CEL_P2P_ACTIVITIES

3. Required Columns:
_CEL_P2P_ACTIVITIES.ACTIVITY_DE
_CEL_P2P_ACTIVITIES.ACTIVITY_EN

4. Columns used for timestamp:
None

5. Parameters used in where clause:
None

6. Parameters used in joins:
None
*/
/*Note: Use this table to add additional information for each activity. Level = Header or Item, AVG_TIME = Time it takes to perform the activity in minutes.
The current values are suggestions, they should be adapted according to each project specifications.*/

DROP TABLE IF EXISTS _CEL_P2P_ACTIVITY_MASTER_DATA;

CREATE TABLE _CEL_P2P_ACTIVITY_MASTER_DATA AS (
SELECT DISTINCT
    "ACTIVITY_DE" AS "ACTIVITY_DE"
    ,"ACTIVITY_EN" AS "ACTIVITY_EN"
    ,CASE
  		 WHEN "ACTIVITY_EN" IN ('Increase Contract Target Quantity', 'Decrease Contract Target Quantity', 'Increase Contract Target Value', 'Decrease Contract Target Value',
                               'Increase Contract Net Price', 'Decrease Contract Net Price', 'Increase Effective Contract Item Value', 'Decrease Effective Contract Item Value')
  		 THEN 'Contract'
         WHEN "ACTIVITY_EN" IN ('Cancel Invoice Receipt' ,'Change Approval for Purchase Order', 'Cancel Currency','Change Final Invoice Indicator' , 'Change Vendor' ,
                                  'Clear Invoice' , 'Record Invoice Receipt' , 'Send Purchase Order Update' ,'Set Payment Block' , 'Waiting for Approval (Initial)')
         THEN 'Header'
         WHEN "ACTIVITY_EN" IN ('Block Purchase Order Item', 'Cancel Goods Receipt' , 'Change Delivery Date (actual)' , 'Change Delivery Date (scheduled)' ,
                               'Change Delivery Indicator' , 'Change Outward Delivery Indicator' , 'Change Rejection Indicator' , 'Change Price' ,
                                  'Change Quantity' , 'Change Storage Location' , 'Create Purchase Order Item' , 'Create Purchase Requisition Item',
                               'Delete Purchase Order Item' , 'PO approved (1st stage)', 'PO approved (2nd stage)' , 'PO approved (direct)' ,
                               'Reactivate Purchase Order Item' , 'Receive Order Confirmation' , 'Record Goods Receipt' , 'Remove Payment Block' , 'Send Purchase Order')
         THEN 'Item'
         ELSE 'Custom'
         END AS "LEVEL"
    ,CASE
         WHEN "ACTIVITY_EN" IN ('Create Purchase Order Item' , 'Create Purchase Requisition Item' , 'Delete Purchase Order Item' , 'PO approved (1st stage)' ,
                               'Receive Order Confirmation' , 'Record Goods Receipt' , 'Record Invoice Receipt' , 'Remove Payment Block' , 'Send Purchase Order Update' ,
                                   'Set Payment Block' , 'Waiting for Approval (Initial)' , 'Change Outward Delivery Indicator')
         THEN 5
         WHEN "ACTIVITY_EN" IN ('Change Approval for Purchase Order' , 'Cancel Currency' , 'Change Delivery Date (actual)' , 'Change Delivery Date (scheduled)' ,
                              'Change Delivery Indicator' , 'Change Final Invoice Indicator' , 'Change Rejection Indicator' , 'Clear Invoice' )
         THEN 10
         WHEN "ACTIVITY_EN" = 'Send Purchase Order'
         THEN 15
         WHEN "ACTIVITY_EN" IN ('Cancel Goods Receipt' , 'Record Invoice Receipt' , 'Change Price' , 'Change Quantity' , 'Change Storage Location' ,
                                'PO approved (2nd stage)' , 'PO approved (direct)' , 'Reactivate Purchase Order Item')
         THEN 30
         WHEN "ACTIVITY_EN" IN ('Increase Contract Target Quantity', 'Decrease Contract Target Quantity', 'Increase Contract Target Value', 'Decrease Contract Target Value',
                               'Increase Contract Net Pice', 'Decrease Contract Net Pice', 'Increase Effective Contract Item Value', 'Decrease Effective Contract Item Value')
  		 THEN 30
         WHEN "ACTIVITY_EN" IN ('Block Purchase Order Item' , 'Change Vendor')
         THEN 60
         ELSE 30
         END AS "AVG_TIME"
FROM _CEL_P2P_ACTIVITIES
);