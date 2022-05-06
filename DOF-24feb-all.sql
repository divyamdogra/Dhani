**********Overall Step 1**********

SELECT COUNT(DISTINCT a.mobile_number) AS onboarders_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL OR a.first_payment_date <> ' '  then a.mobile_number end)SFP_Paid,
COUNT(distinct case when c.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end)cancelled
FROM udio_wallet.ib_creditline_application a
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY    /*  '2022-02-24'*/
AND a.STATUS = 'onboarded';      

********API Step2***********

SELECT COUNT(DISTINCT a.mobile_number) AS onboarding_count,
COUNT(case when a.first_payment_date IS NOT NULL then 'Y' end)SFP_Paid,
COUNT(case when b.txn_code IS NOT NULL then 'Y' end)txn_done,
COUNT(case when a.subscription_status = 'cancelled' then 'Y' end) cancelled, a.lead_source
from udio_wallet.ib_creditline_application a
left JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
WHERE DATE(onboard_date) = CURDATE() - Interval 2 DAY
AND lead_source IN ('HXB','buddyloan','adsplay','RTB_D','CreditCircle','onecode','leadclub')
AND a.STATUS = 'onboarded'
GROUP BY lead_source;

******Step 2.1 API Table creation*******
DROP TABLE analytics_db.DOF_API_Table1;

CREATE TABLE analytics_db.DOF_API_Table1
AS
SELECT DISTINCT mobile_number
from udio_wallet.ib_creditline_application
WHERE DATE(onboard_date) = CURDATE() - Interval 2 DAY
AND lead_source IN ('HXB','buddyloan','adsplay','RTB_D','CreditCircle','leadclub','onecode')
AND STATUS = 'onboarded';

SELECT * FROM analytics_db.DOF_API_Table1

*********WEB data_Step3********* 

SELECT COUNT(DISTINCT a.mobile_number) AS onboarding_counts,
COUNT(case when a.first_payment_date IS NOT NULL then 'Y' end)SFP_Paid,
COUNT(case when b.txn_code IS NOT NULL then 'Y' end)txn_done,
COUNT(case when a.subscription_status = 'cancelled' then 'Y' end) cancelled, c.utm_source
from udio_wallet.ib_creditline_application a
left JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
JOIN udio_wallet.utm_tracking c
ON a.application_id = c.application_id
WHERE DATE(onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_API_Table1 )
GROUP BY utm_source
ORDER BY onboarding_counts DESC;    



******Step 3.1 table creation******
DROP TABLE analytics_db.DOF_web_Table2;

CREATE TABLE analytics_db.DOF_web_Table2
AS
SELECT DISTINCT a.mobile_number
from udio_wallet.ib_creditline_application a
left JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
JOIN udio_wallet.utm_tracking c
ON a.application_id = c.application_id
WHERE DATE(onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_API_Table1);

SELECT * from analytics_db.DOF_web_Table2

*******Step 4 Promo code DATA*******

	SELECT COUNT(DISTINCT a.mobile_number) AS onboarding_counts,
	COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
	COUNT(distinct case when b.txn_code IS NOT NULL then a.mobile_number end)txn_done,
	COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled,c.coupon_desc
	from udio_wallet.ib_creditline_application a
	JOIN analytics_db.dof_onboarded_through_coupon_Apr c
	ON a.mobile_number = c.mobile_number
	left JOIN udio_wallet.dw_credit_transaction b
	ON a.mobile_number = b.mobile_number
	WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
	AND a.STATUS = 'onboarded'
	AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_API_Table1 UNION 
	SELECT mobile_number FROM analytics_db.DOF_web_Table2)
	GROUP BY c.coupon_desc
	ORDER BY onboarding_counts DESC;

****Step 4.1*****Promo code TABLE****
DROP TABLE analytics_db.DOF_promo_Table3;

CREATE TABLE analytics_db.DOF_promo_Table3
AS
SELECT DISTINCT a.mobile_number
from udio_wallet.ib_creditline_application a
JOIN analytics_db.dof_onboarded_through_coupon_Apr c
ON a.mobile_number = c.mobile_number
left JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1);

