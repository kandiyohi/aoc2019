-- Need to use SQLCMD mode.

-- Set this to the base path for all the things.
:setvar base_path "C:\Users\TEMPERED-USER\source\repos\aoc2019"

GO

--CREATE DATABASE AOC_2019;
--USE AOC_2019;

GO

-- CREATE SCHEMA day1;

DROP TABLE IF EXISTS day1.module;

GO

CREATE TABLE day1.module (
	module_id int PRIMARY KEY IDENTITY(1,1),
	mass bigint,
	fuel_needed AS mass / 3 - 2
);

GO

:r $(base_path)\day1_input.sql

GO

SELECT SUM(fuel_needed) AS total_fuel_needed
FROM day1.module;