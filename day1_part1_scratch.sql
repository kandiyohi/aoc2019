-- Test if division truncates properly.  If we needed to round up or
-- down, we'd convert to float and add .5.  If we're using banker's
-- rounding, good luck?
SELECT '4 / 3' AS Expression, 4 / 3 AS Result
UNION ALL
-- Test example 1 expression
SELECT '12 / 3 - 2', 12 / 3 - 2
UNION ALL
-- Test example 2 expression
SELECT '14 / 3 - 2', 14 / 3 - 2;


-- Test examples

-- CREATE SCHEMA day1;

DROP TABLE IF EXISTS day1.module;

CREATE TABLE day1.module (
	module_id int PRIMARY KEY IDENTITY(1,1),
	mass bigint,
	fuel_needed AS mass / 3 - 2
);

INSERT INTO day1.module (mass) VALUES
	(12),
	(14),
	(1969),
	(100756);

SELECT *
FROM day1.module;