SELECT * FROM analytics_db.DOF_promo_Table3


*******Step 5 Referal******

SELECT count(distinct a.mobile_number) onboarding_count,
COUNT(case when a.first_payment_date IS NOT NULL then 'Y' end)SFP_Paid,
COUNT(case when c.txn_code IS NOT NULL then 'Y' end)txn_done,
COUNT(case when a.subscription_status = 'cancelled' then 'Y' end) cancelled
 FROM udio_wallet.ib_creditline_application a
JOIN udio_wallet.ib_referrer_referee_mapping b
ON a.mobile_number = b.referee_mobile_number
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE a.status = 'onboarded'
AND a.loan_type = 'daily'
AND b.status in ('registered','pending')
and DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1 union
select mobile_number FROM analytics_db.DOF_promo_Table3);

****Step 5.1 *****Referal table*****
DROP TABLE analytics_db.DOF_refer_Table4;

CREATE TABLE analytics_db.DOF_refer_Table4 AS
SELECT distinct a.mobile_number
FROM udio_wallet.ib_creditline_application a
JOIN udio_wallet.ib_referrer_referee_mapping b
ON a.mobile_number = b.referee_mobile_number
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE a.status = 'onboarded'
AND a.loan_type = 'daily'
AND b.status in ('registered','pending')
and DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1 union
select mobile_number FROM analytics_db.DOF_promo_Table3);

SELECT * FROM analytics_db.DOF_refer_Table4

*******Step 6 External campaigns*****

SELECT COUNT(DISTINCT a.mobile_number) AS onboarding_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
COUNT(distinct case when b.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled,
c.partner,c.media_source
from udio_wallet.ib_creditline_application a
JOIN analytics_db.appsflyer_data_post_april_final c
ON a.mobile_number = c.mobile_number
left JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND date(c.eventtime) >=  CURDATE() - Interval 31 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table3)
GROUP BY c.partner,c.media_source
ORDER BY onboarding_counts DESC;

****Step 6.1 External Table creation******
drop TABLE analytics_db.DOF_external_Table5;

CREATE TABLE analytics_db.DOF_external_Table5
AS
SELECT DISTINCT a.mobile_number
from udio_wallet.ib_creditline_application a
JOIN analytics_db.appsflyer_data_post_april_final c
ON a.mobile_number = c.mobile_number
left JOIN udio_wallet.dw_credit_transaction b
ON a.mobile_number = b.mobile_number
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND date(c.eventtime) >= CURDATE() - Interval 28 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table3);

SELECT * FROM analytics_db.DOF_external_Table5


*******Step 7 Internal campaign -- doc uploaded*****
SELECT * FROM analytics_db.docUploaded_final;
SELECT SUBSTR(mobile_no,2,10) FROM analytics_db.docUploaded_final;

