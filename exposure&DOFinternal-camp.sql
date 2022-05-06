***********1. Zone 1,2,3 ,4 & R (Exclude customers who did transaction in the last 7 days)*******

SELECT * FROM  udio_wallet.dw_credit_transaction LIMIT 100;


SELECT count(DISTINCT a.mobile_number), a.zone_name FROM udio_wallet.ib_creditline_exposure a 
LEFT JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
WHERE DATE(b.txn_date) <=  CURDATE()-7
AND a.zone_name IN ('zone_1','zone_2','zone_3','zone_4','zone_r')
AND a.status = 'open'
GROUP BY a.zone_name



********** For aligning the campaigns on DOF we would need the revised data of the below mentioned segments, & each base should be mutually exclusive from the other:
Card Application
Hard Approved
Doc Upload
Archived Base *********

SELECT * FROM  udio_wallet.ib_creditline_application LIMIT 100;


SELECT DISTINCT mobile_number, first_name FROM  udio_wallet.ib_creditline_application
WHERE STATUS = 'card_application' LIMIT 1000000 OFFSET 5000000

SELECT DISTINCT mobile_number, first_name FROM  udio_wallet.ib_creditline_application
WHERE STATUS = 'archived' LIMIT 1000000 OFFSET 2000000

SELECT DISTINCT mobile_number , first_name FROM  udio_wallet.ib_creditline_application
WHERE STATUS = 'doc_uploaded' LIMIT 1000000 offset 1000000

SELECT DISTINCT mobile_number , first_name FROM  udio_wallet.ib_creditline_application
WHERE STATUS = 'hard_approved'
