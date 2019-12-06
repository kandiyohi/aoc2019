
-- Determine that @@FETCH_STATUS starts at 0.
DECLARE @cursor cursor;
BEGIN
	SET @cursor = CURSOR FOR
	SELECT opcode FROM day2.opcodes;

	SELECT @@FETCH_STATUS;
END;