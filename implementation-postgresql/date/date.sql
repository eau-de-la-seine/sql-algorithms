CREATE OR REPLACE FUNCTION GENERATE_DATES(date_from CHAR(10), date_to CHAR(10))
RETURNS TABLE(date date)
AS
$$
  SELECT date_trunc('day', generated_dates)::date AS date
  FROM generate_series(
    date_from::timestamp,
    date_to::timestamp,
    '1 day'::interval
  ) generated_dates;
$$ LANGUAGE SQL;


