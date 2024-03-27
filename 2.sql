-- Q1. write a query to return the email, first name, last name & genre of all rock music listeners.
-- return your list ordered alphabetically by email starting with A


select distinct email, first_name, Last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
select track_id from track 
join genre on track.genre_id=genre.genre_id
where genre.name like 'rock')
order by email;

-- Q2. Let's invite the artists who have written the most rock music in our dataset. write a query that
-- returns the artist name and total track count of the top 10 rock bands.

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.﻿album_id= track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'rock'
group by artist.artist_id, artist.name
order by number_of_songs desc
limit 10;

-- Q3. Return all the track names that have a song length longer than the average song length.
-- return the name and milliseconds for each track. order by the song length with the longest songs listed 
-- first.

select name, milliseconds
from track
where milliseconds > (
select avg(milliseconds) as avg_lenth
from track)
order by milliseconds desc;

