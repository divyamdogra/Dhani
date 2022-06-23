/***** to VIEW ROWS FROM LAST IN a table ******/
SELECT * FROM appsflyer_data_post_jan_final ORDER BY eventtime desc
LIMIT 100;

SELECT * FROM stocks_feb22_alka;

SELECT DISTINCT mobile_no
FROM dof_campaign_jan22_2;   order_id

SELECT COUNT(mobile_no) FROM dof_campaign_jan22_11;
LIMIT 100;

SELECT DISTINCT email_id,mobile_no
FROM gst_data

SELECT DISTINCT mobile_no FROM gst_data LIMIT 1000000 OFFSET 2000000;

SELECT COUNT(DISTINCT mobile_no,email_id)
FROM gst_data


SELECT * FROM appsflyer_data_post_jan_final
LIMIT 100;

SELECT * FROM Stocks_feb22_final


CREATE TABLE archived_final AS 
SELECT mobile_number FROM analytics_db.archived_1
UNION 
SELECT mobile_number FROM analytics_db.archived_2
UNION 
SELECT mobile_number FROM analytics_db.archived_3

****registration dump****
SELECT * FROM analytics_db.superpre_qualified_registration LIMIT 100;
SELECT * FROM analytics_db.referee_earned_registration LIMIT 100;
*****freecashback dump*******
SELECT * FROM analytics_db.dcl_newcustomer_freecashback LIMIT 100;
SELECT * FROM analytics_db.dhanicash_registered_freecashback LIMIT 100;
SELECT * FROM analytics_db.fcc_dhani_cash_user LIMIT 100;
SELECT * FROM analytics_db.full_kyc_cust_base LIMIT 100;
SELECT * FROM analytics_db.noncashback_base_fcc LIMIT 100;
SELECT * FROM analytics_db.nonwallet_base_fcc LIMIT 100;
SELECT * FROM analytics_db.rs50cashback_fcc LIMIT 100;


SELECT * from dof_onboarded_through_coupon_Mar
where date(voucher_redeemed_at) = '2022-03-10' 

CREATE TABLE Epharmacy_dup as
SELECT DISTINCT * FROM Epharmacy


SELECT * FROM Epharmacy
WHERE DATE(created_time) = '2022-03-09' 


SELECT * FROM udio_wallet.ib_creditline_application LIMIT 1000
SELECT * from udio_wallet.dw_kyc_document LIMIT 1000
SELECT * from udio_wallet.b2c_user LIMIT 1000


SELECT COUNT(DISTINCT a.mobile_number) AS onboarding_counts from
udio_wallet.ib_creditline_application a
WHERE a.status = 'onboarded'
AND a.mobile_number NOT IN (SELECT distinct mobile_number FROM udio_wallet.dw_kyc_document )


SELECT COUNT(DISTINCT a.mobile_number) 
FROM udio_wallet.dw_kyc_document a
JOIN udio_wallet.ib_creditline_application b
ON a.mobile_number = b.mobile_number
where b.status = 'onboarded'


AND a.mobile_number NOT IN (SELECT distinct mobile_number FROM udio_wallet.ib_creditline_application WHERE status = 'onboarded')


SELECT DISTINCT * from udio_wallet.ib_creditline_application a


SELECT COUNT(DISTINCT mobile_number) 
from udio_wallet.ib_creditline_application a
where a.subscription_status = 'inactive'


SELECT COUNT(DISTINCT a.mobile_number) 
from analytics_db.store_10may a 
inner JOIN udio_wallet.ib_creditline_application b
ON a.mobile_number = b.mobile_number
where b.status = 'onboarded'


SELECT * FROM dof_membership_fee_transaction LIMIT 100;
SELECT * FROM ib_creditline_address LIMIT 100;
SELECT * FROM dw_kyc_application LIMIT 100;

SELECT count(DISTINCT a.mobile_number) AS mobile,a.city FROM analytics_db.dhani_plus_24may a
JOIN udio_wallet.ib_creditline_application b
ON a.mobile_number =  b.mobile_number
WHERE b.is_dof_new_construct_enabled = 1
GROUP BY a.city
ORDER BY mobile DESC; 


#dhani+LTD with city name
SELECT DISTINCT a.mobile_number AS mobile1,b.ca_city,b.ca_state,b.ca_pincode FROM udio_wallet.ib_creditline_application a
JOIN udio_wallet.dw_kyc_application b
ON a.mobile_number =  b.mobile_number
WHERE a.is_dof_new_construct_enabled = 1
GROUP BY mobile1
ORDER BY mobile1 DESC;

SELECT * from udio_wallet.ib_creditline_address LIMIT 1000000 OFFSET 9000000;


