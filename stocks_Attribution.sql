/*************************** STOCKS ATTRIBUTION **********************/

/******************Overall base*******************************/

select COUNT(mobile_number),activation_date from analytics_db.stocks_base_17feb
where remark = 'A/C opeded' 
group by activation_date;

/******************External Campaigns*******************************/
SELECT * FROM analytics_db.stocks_base_17feb
SELECT COUNT(distinct a.mobile_number),b.Campaign,a.activation_date FROM analytics_db.stocks_base_17feb a
JOIN analytics_db.appsflyer_data_post_feb_final b
ON a.mobile_number = b.mobile_number
WHERE b.Campaign IN ('AF_CC_Stocks_Dhani',
'Adsplay_Stocks_Dhani',
'Appnext_Stocks_Dhani',
'Internal_UAC_3.0_Android_S_Registration 003')
AND remark = 'A/C opeded'
GROUP BY b.Campaign, a.activation_date;

/**** create distinct mobile_no table so that we can do next internal Campaigns acc to periority****/

create table analytics_db.external_base_stocks as
SELECT distinct a.mobile_number FROM analytics_db.stocks_base_17feb a
JOIN analytics_db.appsflyer_data_post_feb_final b
ON a.mobile_number = b.mobile_number
WHERE b.Campaign IN ('AF_CC_Stocks_Dhani',
'Adsplay_Stocks_Dhani',
'Appnext_Stocks_Dhani',
'Internal_UAC_3.0_Android_S_Registration 003')
AND remark = 'A/C opeded';

/**to check table created above*****/
SELECT * FROM analytics_db.external_base_stocks


