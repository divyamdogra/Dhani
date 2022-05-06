SELECT distinct a.mobile_number,a.First_TXN,onboarded_date,f.narration from
analytics_db.First_Transactors a
join udio_wallet.dw_card_transaction f
ON a.consumer_id = f.consumer_id
where f.narration LIKE '%AMAZON%'
OR
f.narration LIKE '%Zomato%'
OR
f.narration LIKE '%Snapdeal%'
OR
f.narration LIKE '%Grofers%'
OR
f.narration LIKE '%Tata Cliq%'
OR
f.narration LIKE 'TataCliq%'
OR
f.narration LIKE 'Swiggy%'
OR
f.narration LIKE '%Ajio%'
OR
f.narration LIKE '%Dineout%'
OR
f.narration LIKE 'Licious%'
OR
f.narration LIKE '%Shopclues%'
OR
f.narration LIKE '%MMT%'
OR
f.narration LIKE '%Goibibo%'
OR
f.narration LIKE 'Goibibo%'
OR
f.narration LIKE '%Cultfit%'
OR
f.narration LIKE '%Yatra%'
OR
f.narration LIKE '%Zee5%'
OR
f.narration LIKE '%Myntra%'
OR
f.narration LIKE '%Bewakoof%'
OR
f.narration LIKE '%Indigo%'
OR
f.narration LIKE '%Tata Sky%'
OR
f.narration LIKE 'TataSky%'
OR
f.narration LIKE '%Big Basket%'
OR
f.narration LIKE '%BigBasket%'
OR
f.narration LIKE '%SonyLiv%'
OR
f.narration LIKE '%Dunzo%'
OR
f.narration LIKE '%Dmart%'
OR
f.narration LIKE '%JIOMART%'
OR
f.narration LIKE '%Freshtohome%'
OR
f.narration LIKE '%FRESHTOWN%'
OR
f.narration LIKE '%ErosNow%'
OR
f.narration LIKE '%CLEARDEKHO%'
OR
f.narration LIKE '%BookMyShow%'
OR
f.narration LIKE '%Book My Show%'

OR
f.narration LIKE '%BIGTREEENTERTAINMENT%'
OR
f.narration LIKE '%EMTEX%'
OR
f.narration LIKE '%EMTICI%'
OR
f.narration LIKE '%EMTEL%'
OR
f.narration LIKE '%Eazy Diner%'
OR
f.narration LIKE '%EazyDiner%'
OR

f.narration LIKE '%GoMechanic%'
OR
f.narration LIKE '%Go Mechanic%'
OR

f.narration LIKE '%ClearTax%'
OR
f.narration LIKE '%Clear Tax%'
OR

f.narration LIKE '%BeSoulfull%'
OR
f.narration LIKE '%Be Soulfull%'
OR

f.narration LIKE '%The Man Company%'
OR
f.narration LIKE '%TheManCompany%'
OR

f.narration LIKE '%The Earth Reserve%'
OR
f.narration LIKE '%TheEarthReserve%'
OR

f.narration LIKE '%Flipkart%'
OR
f.narration LIKE '%Amazon%'
OR
f.narration LIKE '%Wakefit%'
OR

f.narration LIKE '%Health&Glow%'
OR
f.narration LIKE '%Health & Glow%'
OR

f.narration LIKE '%BigFlex%'
OR
f.narration LIKE '%Big Flex%'
OR

f.narration LIKE '%MyGlamm%'
OR
f.narration LIKE '%My Glamm%'
OR

f.narration LIKE '%Faces Canada%'
OR
f.narration LIKE '%FacesCanada%'
OR

f.narration LIKE '%Leaf Studios%'
OR
f.narration LIKE '%LeafStudios%'
OR

f.narration LIKE '%ArvindNnow%'
OR
f.narration LIKE '%Zoomin%'
OR
f.narration LIKE '%Beardo%'
OR

f.narration LIKE '%Ferns & Petals%'
OR
f.narration LIKE '%Ferns N Petals%'
OR

f.narration LIKE '%TOI%'
OR
f.narration LIKE '%Times of India%'
OR
f.narration LIKE '%TimesofIndia%'
OR
f.narration LIKE '%TheTimesofIndia%'
OR
f.narration LIKE '%The Times of India%'
OR

f.narration LIKE '%MakemyTrip%'
OR
f.narration LIKE '%Make my Trip%'
OR

