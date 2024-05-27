select 
  '2021-06-13T06:11:58Z' as posted_time,
  -- you can cast the value to a different datatype if it's compatible:
  '2021-06-13T06:11:58Z'::date as posted_date,
  -- this works with many date types:
  'true' as true_string,
  'true'::bool as true_bool,
  't'::bool as true_bool_2,
  1::bool as true_bool_3,
  0::bool as false_bool,
  10.4 as float_no_rounding,
  -- when casting float to int, normal rouding rules apply:
  10.4::int as int_round_down,
  10.5::int as int_round_up
  
