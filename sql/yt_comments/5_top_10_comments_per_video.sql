/*
 Top 10 comments per video based on the most amount of likes
*/

-- First, we create `top_comments` a CTE (=Common Table Expression) that we will reuse
-- later on. CTEs are commonly used in more complex queries. They are like virtual tables
-- that get created on the fly for the purpose of the given query,
-- and once the query completes, they disappear 
-- and need to be re-created if we need them again
with top_comments as (
  select
    video_title,                                
    comment,
    likes,
    ROW_NUMBER() over (
      -- the row_number is applied on virtual parts of the yt_comments table. 
      -- Each part only has records that have a specific video_title
      partition by video_title
      -- We order the partition by likes, so `1` is assigned to 
      -- the comment with most likes in each video_title partition
      order by likes desc
    ) as rn
  from yt_comments
)

select
  video_title,
  comment,
  likes,
  rn
from top_comments
-- We only want the top 10 comments per `video_title` partition:
where rn <= 10
-- Notice that this final result set is ordered by two columns
-- to ensure that the results are not only sorted by the `video_title` but also by their rank.
-- Alternatively, we could do `order by video_title, likes desc`
order by video_title, rn;
