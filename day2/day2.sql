-- Need to run in SQLCMD mode.

:setvar path "C:\Users\TEMPERED-USER\source\repos\aoc2019\day2"

--CREATE SCHEMA day2;

GO

DROP TABLE IF EXISTS day2.opcodes;

GO

CREATE TABLE day2.opcodes (
	position int PRIMARY KEY IDENTITY(0,1),
	opcode int
);

GO

-- 250702 is wrong
:r $(path)\day2_part1_input.sql
--:r $(path)\day2_part1_test1_input.sql
--:r $(path)\day2_part1_test2_input.sql

GO

-- Modify inputs here.  80, 18 gives the answer to part 2 by trial-and-error.
UPDATE day2.opcodes
SET opcode = 12
WHERE position = 1;

UPDATE day2.opcodes
SET opcode = 2
WHERE position = 2;

GO

--SELECT *
--FROM day2.opcodes;

GO

DECLARE @row_number int = -1;
DECLARE @cursor cursor;
DECLARE @opcode int;
-- These inputs change from position to value.
DECLARE @input_1 int;
DECLARE @input_2 int;
DECLARE @output_position int;
DECLARE @output_value int;
DECLARE @nounverb int = NULL;
BEGIN
	SET @cursor = CURSOR FOR
	SELECT opcode
	FROM day2.opcodes;

	OPEN @cursor;

	PRINT 'Starting.  Fetch status is ' + CAST(@@FETCH_STATUS AS varchar(256));
	--SELECT @@FETCH_STATUS AS PRELIM_FETCH_STATUS;

	WHILE @@FETCH_STATUS = 0 OR @row_number = -1
	BEGIN
		SET @row_number = @row_number + 1;
		FETCH NEXT FROM @cursor
		INTO @opcode;
		PRINT 'Row number ' + CAST(@row_number AS varchar(256)) + ' opcode ' + CAST(@opcode AS varchar(256));

		SET @row_number = @row_number + 1;
		FETCH NEXT FROM @cursor
		INTO @input_1;
		PRINT 'Row number ' + CAST(@row_number AS varchar(256)) + ' input 1 position ' + CAST(@input_1 AS varchar(256));

		SET @row_number = @row_number + 1;
		FETCH NEXT FROM @cursor
		INTO @input_2;
		PRINT 'Row number ' + CAST(@row_number AS varchar(256)) + ' input 2 position ' + CAST(@input_2 AS varchar(256));

		SET @row_number = @row_number + 1;
		FETCH NEXT FROM @cursor
		INTO @output_position;
		PRINT 'Row number ' + CAST(@row_number AS varchar(256)) + ' output position ' + CAST(@output_position AS varchar(256));
		
		-- Change over inputs from positional to value.
		SET @input_1 = (
			SELECT opcode
			FROM day2.opcodes
			WHERE position = @input_1
		);
		SET @input_2 = (
			SELECT opcode
			FROM day2.opcodes
			WHERE position = @input_2
		);

		IF @opcode = 99 BREAK;
		IF @opcode = 1
		BEGIN
			SET @output_value = @input_1 + @input_2;
		END;
		ELSE IF @opcode = 2
		BEGIN
			SET @output_value = @input_1 * @input_2;
		END;
		ELSE
		BEGIN
			PRINT 'Unknown opcode: ' + CAST(@opcode AS varchar(256));
			THROW 50000, 'Unknown opcode', 0;
		END;

		BEGIN TRANSACTION;

		UPDATE day2.opcodes
		SET opcode = @output_value
		WHERE position = @output_position;

		COMMIT;
	END;
END;

GO

DECLARE @input int = (SELECT 100*opcode FROM day2.opcodes WHERE position = 1) + (SELECT opcode FROM day2.opcodes WHERE position = 2);
DECLARE @output int = (SELECT opcode FROM day2.opcodes WHERE position = 0);

SELECT 'output' register, @output value
UNION ALL
SELECT 'input', @input;

-- 1202 / 3166704 = x / 19690720
-- 19690720 * 1202 / 3166704 = x

GO

--WITH opcode_map AS
--(
--	SELECT opcodes_1.opcode opcode_1,
--		opcodes_2.opcode opcode_2,
--		opcodes_3.opcode opcode_3,
--		opcodes_4.opcode opcode_4
--	FROM day2.opcodes opcodes_1
--		JOIN day2.opcodes opcodes_2
--		ON opcodes_1.position+1 = opcodes_2.position
--		JOIN day2.opcodes opcodes_3
--		ON opcodes_2.position+1 = opcodes_3.position
--		JOIN day2.opcodes opcodes_4
--		ON opcodes_3.position+1 = opcodes_4.position
--	WHERE opcodes_1.position % 4 = 0
--)
--UPDATE day2.opcodes
--SET opcode = (
--	CASE opcode_1
--	WHEN 1 THEN opcode_2 + opcode_3
--	WHEN 2 THEN opcode_2 + opcode_3
--	END)
--FROM opcode_map
--WHERE position = opcode_map.opcode_4
--	AND position <> 99;

--SELECT *
--FROM day2.opcodes;