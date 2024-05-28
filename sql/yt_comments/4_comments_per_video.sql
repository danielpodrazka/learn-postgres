/*
Amount of comments per video 
*/

select
  count(*) as amount_of_comments,
  video_title
from yt_comments
group by video_title
-- ordered by the video with the most comments first
order by amount_of_comments desc;
