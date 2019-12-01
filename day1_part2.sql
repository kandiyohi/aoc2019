-- Need to use SQLCMD mode.

-- Set this to the base path for all the things.
:setvar base_path "C:\Users\TEMPERED-USER\source\repos\aoc2019"

GO

--CREATE DATABASE AOC_2019;
--USE AOC_2019;

GO

-- CREATE SCHEMA day1;

GO

DROP TABLE IF EXISTS day1.module;

GO

-- Function for calculating the column.
DROP FUNCTION IF EXISTS day1.calculate_fuel_mass;

GO

CREATE FUNCTION day1.calculate_fuel_mass(@object_mass bigint)
RETURNS bigint
AS
BEGIN
	-- This is for the original solution, not the compound one.
	--RETURN @object_mass / 3 - 2;
	DECLARE @temp_mass TABLE (
		id int IDENTITY(1,1) PRIMARY KEY,
		mass bigint,
		fuel_needed AS mass / 3 - 2
	);
	INSERT INTO @temp_mass (mass) VALUES (@object_mass);
	-- Keep inserting until our calculated mass is non-positive.  This is
	-- probably a performance nightmare to someone somewhere.
	WHILE (SELECT TOP 1 fuel_needed FROM @temp_mass ORDER BY id DESC) > 0
	BEGIN
		INSERT INTO @temp_mass
		SELECT TOP 1 fuel_needed
		FROM @temp_mass ORDER BY id DESC;
	END;
	RETURN (SELECT SUM(fuel_needed) FROM @temp_mass WHERE fuel_needed > 0);
END;

GO

CREATE TABLE day1.module (
	module_id int PRIMARY KEY IDENTITY(1,1),
	mass bigint,
	fuel_needed AS day1.calculate_fuel_mass(mass)
);

GO

:r $(base_path)\day1_input.sql

GO

SELECT SUM(fuel_needed) AS total_fuel_needed
FROM day1.module;

SELECT module_id, mass, fuel_needed, CAST(mass AS float) / CAST(fuel_needed AS float) AS calculated, mass - fuel_needed * 2 AS theoretical
FROM day1.module
ORDER BY calculated DESC;