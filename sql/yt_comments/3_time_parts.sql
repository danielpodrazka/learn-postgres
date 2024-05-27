-- `distinct on (posted_time::date)` restricts the result set to one record per date, so we can better see how `posted_day` and `posted_month` changes
select distinct on (posted_time::date)
  posted_time,
  -- by casting to date we create a date object and loose information about the time during the date
  posted_time::date AS posted_time_date,
  -- date_part can be used to extract year/month/day from a date object
  date_part('year', posted_time::date) as posted_year,
  date_part('month', posted_time::date) as posted_month,
  date_part('day', posted_time::date) as posted_day,
  -- extract can be used to extract even more parts. Here we cast to timestamptz (timestamp with timezone) which is the standard way of keeping time in PostgreSQL
  extract(hour from posted_time::timestamptz) as posted_hour,
  extract(minute from posted_time::timestamptz) as posted_minute,
  extract(second from posted_time::timestamptz) as posted_second,
  comment
from yt_comments
-- we order the records so that the comment with the latest date shows up on the first row
order by posted_time::date desc