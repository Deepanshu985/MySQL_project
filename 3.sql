-- Q1. find how much amount spent by each custmer on artists? write a query to return customer name,
-- artist name and toptal spent

with best_selling_artist AS (
 select artist.artist_id as artist_id, artist.name as artist_name,
 sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
 from invoice_line
 join track on track.track_id=invoice_line.track_id
 join album on album.﻿album_id=track.album_id
 join artist on artist.artist_id=album.artist_id
 group by artist_id, artist_name
 order by total_sales desc
 limit 1)

select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
 sum(il.unit_price*il.quantity) as amount_spent
 from invoice as i
 join customer as c on c.customer_id= i.customer_id
 join invoice_line as il on il.invoice_id=i.invoice_id
 join track as t on t.track_id=il.track_id
 join album on album.﻿album_id=t.album_id
 join best_selling_artist as bsa on bsa.artist_id = album.artist_id
 group by c.customer_id, c.first_name, c.last_name, bsa.artist_name
 order by amount_spent desc;
 
 -- Q2. we want to find out the most popular music genre for each country. we determice the most popular genre
 -- as the genre with the highest amount of purchases. write a query that returns each country along with the 
 -- top genre. for countries where the max number of purchases is shared return all genres.
 
with recursive customer_with_country as(
select customer.customer_id, first_name, last_name, billing_country, SUM(total) as total_spending
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 2,3 desc),

country_max_spending as(
select billing_country, MAX(total_spending) AS max_spending
from customer_with_country
group by billing_country)

select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
from customer_with_country as cc
join country_max_spending as cs
on cc.billing_country = cs.billing_country
where cc.total_spending = cs.max_spending
order by 1;

-- Q3. Write a query that determines the customer that has spent the most on music for each country.
-- write a query that returns the country along with the top customer and how much they spent.
-- for countries where the top amount spent is shared, provide all customers who spent this amount

WITH customer_with_country as(
select customer.customer_id, first_name, last_name, billing_country, SUM(total) as total_spending,
row_number() over (partition by billing_country order by sum(total) desc) as RowNo
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 4 asc, 5 desc)

select * from customer_with_country where RowNo <= 1;
