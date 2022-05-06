**code to find cancelled DOF customers***

SELECT distinct a.mobile_number,date(a.subscription_cancelled_by_user) AS cancelled FROM udio_wallet.ib_creditline_application a
WHERE a.status = 'onboarded'
AND a.loan_type = 'daily'
AND
a.subscription_status = 'cancelled'
and
DATE_FORMAT(a.subscription_cancelled_by_user, '%Y-%m-%d') BETWEEN '2022-01-01' AND '2022-02-20';


****Code to find First Transaction***

select a.mobile_number,date(b.txn_date) AS txn_date
from udio_wallet.ib_creditline_application a
join udio_wallet.dw_credit_transaction b on a.application_id=b.credit_application_id
join (select min(id) as id from udio_wallet.dw_credit_transaction where product_type='supersaver'
group by credit_application_id) c on b.id=c.id
where a.loan_type='daily'
and date(b.txn_date) BETWEEN '2022-02-01' AND '2022-02-20' ;