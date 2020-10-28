--Statement: Release/Block Purchase Requisition and Change Purchase Order

--In the P2P process the indicators of Purchase Requisitions and Purchase Orders have to be looked up and adjusted by executing the following SQL query on the source database. 
--Then you have to set the parameters with the actual query results. 

--Release Indicator Purchase Requistions
SELECT * FROM T161U;


SELECT VALUE_NEW, COUNT(1)
FROM "CDPOS"
WHERE FNAME='FRGKZ'
GROUP BY VALUE_NEW
ORDER BY COUNT(1) DESC;


--Release Purchase Orders
SELECT * FROM T16FE;
 
 
SELECT VALUE_NEW, COUNT(1)
FROM "CDPOS"
WHERE FNAME='FRGKE'
GROUP BY VALUE_NEW
ORDER BY COUNT(1) DESC;