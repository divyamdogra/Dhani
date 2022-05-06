******1.0***************First TRANSACTION***********
DROP TABLE analytics_db.first_transaction_new;

CREATE TABLE analytics_db.first_transaction_new as
SELECT a.consumer_id,min(a.id) AS id, MIN(date(a.created_date)) AS frst_txn_date
FROM udio_wallet.dw_card_transaction a
JOIN
udio_wallet.ib_creditline_application b
ON a.consumer_id = b.consumer_id
GROUP BY a.consumer_id
having
frst_txn_date >= '2022-02-01'
AND
frst_txn_date <= '2022-02-28';


****1.1*********Adding narration**************
DROP TABLE analytics_db.first_narration;

CREATE TABLE analytics_db.first_narration as
SELECT a.*,b.narration FROM first_transaction_new a
JOIN udio_wallet.dw_card_transaction b
ON a.id = b.id;



****1.2*********Adding Onboarded_date********* less than14 and greaterthan14
DROP TABLE analytics_db.final_first_transactors; 

CREATE TABLE analytics_db.final_first_transactors as
SELECT a.*,date(b.onboard_date) FROM analytics_db.first_narration a
JOIN udio_wallet.ib_creditline_application b
ON a.consumer_id = b.consumer_id
WHERE b.`status` = 'onboarded';

SELECT * FROM analytics_db.final_first_transactors;


****2.0*********Retention customers*********
DROP TABLE analytics_db.retention_customers_1;

CREATE TABLE analytics_db.retention_customers_1 as
SELECT distinct b.consumer_id,COUNT(b.id),b.narration 
from udio_wallet.dw_card_transaction b
WHERE date(b.created_date) BETWEEN '2022-02-01' and '2022-02-28'
AND b.consumer_id NOT IN (SELECT consumer_id FROM analytics_db.final_first_transactors )
GROUP BY b.consumer_id
HAVING COUNT(b.id) >= 1;

SELECT * FROM analytics_db.retention_customers_1

********3.0*******Retention All with TRANSACTION***************

DROP TABLE analytics_db.dectxn; 

CREATE TABLE analytics_db.dectxn as
SELECT consumer_id,narration,DATE(created_date),id FROM udio_wallet.dw_card_transaction WHERE
 DATE(created_date) BETWEEN '2022-02-01' AND '2022-02-28';
 
DROP TABLE analytics_db.retention_partial; 
 
CREATE TABLE analytics_db.retention_partial as
SELECT * FROM analytics_db.dectxn
WHERE consumer_id NOT IN (select consumer_id from analytics_db.final_first_transactors);

******main TABLE which IS needed********
SELECT COUNT(consumer_id),COUNT(DISTINCT consumer_id),narration FROM 
analytics_db.retention_partial
GROUP BY narration;


