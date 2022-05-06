/**********************UTM code(10am 1pm 5pm)**************************/

Select a.mobile_number,DATE(b.created_date) AS Application_Date,DATE(a.onboard_date) as onboard_date,
b.utm_source,b.utm_medium,b.utm_campaign,b.utm_id,b.utm_term,b.utm_content,
a.status,DATE(a.created_date) AS Application_Date_Dof from udio_wallet.ib_creditline_application a
Left JOIN udio_wallet.utm_tracking b
ON a.application_id = b.application_id
WHERE a.loan_type='daily' AND a.platform='WEB'

/**********************API data(10am 1pm 5pm)**************************/

SELECT DISTINCT a.mobile_number,a.lead_source,DATE(a.created_date) as Application_date,
DATE(a.onboard_date) AS onboarded_date,a.status,b.partner_consumer_id,
case when c.txn_code IS NOT NULL then 'Y' end txn_done
from udio_wallet.ib_creditline_application a
JOIN udio_wallet.creditline_partner_consumer b
 ON a.mobile_number = b.mobile_number
left JOIN udio_wallet.dw_credit_transaction c
ON a.mobile_number = c.mobile_number
WHERE lead_source IN ('HXB','buddyloan','adsplay','RTB_D','CreditCircle','onecode','LeadClub')



/********** UTM with state city and pincode code from KYC table ********/
SELECT distinct a.mobile_number,DATE(b.created_date) AS Application_Date,DATE(a.onboard_date) as onboard_date,b.utm_source,b.utm_medium,
b.utm_campaign,b.utm_id,b.utm_term,b.utm_content,a.status,DATE(a.created_date) AS Application_Date_Dof,
c.ca_state,c.ca_city,c.ca_pincode
from udio_wallet.ib_creditline_application a
Left JOIN udio_wallet.utm_tracking b
ON a.application_id = b.application_id
LEFT JOIN udio_wallet.dw_kyc_application c
ON a.mobile_number=c.mobile_number
WHERE a.loan_type='daily' AND a.platform='WEB'


/***To add 1st transaction of user in both UTM and API*****/
/*** problem in API solution was repetitive mobile number against txn-date****/
SELECT DISTINCT a.mobile_number,a.lead_source,DATE(a.created_date) as Application_date,
DATE(a.onboard_date) AS onboarded_date,a.status,b.partner_consumer_id,c.txn_date
from udio_wallet.ib_creditline_application a
JOIN udio_wallet.creditline_partner_consumer b
 ON a.mobile_number = b.mobile_number
left JOIN udio_wallet.dw_credit_transaction c
ON a.mobile_number = c.mobile_number
WHERE lead_source IN ('HXB','buddyloan','adsplay','RTB_D','CreditCircle','onecode')



/**********************API data-Added 1st transaction date from c **************************/

SELECT DISTINCT a.mobile_number,a.lead_source,DATE(a.created_date) as Application_date,
DATE(a.onboard_date) AS onboarded_date,a.status,b.partner_consumer_id,
c.txn_date
from udio_wallet.ib_creditline_application a
JOIN udio_wallet.creditline_partner_consumer b
 ON a.mobile_number = b.mobile_number
left JOIN (SELECT mobile_number,MIN(date(txn_date)) AS txn_date
           from udio_wallet.dw_credit_transaction
           group by mobile_number) c
ON a.mobile_number = c.mobile_number
WHERE lead_source IN ('HXB','buddyloan','adsplay','RTB_D','CreditCircle','onecode','leadclub')


/**********************UTM data-Added 1st transaction date from c **************************/

Select a.mobile_number,DATE(b.created_date) AS Application_Date,DATE(a.onboard_date) as onboard_date,b.utm_source,b.utm_medium,
b.utm_campaign,b.utm_id,b.utm_term,b.utm_content,a.status,DATE(a.created_date) AS Application_Date_Dof,c.txn_date
from udio_wallet.ib_creditline_application a
Left JOIN udio_wallet.utm_tracking b
ON a.application_id = b.application_id
left JOIN (SELECT mobile_number,MIN(date(txn_date)) AS txn_date
           from udio_wallet.dw_credit_transaction
           group by mobile_number) c
ON a.mobile_number = c.mobile_number
WHERE a.loan_type='daily' AND a.platform='WEB'





AND DATE(a.created_date) BETWEEN '2021-11-01' AND '2021-11-30'
AND b.utm_source LIKE '%Karix%'


