CREATE OR REPLACE FUNCTION RANDOM_BETWEEN(minimum integer, maximum integer)
RETURNS INTEGER
AS
$$
    SELECT CAST(FLOOR(RANDOM() * (maximum - minimum + 1) + minimum) AS INTEGER);
$$ LANGUAGE SQL;



CREATE OR REPLACE FUNCTION RANDOM_STRING(generated_length integer)
RETURNS VARCHAR
AS
$$
  WITH RECURSIVE cte(i, generated) AS (
    SELECT 1, ''
    UNION ALL
    SELECT i+1, generated || (ARRAY['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'])[RANDOM_BETWEEN(1, 62)]
    FROM cte WHERE LENGTH(generated) < generated_length
  )
  SELECT generated FROM cte ORDER BY i DESC LIMIT 1;
$$ LANGUAGE SQL;



CREATE OR REPLACE FUNCTION LUCK_INTEGER(win_percentage integer, win_value integer, lose_value integer)
RETURNS INTEGER
AS
$$
    SELECT CASE WHEN (RANDOM_BETWEEN(1, 100) <= win_percentage) THEN win_value ELSE lose_value END;
$$ LANGUAGE SQL;