f.narration LIKE '%Ixigo%'
OR
f.narration LIKE '%Abhi Bus%'
OR
f.narration LIKE '%AbhiBus%'
OR

f.narration LIKE '%Happy Easy Go%'
OR
f.narration LIKE '%HappyEasyGo%'
OR
f.narration LIKE '%Intermiles%'
OR

f.narration LIKE '%Rapido%'
OR
f.narration LIKE '%Travolook%'
OR

f.narration LIKE '%Paytm Flights%'
OR
f.narration LIKE '%PaytmFlights%'
OR

f.narration LIKE '%Milk Basket%'
OR
f.narration LIKE '%MilkBasket%'

OR
f.narration LIKE '%Clear Trip%'
OR
f.narration LIKE '%ClearTrip%'

OR
f.narration LIKE '%Oyo Hotels%'
OR
f.narration LIKE '%Oyo%'

OR
f.narration LIKE '%Rostaa%'

OR
f.narration LIKE '%Go Air%'
OR
f.narration LIKE '%GoAir%'

OR
f.narration LIKE '%Air Vistara%'
OR
f.narration LIKE '%AirVistara%'

OR
f.narration LIKE '%White Hat Jr%'
OR
f.narration LIKE '%White Hat%'
OR
f.narration LIKE '%WhiteHat%'
OR

f.narration LIKE '%Gaana%'
OR

f.narration LIKE '%Toppr%'
OR

f.narration LIKE '%The Sleep Company%'
OR
f.narration LIKE '%TheSleepCompany%'
OR
f.narration LIKE '%The Sleep%'



***********RETENSION CUSTOMERS***************


SELECT count(DISTINCT a.mobile_number),date(b.txn_date) AS First_TXN,DATE(a.onboard_date) AS onboard_date,f.narration,b.txn_code
from udio_wallet.ib_creditline_application a
join udio_wallet.dw_credit_transaction b on a.application_id=b.credit_application_id
join udio_wallet.dw_card_transaction f
ON a.consumer_id = f.consumer_id
join (select min(id) as id from udio_wallet.dw_credit_transaction where product_type='supersaver'
group by credit_application_id) c on b.id=c.id
where a.loan_type='daily'
and date(b.txn_date) BETWEEN '2022-01-01' and '2022-01-31'
and f.narration LIKE '%AMAZON%'
OR
f.narration LIKE '%Zomato%'
OR
f.narration LIKE '%Snapdeal%'
OR
f.narration LIKE '%Grofers%'
OR
f.narration LIKE '%Tata Cliq%'
OR
f.narration LIKE 'TataCliq%'
OR
f.narration LIKE 'Swiggy%'
OR
f.narration LIKE '%Ajio%'
OR
f.narration LIKE '%Dineout%'
OR
f.narration LIKE 'Licious%'
OR
f.narration LIKE '%Shopclues%'
OR
f.narration LIKE '%MMT%'
OR
f.narration LIKE '%Goibibo%'
OR
f.narration LIKE 'Goibibo%'
OR
f.narration LIKE '%Cultfit%'
OR
f.narration LIKE '%Yatra%'
OR
f.narration LIKE '%Zee5%'
OR
f.narration LIKE '%Myntra%'
OR
f.narration LIKE '%Bewakoof%'
OR
f.narration LIKE '%Indigo%'
OR
f.narration LIKE '%Tata Sky%'
OR
f.narration LIKE 'TataSky%'
OR
f.narration LIKE '%Big Basket%'
OR
f.narration LIKE '%BigBasket%'
OR
f.narration LIKE '%SonyLiv%'
OR
f.narration LIKE '%Dunzo%'
OR
f.narration LIKE '%Dmart%'
OR
f.narration LIKE '%JIOMART%'
OR
f.narration LIKE '%Freshtohome%'
OR
f.narration LIKE '%FRESHTOWN%'
OR
f.narration LIKE '%ErosNow%'
OR
f.narration LIKE '%CLEARDEKHO%'
OR
f.narration LIKE '%BookMyShow%'
OR
f.narration LIKE '%Book My Show%'
OR
f.narration LIKE '%EMTEX%'
OR
f.narration LIKE '%EMTICI%'
OR
f.narration LIKE '%EMTEL%'
OR
f.narration LIKE '%Eazy Diner%'
OR
f.narration LIKE '%EazyDiner%'
OR

