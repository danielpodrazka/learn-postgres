select
  commenter_s_name,
  comment,
  likes
from yt_comments
where likes > 1000;
