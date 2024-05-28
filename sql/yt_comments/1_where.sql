/*
Demonstrating select, from, where, and order by operations
*/

select
  commenter_s_name,
  comment,
  likes
from yt_comments
where likes > 1000
order by likes desc;
