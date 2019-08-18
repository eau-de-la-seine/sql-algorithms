/**
How to use it:
	SELECT COORDINATES_REPARTITION(33333, -720, 0, 'CURVE_FORMULA');

* Your "CURVE_FORMULA" is a math function like `f(x) = 1.4^(0.09x)`
* You can name your "CURVE_FORMULA" as you wish but it must have 1 coordinateX integer parameter and returns an array of DECIMAL
* The number of element in the return value of COORDINATES_REPARTITION is the difference between `fromX` and `toX` paramaters

Inspired by my Curve class in Java
*/

-- Demo function "CURVE_FORMULA"
CREATE OR REPLACE FUNCTION CURVE_FORMULA(x INTEGER)
RETURNS DECIMAL
AS $$
	SELECT POWER(1.4, 0.09 * x);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION COORDINATES_REPARTITION(
	nbEvents INTEGER,
	fromX INTEGER,
	toX INTEGER,
	formulaName VARCHAR
)
RETURNS DECIMAL[]
AS $$
DECLARE
	-- nbPoints INTEGER;
	konstant DECIMAL;
	denominator DECIMAL;
	x INTEGER;
	formulaValue DECIMAL;
	formulaValues DECIMAL[] DEFAULT '{}';
	coordinates DECIMAL[] DEFAULT '{}';
BEGIN
	-- Checks
	IF nbEvents < 1 THEN
		RAISE EXCEPTION '`nbEvents` must be superior to 0'; 
	ELSIF fromX > toX THEN
		RAISE EXCEPTION '`toX` must be superior to `fromX`';
	ELSIF formulaName = NULL OR formulaName = '' THEN
		RAISE EXCEPTION '`formula` must not be empty or null';
	END IF;

	-- nbPoints := CASE WHEN fromX > 0 THEN toX - fromX + 1 ELSE -fromX + toX + 1;

	denominator := 0;
	x := fromX;
	WHILE x <= toX
	LOOP
		EXECUTE format('SELECT %s(%s)', formulaName, x) INTO formulaValue;
		formulaValues := array_append(formulaValues, formulaValue);
		denominator := denominator + formulaValue;
		x := x + 1;
	END LOOP;

	konstant := nbEvents / denominator;

	FOREACH formulaValue IN ARRAY formulaValues
	LOOP 
		coordinates := array_append(coordinates, konstant * formulaValue);
	END LOOP;

	RETURN coordinates;

END;
$$
LANGUAGE plpgsql;