f.narration LIKE '%GoMechanic%'
OR
f.narration LIKE '%Go Mechanic%'
OR

f.narration LIKE '%ClearTax%'
OR
f.narration LIKE '%Clear Tax%'
OR

f.narration LIKE '%BeSoulfull%'
OR
f.narration LIKE '%Be Soulfull%'
OR

f.narration LIKE '%The Man Company%'
OR
f.narration LIKE '%TheManCompany%'
OR

f.narration LIKE '%The Earth Reserve%'
OR
f.narration LIKE '%TheEarthReserve%'
OR

f.narration LIKE '%Flipkart%'
OR
f.narration LIKE '%Amazon%'
OR
f.narration LIKE '%Wakefit%'
OR

f.narration LIKE '%Health&Glow%'
OR
f.narration LIKE '%Health & Glow%'
OR

f.narration LIKE '%BigFlex%'
OR
f.narration LIKE '%Big Flex%'
OR

f.narration LIKE '%MyGlamm%'
OR
f.narration LIKE '%My Glamm%'
OR

f.narration LIKE '%Faces Canada%'
OR
f.narration LIKE '%FacesCanada%'
OR

f.narration LIKE '%Leaf Studios%'
OR
f.narration LIKE '%LeafStudios%'
OR

f.narration LIKE '%ArvindNnow%'
OR
f.narration LIKE '%Zoomin%'
OR
f.narration LIKE '%Beardo%'
OR

f.narration LIKE '%Ferns & Petals%'
OR
f.narration LIKE '%Ferns N Petals%'
OR

f.narration LIKE '%TOI%'
OR
f.narration LIKE '%Times of India%'
OR
f.narration LIKE '%TimesofIndia%'
OR
f.narration LIKE '%TheTimesofIndia%'
OR
f.narration LIKE '%The Times of India%'
OR

f.narration LIKE '%MakemyTrip%'
OR
f.narration LIKE '%Make my Trip%'
OR

f.narration LIKE '%Ixigo%'
OR
f.narration LIKE '%Abhi Bus%'
OR
f.narration LIKE '%AbhiBus%'
OR

f.narration LIKE '%Happy Easy Go%'
OR
f.narration LIKE '%HappyEasyGo%'
OR
f.narration LIKE '%Intermiles%'
OR

f.narration LIKE '%Rapido%'
OR
f.narration LIKE '%Travolook%'
OR

f.narration LIKE '%Paytm Flights%'
OR
f.narration LIKE '%PaytmFlights%'
OR

f.narration LIKE '%Milk Basket%'
OR
f.narration LIKE '%MilkBasket%'

OR
f.narration LIKE '%Clear Trip%'
OR
f.narration LIKE '%ClearTrip%'

OR
f.narration LIKE '%Oyo Hotels%'
OR
f.narration LIKE '%Oyo%'

OR
f.narration LIKE '%Rostaa%'

OR
f.narration LIKE '%Go Air%'
OR
f.narration LIKE '%GoAir%'

OR
f.narration LIKE '%Air Vistara%'
OR
f.narration LIKE '%AirVistara%'

OR
f.narration LIKE '%White Hat Jr%'
OR
f.narration LIKE '%White Hat%'
OR
f.narration LIKE '%WhiteHat%'
OR

f.narration LIKE '%Gaana%'
OR

f.narration LIKE '%Toppr%'
OR

f.narration LIKE '%The Sleep Company%'
OR
f.narration LIKE '%TheSleepCompany%'
OR
f.narration LIKE '%The Sleep%'
GROUP BY First_TXN,onboard_date,f.narration,b.txn_code
HAVING COUNT(b.txn_code) > 1;




********R&D because 2 TRANSACTION was coming FROM same DATE********

SELECT * FROM udio_wallet.ib_creditline_application a
WHERE a.mobile_number = '7697964393' 

output needed - 1900270421095037330 -- consumerID

SELECT * FROM udio_wallet.dw_transaction 
WHERE consumer_id = '1900270421095037330'  -- previous transaction is also listed

SELECT * FROM udio_wallet.dw_credit_transaction a
WHERE a.mobile_number = '7697964393'  --- only 6jan22 trasaction,no previous transaction

SELECT * FROM udio_wallet.dw_card_transaction 
WHERE consumer_id = '1900270421095037330'      ---  only 6jan22 transaction, no previous transactions



2. Amount was also same Rs 121.20. for 6jan22

