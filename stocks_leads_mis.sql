/*** to print total leads and total account open date-wise****/
SELECT COUNT(distinct a.mobile_number),
count(distinct case when b.activate_date <> ' ' then a.mobile_number END) AS account_open_date,
campaign,date(a.eventtime) as lead_date FROM analytics_db.appsflyer_data_post_jan_final a
JOIN analytics_db.stocks_leads_jan22 b
ON a.mobile_number = b.mobile_no
WHERE a.campaign IN ('Appnext_Stocks_Dhani','AF_CC_Stocks_Dhani','Adsplay_Stocks_Dhani','Internal_UAC_3.0_Android_S_Registration 003')
GROUP BY campaign,lead_date;