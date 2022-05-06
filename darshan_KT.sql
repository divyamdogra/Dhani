

Txn Wallet Summary Report:
(DOF Monthly Txn Unique Count)


SELECT
count(distinct b.mobile_number)
from udio_wallet.dw_credit_transaction b
where DATE_FORMAT(b.txn_date, '%Y-%m-%d') BETWEEN '2022-03-01' AND '2022-03-31' (Change Yesterday date)




Card Txn Uses Summary Report:(Monthly)(Change monthly basis)

For ALL Txn CODE:

SELECT
COUNT(b.id) as txns,
count(distinct b.consumer_id) as users,
ifnull(sum(b.amount), 0) as amount
FROM
udio_wallet.dw_card_transaction b force index (idx_created_date)
WHERE
b.status = 'success'
AND b.created_date >= '2022-03-01'
AND b.created_date < '2022-04-01'

FOR DOF Txn CODE:

SELECT
COUNT(b.id) as txns,
count(distinct b.consumer_id) as users,
ifnull(sum(b.amount), 0) as amount
from
udio_wallet.dw_card_transaction b force index (idx_created_date)
join udio_wallet.dw_credit_transaction c on b.txn_code = c.txn_code
WHERE
b.status = 'success'
and c.product_type = 'supersaver'
AND b.created_date >= '2022-03-01'
AND b.created_date < '2022-04-01'



#Subscriptions of DOF

- Via mandate
SELECT DATE(webhook_recd_date),COUNT(1),SUM(b.amount) FROM udio_wallet.ib_creditline_application a
JOIN udio_wallet.ib_digio_payment b ON a.pl_mandate_ref=b.dhani_ref_id
WHERE b.status='success' AND b.webhook_recd_date >='20220301' and b.webhook_recd_date <='20220401'
GROUP BY 1;

- Via tile
SELECT Date(txn_date),COUNT(1),SUM(b.amount) FROM 
udio_wallet.ib_creditline_application a
join udio_wallet.ib_creditline_subscrition_payment b ON a.application_id=b.application_id
WHERE b.STATUS='success' AND b.txn_date >='20220301' and b.txn_date<='20220401'
GROUP BY 1;

#Supersaver Subscriptions

SELECT Date(payment_timestamp),COUNT(1),SUM(amount) FROM udio_wallet.ib_supersaver_payments 
WHERE STATUS='success' AND amount > 1 AND payment_timestamp >='20220301' and payment_timestamp<='20220401'
GROUP BY 1;

#Dhani Doctor Subscriptions

- All
SELECT DATE(transaction_date), COUNT(1),SUM(txn_amount) FROM udio_wallet.dd_patient_subscription_transaction
WHERE STATUS='success' AND transaction_date >='20220301' and transaction_date <= '20220401'
GROUP BY 1;