SELECT DISTINCT a.mobile_number AS mobile1 FROM udio_wallet.ib_creditline_application a

WHERE a.is_dof_new_construct_enabled = 1


SELECT * FROM udio_wallet.ib_creditline_application LIMIT 100;
SELECT * FROM udio_wallet.dw_credit_transaction LIMIT 100;
SELECT * from ib_creditline_subscrition_payment LIMIT 100;

SELECT distinct a.mobile_number AS mon, sum(b.txn_amount)#,sum(b.credit_amount) 
FROM udio_wallet.ib_creditline_application a
JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
WHERE a.is_dof_new_construct_enabled = 1
AND DATE(b.txn_date) BETWEEN "2022-05-24" and "2022-06-07"
GROUP BY mon

select DISTINCT m.mobile_number,DATE(m.created_date) from dof_membership_fee_transaction m
WHERE DATE(m.created_date) = '2022-06-20'


SELECT COUNT(DISTINCT a.mobile_number) FROM udio_wallet.dof_membership_fee_transaction a
JOIN udio_wallet.ib_creditline_application b
ON a.mobile_number = b.mobile_number
 
WHERE a.subscription_amount IS NULL
#WHERE a.is_onboarded = 1
where b.status = 'onboarded'


SELECT COUNT(DISTINCT b.mobile_number) FROM udio_wallet.ib_creditline_subscrition_payment a
JOIN udio_wallet.ib_creditline_application b
ON a.mobile_number = b.mobile_number


select DISTINCT m.mobile_number,DATE(m.created_date),n.first_name,n.last_name,n.email_id,
case when n.`status`='onboarded' then "DOF"
ELSE "NOT" END AS "DOFornot"
from dof_membership_fee_transaction m
inner join udio_wallet.ib_creditline_application n   
on m.mobile_number = n.mobile_number



SELECT z.mobile_number from  udio_wallet.ib_creditline_application z 
where z.status = 'onboarded'
and z.mobile_number NOT IN
 (SELECT DISTINCT a.mobile_number FROM  udio_wallet.ib_creditline_application  a
JOIN udio_wallet.ib_creditline_subscrition_payment b
ON a.mobile_number = b.mobile_number
where a.status = 'onboarded')
 LIMIT 1000000 OFFSET 1000000
 
select DISTINCT z.mobile,z.first_name,z.last_name,z.email
FROM analytics_db.1april_orders z
WHERE z.mobile IN 
(SELECT DISTINCT n.mobile_number from udio_wallet.ib_creditline_application n
where n.mobile_number NOT IN    
(SELECT m.mobile_number from udio_wallet.dof_membership_fee_transaction m)
and n.status <>'onboarded');


SELECT DISTINCT mobile FROM  1april_orders LIMIT 100;



SELECT DISTINCT a.mobile_number FROM  udio_wallet.ib_creditline_application  a
JOIN udio_wallet.ib_creditline_subscrition_payment b
ON a.mobile_number = b.mobile_number
where a.status = 'onboarded'
AND a.mobile_number NOT IN (SELECT distinct z.mobile_number from  udio_wallet.ib_creditline_application z
JOIN dw_credit_transaction v
ON z.mobile_number = v.mobile_number)



SELECT DISTINCT a.mobile_number,a.created_date#,b.first_name,b.last_name 
from udio_wallet.dof_membership_fee_transaction a
#JOIN udio_wallet.ib_creditline_application  b
#ON a.mobile_number = b.mobile_number
WHERE a.created_date BETWEEN "2022-06-14:18:30:00" AND "2022-06-14:23:59:59"


SELECT * FROM udio_wallet.ib_creditline_application LIMIT 100;
SELECT * from ib_creditline_exposure LIMIT 100;

SELECT count(DISTINCT a.mobile_number),b.zone_name,a.subscription_status FROM udio_wallet.ib_creditline_application a
join ib_creditline_exposure b
ON a.mobile_number = b.mobile_number
WHERE a.`status`='onboarded'
#AND a.subscription_status='cancelled'
GROUP BY b.zone_name,a.subscription_status  


SELECT count(DISTINCT a.mobile_number),a.force_downgrade FROM udio_wallet.ib_creditline_application a
WHERE a.`status`='onboarded'
#AND a.subscription_status='cancelled'
GROUP BY a.force_downgrade


SELECT DISTINCT a.mobile_number FROM udio_wallet.ib_creditline_application a
WHERE a.`status`='onboarded'
AND a.subscription_status='active'
AND a.mobile_number NOT IN (

SELECT DISTINCT b.mobile_number FROM udio_wallet.ib_creditline_application b
WHERE b.force_downgrade = 1) LIMIT 1000000 OFFSET 2000000



