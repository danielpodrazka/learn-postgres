/*
 First 10 comments per video based on posted_time
*/

with first_comments as (
    select
        video_title,
        comment,
        posted_time,
        ROW_NUMBER() over (
            -- We partition the `yt_comments` table by `video_title`,
            -- so that the row number is assigned within each video_title group.
            partition by video_title
            -- We order the partitions by `posted_time` in ascending order,
            -- so that the earliest comment in each `video_title` partition gets row number 1.
            order by posted_time
        ) as rn
    from yt_comments
)
select
    video_title,
    comment,
    posted_time,
    rn
from first_comments
-- We only want the first 5 comments per `video_title` partition.
where rn <= 10
-- We order the final result set by `video_title` and then by `rn`,
-- to ensure that the results are sorted by video_title and their chronological order.
order by video_title, rn;