SELECT COUNT(DISTINCT a.mobile_number) AS onboarded_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
COUNT(distinct case when c.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.docUploaded_final b
ON a.mobile_number = SUBSTR(b.mobile_no,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5);


*********Step 7.1 table creation -- doc Uploaded****
DROP TABLE analytics_db.DOF_docuploaded_table6; 

CREATE TABLE analytics_db.DOF_docuploaded_table6 as
SELECT DISTINCT a.mobile_number
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.docUploaded_final b
ON a.mobile_number = SUBSTR(b.mobile_no,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2 UNION 
SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5);

SELECT * FROM analytics_db.DOF_docuploaded_table6


********Step 8 hard approved data*******

SELECT * FROM analytics_db.hardApproved;
SELECT SUBSTR(mobile_no,2,10) FROM analytics_db.hardApproved;

SELECT COUNT(DISTINCT a.mobile_number) AS onboarded_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
COUNT(distinct case when c.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.hardApproved b
ON a.mobile_number = SUBSTR(b.mobile_no,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6);

********Step 8.1 hardApproved data ******
DROP TABLE analytics_db.DOF_hardapproved_table7;

CREATE TABLE analytics_db.DOF_hardapproved_table7
as
SELECT DISTINCT a.mobile_number
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.hardApproved b
ON a.mobile_number = SUBSTR(b.mobile_no,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6);

SELECT * FROM analytics_db.DOF_hardapproved_table7


********Step 9 card application data*******

SELECT * FROM analytics_db.cardapplication_final;
SELECT SUBSTR(mobile_no,2,10) FROM analytics_db.cardapplication_final;

SELECT COUNT(DISTINCT a.mobile_number) AS onboarded_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
COUNT(distinct case when c.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.cardapplication_final b
ON a.mobile_number = SUBSTR(b.mobile_no,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6
UNION SELECT mobile_number FROM analytics_db.DOF_hardapproved_table7);

********Step 9.1 card application data ******
DROP TABLE analytics_db.DOF_cardapplication_table8;

CREATE TABLE analytics_db.DOF_cardapplication_table8
as
SELECT DISTINCT a.mobile_number
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.cardapplication_final b
ON a.mobile_number = SUBSTR(b.mobile_no,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6
UNION SELECT mobile_number FROM analytics_db.DOF_hardapproved_table7);

SELECT * FROM analytics_db.DOF_cardapplication_table8


********Step 10 archived data*******

SELECT * FROM analytics_db.archived_final;
SELECT SUBSTR(mobile_number,2,10) FROM analytics_db.archived_final;

SELECT COUNT(DISTINCT a.mobile_number) AS onboarded_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
COUNT(distinct case when c.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.archived_final b
ON a.mobile_number = SUBSTR(b.mobile_number,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6
UNION SELECT mobile_number FROM analytics_db.DOF_hardapproved_table7
UNION SELECT mobile_number FROM analytics_db.DOF_cardapplication_table8);     


********Step 10.1 archieved data ******
DROP TABLE analytics_db.DOF_archived_table9;

CREATE TABLE analytics_db.DOF_archived_table9
as
SELECT DISTINCT a.mobile_number
FROM udio_wallet.ib_creditline_application a
JOIN analytics_db.archived_final b
ON a.mobile_number = SUBSTR(b.mobile_number,2,10)
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6
UNION SELECT mobile_number FROM analytics_db.DOF_hardapproved_table7
UNION SELECT mobile_number FROM analytics_db.DOF_cardapplication_table8);

SELECT * FROM analytics_db.DOF_archived_table9


*****Step 11 create combine data*******
DROP TABLE analytics_db.DOF_all_attribution;

CREATE TABLE analytics_db.DOF_all_attribution as
SELECT mobile_number FROM analytics_db.DOF_web_Table2
UNION SELECT mobile_number FROM analytics_db.DOF_API_Table1
UNION SELECT mobile_number FROM analytics_db.DOF_refer_Table4
UNION SELECT mobile_number FROM analytics_db.DOF_promo_Table3
UNION SELECT mobile_number FROM analytics_db.DOF_external_Table5
UNION SELECT mobile_number FROM analytics_db.DOF_docuploaded_table6
UNION SELECT mobile_number FROM analytics_db.DOF_hardapproved_table7
UNION SELECT mobile_number FROM analytics_db.DOF_cardapplication_table8
UNION SELECT mobile_number FROM analytics_db.DOF_archived_table9;

SELECT * FROM analytics_db.DOF_all_attribution


********Step 12 for organic numbers*****

SELECT COUNT(DISTINCT a.mobile_number) AS onboarded_counts,
COUNT(distinct case when a.first_payment_date IS NOT NULL then a.mobile_number end)SFP_Paid,
COUNT(distinct case when c.txn_code IS NOT NULL then a.mobile_number end)txn_done,
COUNT(distinct case when a.subscription_status = 'cancelled' then a.mobile_number end) cancelled
FROM udio_wallet.ib_creditline_application a
LEFT JOIN udio_wallet.dw_credit_transaction c
ON a.application_id = c.credit_application_id
WHERE DATE(a.onboard_date) = CURDATE() - Interval 2 DAY
AND a.STATUS = 'onboarded'
AND a.mobile_number NOT IN (SELECT distinct mobile_number FROM analytics_db.DOF_all_attribution);