/** ALKA--calculate jan and feb unique mobile number by union 2 tables of jan and feb****/
select COUNT(DISTINCT T.mobile_no),T.activate_date
FROM (SELECT * FROM stocks_jan22_alka
UNION
select * FROM stocks_feb22_alka) AS T
GROUP BY activate_date

/** ALKA-- create new table of jan and feb unique mobile number by union 2 tables of jan and feb****/
CREATE TABLE analytics_db.stocks_jan_feb08 AS 
SELECT * FROM stocks_jan22_alka
UNION
select * FROM stocks_feb22_alka;


SELECT COUNT(distinct a.mobile_no),a.campaign,date(a.event_time),b.mobile_no
FROM analytics_db.stocks_appflyer_alka as a
JOIN (SELECT * FROM stocks_jan22_alka 
UNION ALL
select * FROM stocks_feb22_alka) AS b
ON a.mobile_no = b.mobile_no
WHERE a.campaign IN ('Internal_UAC_3.0_Android_S_Registration 003')
GROUP BY campaign, a.event_time;



CREATE TABLE analytics_db.stocks_appflyer_jan_feb08 AS 
SELECT * FROM stocks_appflyer_alka
UNION ALL 
SELECT *  FROM stocks_mis_vishant;


SELECT * FROM stocks_appflyer_jan_feb08

/**** To count unique mobile number per date *****/
SELECT COUNT(DISTINCT mobile_no),activate_date FROM stocks_jan_feb08
GROUP BY activate_date


SELECT SUBSTR(mobile_no,2,11) FROM stocks_appflyer_jan_feb08
LIMIT 10;

/***** MAP Stocks MIS mobile number with Appflyer******/
SELECT COUNT(DISTINCT a.mobile_no)
FROM analytics_db.stocks_jan_feb08 a 
JOIN analytics_db.stocks_appflyer_jan_feb08 b
ON a.mobile_no = b.mobile_no




SELECT COUNT(mobile_no)  FROM stocks_mis_vishant;
SELECT COUNT(mobile_no) FROM stocks_appflyer_alka;
SELECT * FROM stocks_appflyer_jan_feb08

# map mobile number with entire dhani universe
SELECT SUBSTR(mobile_no,5,14) from analytics_db.stocks_jan_feb08
SELECT * FROM analytics_db.stocks_jan_feb08
SELECT * FROM udio_wallet.ib_creditline_application
LIMIT 100

/*** to check the phone number given with Entire Dhani DOF Universe*****/
SELECT COUNT(DISTINCT a.mobile_no), b.status
FROM analytics_db.stocks_jan_feb08 a 
JOIN udio_wallet.ib_creditline_application b
ON a.mobile_no = b.mobile_number
GROUP BY b.status

/*** to check the phone number given with Entire DhaniEpharma Universe*****/
SELECT * from analytics_db.epharma_stocks
LIMIT 100

CREATE TABLE analytics_db.epharma_stocks AS 
SELECT count(distinct a.mobile_no)
FROM analytics_db.stocks_jan_feb08 a 
JOIN analytics_db.Epharmacy b
ON a.mobile_no = b.mobile





/**** Doing on 15Feb****/
SELECT * FROM analytics_db.stocks_crm_13feb;
SELECT * FROM analytics_db.stocks_register_af
SELECT * FROM analytics_db.stocks_otp_af

SELECT COUNT(DISTINCT mobile_number) FROM analytics_db.stocks_crm_13feb
WHERE call_status='Account Opened'

/*** problem with this code is phone number in 'b' so we converted into big-int****/
SELECT  a.mobile_number, b.campaign, a.lead_date, a.call_status
FROM analytics_db.stocks_crm_13feb as a
JOIN analytics_db.stocks_register_af AS b
ON a.mobile_number = b.mobile_number
WHERE b.campaign = 'Internal_UAC_3.0_Android_S_Registration 003'
AND a.call_status = 'Account Opened'
GROUP BY a.lead_date


/**Solution is this:- for stocks register event only---229count***/
SELECT  count(distinct a.mobile_number), b.campaign, a.lead_date
FROM analytics_db.stocks_crm_13feb as a
JOIN analytics_db.stocks_register_af AS b
ON trim(a.mobile_number) = concat(b.mobile_number,"")
WHERE b.campaign = 'Internal_UAC_3.0_Android_S_Registration 003'
AND a.call_status = 'Account Opened'
GROUP BY a.lead_date

/**Solution is this:- for otp entered event only***/
SELECT  count(distinct a.mobile_number), b.campaign, a.lead_date
FROM analytics_db.stocks_crm_13feb as a
JOIN analytics_db.stocks_otp_af AS b
ON trim(a.mobile_number) = concat(b.mobile_number,"")
WHERE b.campaign = 'Internal_UAC_3.0_Android_S_Registration 003'
AND a.call_status = 'Account Opened'
GROUP BY a.lead_date

SELECT  count(distinct a.mobile_number), b.campaign, a.lead_date,a.call_status
FROM analytics_db.stocks_crm_13feb as a
JOIN analytics_db.stocks_otp_af AS b
ON trim(a.mobile_number) = concat(b.mobile_number,"")
WHERE b.campaign = 'Internal_UAC_3.0_Android_S_Registration 003'
GROUP BY a.call_status



SELECT * FROM analytics_db.stocks_register_af;
SELECT * FROM analytics_db.stocks_otp_af


SELECT  distinct a.mobile_number
FROM analytics_db.stocks_register_af as a
JOIN analytics_db.stocks_otp_af AS b
ON a.mobile_number = b.mobile_number
WHERE b.campaign = 'Internal_UAC_3.0_Android_S_Registration 003'
AND a.campaign = 'Internal_UAC_3.0_Android_S_Registration 003'

