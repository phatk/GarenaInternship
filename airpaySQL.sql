# Users who bought Major Cineplex tickets
SELECT o.order_id , o.uid, o.item_amount,  DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.payment_channel_id = 20041 AND o.status = '8'

# Churn 30 for any transactions
SELECT o.order_id , o.uid, DATE(FROM_UNIXTIME(o.valid_time)) AS date, c.name 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND 
o.valid_time < UNIX_TIMESTAMP('2015-05-26 00:00:00') AND 
(o.uid NOT IN 
	(select ord.uid from `order_tab` as ord
	 WHERE ord.status = '8' AND 
	 ord.valid_time BETWEEN UNIX_TIMESTAMP('2015-04-25 00:00:00') AND 
	 UNIX_TIMESTAMP('2015-05-26 00:00:00')))

# Churn 30 for Garena Shell or Major
SELECT o.order_id , o.uid, DATE(FROM_UNIXTIME(o.valid_time)) AS date, c.name 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.payment_channel_id IN (20000,20041) AND o.status = '8' AND 
o.valid_time < UNIX_TIMESTAMP('2015-05-26 00:00:00') AND 
(o.uid NOT IN 
	(select ord.uid from `order_tab` as ord
	 WHERE ord.payment_channel_id IN (20000,20041) AND ord.status = '8' AND 
	 ord.valid_time BETWEEN UNIX_TIMESTAMP('2015-04-25 00:00:00') AND 
	 UNIX_TIMESTAMP('2015-05-26 00:00:00')))

# Count new user for each day 
(SELECT count(distinct(o.uid)) , DATE(FROM_UNIXTIME(o.valid_time)) FROM `order_tab` AS o INNER JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.payment_channel_id = 20041 AND o.status = '8' AND o.valid_time = 
	(SELECT min(valid_time) 
		FROM `order_tab` where `uid` = o.uid AND status = '8') GROUP BY DATE(FROM_UNIXTIME(o.valid_time)))

# UserID (that bought MajorCineplex) for Push Notification
SELECT distinct(o.uid) FROM `order_tab` AS o 
	WHERE o.payment_channel_id = 20041 AND o.status = '8'

# Major Cinexplex first time bought THIS weekend
SELECT o.uid FROM `order_tab` AS o 
WHERE valid_time BETWEEN UNIX_TIMESTAMP('2015-06-27 10:00:00') AND UNIX_TIMESTAMP('2015-06-29 00:00:00')

# FirstTime Garena500 shells free:
SELECT o.order_id , o.uid, o.item_amount, c.name,  DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.uid IN
(SELECT o.uid FROM `order_tab` AS o 
WHERE o.payment_channel_id = 20001 AND o.status = '8' AND o.valid_time = 
	(SELECT min(valid_time) 
		FROM `order_tab` where `uid` = o.uid AND status = '8'))

# FirstTime Major free ticket
SELECT o.order_id , o.uid, o.item_amount, c.name,  DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.uid IN
(SELECT o.uid FROM `order_tab` AS o 
WHERE o.payment_channel_id = 20041 AND o.status = '8' AND o.valid_time = 
	(SELECT min(valid_time) 
		FROM `order_tab` where `uid` = o.uid AND status = '8'))

# Mobile Airtime Top-Up ------------------
# AIS: 20011
# DTAC: 20013
# True: 20015
SELECT o.order_id , o.uid, o.currency_amount, c.name,  DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.uid IN
(SELECT o.uid FROM `order_tab` AS o 
WHERE o.payment_channel_id IN (20011,20013,20015) AND o.status = '8')

# Maroon 5 Query [LAST 2 WEEK]
SELECT o.order_id , o.uid, o.item_amount,  DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
	WHERE o.payment_channel_id = 20041 AND o.status = '8' AND
	 o.uid IN 
	(SELECT ord.uid from `order_tab` as ord WHERE ord.payment_channel_id = 20041 AND ord.status = '8' 
		AND  ord.valid_time BETWEEN UNIX_TIMESTAMP('2015-06-19 00:00:00') AND  UNIX_TIMESTAMP('2015-06-22 00:00:00')
	)

# Maroon 5 participants - used to find in Excel the winner with most purchases
SELECT o.order_id , o.uid, o.item_amount,  DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
	WHERE o.payment_channel_id = 20041 AND o.status = '8' 
		AND o.valid_time BETWEEN UNIX_TIMESTAMP('2015-07-03 00:00:00') AND  UNIX_TIMESTAMP('2015-07-06 00:00:00'))

# Users Spendings # Not include Cash, Cash transfer, Cash Withdrawal
SELECT o.uid, SUM(o.currency_amount), Count(o.order_id) From `order_tab` as o WHERE o.status = '8' AND o.payment_channel_id NOT IN (21000,21001,21002)
GROUP BY o.uid

# AirTime Return #
SELECT o.order_id , o.uid, o.currency_amount, c.name, DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
	WHERE  o.payment_channel_id IN (20011, 20013, 20015) AND o.status = '8'
# Cash Transfer Return #
SELECT o.order_id , o.uid, o.currency_amount, c.name, DATE(FROM_UNIXTIME(o.valid_time)) AS date 
FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
	WHERE  o.payment_channel_id IN (21001) AND o.status = '8' 

# Users spending per month:June
SELECT o.uid, SUM(o.currency_amount), Count(o.order_id) From `order_tab` as o WHERE o.status = '8' AND o.payment_channel_id NOT IN (21000,21001,21002) AND 
o.valid_time BETWEEN UNIX_TIMESTAMP('2015-06-01 00:00:00') AND UNIX_TIMESTAMP('2015-07-01 00:00:00')
GROUP BY o.uid 

## get user with shells once
SELECT o.uid, count(o.order_id) from  `order_tab` AS o WHERE o.payment_channel_id IN (20001) AND o.status = '8' AND 	o.valid_time BETWEEN UNIX_TIMESTAMP('2015-01-01 00:00:00') AND UNIX_TIMESTAMP('2015-06-30 23:59:00')
GROUP BY o.uid HAVING count(o.order_id) = 1

##########  Rebate (P'Leng) ###########
## Garena shells
SELECT o.order_id , o.uid, o.currency_amount, c.name, DATE(FROM_UNIXTIME(o.valid_time)) AS date FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.payment_channel_id = 20001

## aCash ASIASOFT 20025
SELECT o.order_id , o.uid, o.currency_amount, c.name, DATE(FROM_UNIXTIME(o.valid_time)) AS date FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.payment_channel_id = 20025

## Cookiecard Gump 20039
SELECT o.order_id , o.uid, o.currency_amount, c.name, DATE(FROM_UNIXTIME(o.valid_time)) AS date FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.payment_channel_id = 20039

## CubiCash Gump 20035
SELECT o.order_id , o.uid, o.currency_amount, c.name, DATE(FROM_UNIXTIME(o.valid_time)) AS date FROM `order_tab` AS o 
	LEFT JOIN `channel_tab` AS c ON o.payment_channel_id = c.channel_id 
WHERE o.status = '8' AND o.payment_channel_id = 20035

## D Card - Gump 20023
## Facebook MOL 20019
## GooglePlay BNB 20027
## iTunes BNB 20029
## Jam Card - Gump 20033
## Line - MOL 20017
## Steam - Unitry 20021
## TOT - Gump 20037
## Winner - Gump 20031
