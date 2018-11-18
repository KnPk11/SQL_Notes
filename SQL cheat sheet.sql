-- Last update: 2018-11-12 13:00

				--========== COMMANDS ==========--
-- SELECT. Display all rows in a table
	SELECT * FROM table1
	
-- DISTINCT. Display all distinct rows in a table
	SELECT DISTINCT column1, column2
	FROM table1

-- SELECT TOP. Display the first n number of rows of a SELECT query
	SELECT TOP number/percent column1
	FROM table1

-- WHERE. Display rows according to a specific criteria
	SELECT * FROM table1
	WHERE column1 = 'value'
	
-- AND & OR. Display rows according to more than one criteria
	SELECT * FROM table
	WHERE column1 = 'value'
	AND column2 = 'value2' / OR column2 = 'value2'
	
-- ORDER BY. Sort the data by one or more columns.
	SELECT column1, column2
	FROM table1
	ORDER BY column1/integer ASC/DESC
	
-- LIKE. Use with a WHERE clause to search for a specific pattern in a column. pattern can be: % - wildcard for matching any string of any length, _ - match a single character of a strign, [charlist] 
-- sets and ranges of characters to match, [^charlist] or [!charlist] - match characters not specified in the brackets
	SELECT * FROM table1
	WHERE column1 LIKE 'pattern'

-- IN. Allows specifying multiple values in a WHERE clause.
	SELECT * FROM table1
	WHERE column1 IN (value1, value2, ...)
	
-- BETWEEN. Select values within a range.
	SELECT * FROM table1
	WHERE column1 BETWEEN value1 AND value2

-- AS. Used to temporarily rename a table or a column in a table
	SELECT column1 AS [new column name]
	FROM table1 AS [new table name]
	
-- JOIN. Join tables. Combine data from multiple tables based on a unifying criteria.
	INNER JOIN (JOIN) 		-- returns all rows with at least one match in both tables
	LEFT JOIN 				-- returns all rows from the left table, and the matched rows from the right table
	RIGHT JOIN 				-- returns all rows from the right table, and the matched rows from the left table
	FULL JOIN 				-- returns all rows with a match in either of the tables
	CROSS JOIN				-- joins tables without a join condition, returning all possible combinations of the tables. (Cartesian join)

	SELECT column1, column2,...
	FROM table1 AS t1
	INNER JOIN table2 AS t2
	ON t1.column_name=t2.column_name;
	
-- CROSS APPLY. Similar to INNER JOIN, returns all values from the left side table which produce a result in the right side table. Cross apply is like a left join.
	SELECT * FROM table1 AS t1 
	CROSS APPLY 
		( 
		SELECT * FROM Table2 AS t2 
		WHERE t1.column1 = t2.column1
		) AS a
	
	-- Example
	SELECT t2.Item, *
	FROM table1 AS t1
	CROSS APPLY dbo.FunctionDelimitedSplit(DelimitedString,';') AS t2

-- OUTER APPLY. Similar to LEFT JOIN
	SELECT * FROM table1 AS t1 
	OUTER APPLY 
		( 
		SELECT * FROM Table2 AS t2 
		WHERE t1.column1 = t2.column1
		) AS a
	
-- UNION / UNION ALL. Combines the results of two or more SELECT statements. UNION only shows distinct values, UNION ALL shows all values (including duplicates)
	SELECT column1 FROM table1
	UNION (ALL)
	SELECT column1 FROM table2
	
-- INTERSECT. Similar to UNION, but selects value only if it appears in both statements.
	SELECT column1 FROM table1
	INTERSECT
	SELECT column1 FROM table2

-- EXCEPT. Returns all rows in the first SELECT statement that are not returned by the second SELECT statement.
	SELECT column1
	FROM table1
	WHERE condition1
	EXCEPT
	SELECT column1
	FROM table2
	WHERE condition2
	
-- CREATE DATABASE. Create a database
	CREATE DATABASE database1
	
-- CREATE TABLE. Create a table.
	CREATE TABLE table1(column1 datatype, column2 datatype,...)
	
-- INSERT INTO. Inserts values into a table. Selects data from one table and inserts it into an existing table. None of the existing data in the target table is affected.
	INSERT INTO table1 (column1, column2, column3)
	VALUES (value1, value2,...), (value1#2, value2#2,...) / SELECT * FROM table1
	
	-- To copy only the columns wanted.
	INSERT INTO table2
	column1
	SELECT column1 FROM table1

-- IDENTITY_INSERT. Allows copying identity values.
	SET IDENTITY_INSERT [database1].[schema1].[table1] ON
	
-- SELECT INTO. Selects data from one table and inserts it into a new table. Run this on the destination server. If not working, need to link the two servers.  (Copy table) Backup table.
-- On the destination server go to Server Objects -> right click "Linked Servers" -> New Linked Server
	SELECT * INTO table2
	FROM [server].[database].[table1]

-- UPDATE. Change specific records
	UPDATE table1
	SET column2 = 'value2'
	WHERE column1 = 'value1'
	
	UPDATE t1
	SET t1.Column1 = t2.Column2
	FROM Table1 AS t1
	INNER JOIN Table2 AS t2
	ON t1.Column3 = t2.Column3
	
	UPDATE table1
	SET Col1 = t2.Col1, 
		Col2 = t2.Col2 
	FROM 	(
				SELECT ID, Col1, Col2 
				FROM table2
			) AS t2
	WHERE t2.ID = table1.ID
	
-- ALTER. Change data format of a column, add a new column, delete a column or change its data type
	ALTER TABLE table1
	ALTER COLUMN column1 data_type
	ALTER COLUMN column2 SET DEFAULT 'value'
	
	ALTER TABLE table1
	ADD column2 data_type / DROP COLUMN column2 / ALTER COLUMN column2 data_type
	
-- DELETE FROM. Delete rows in a table
	DELETE FROM table1
	WHERE column1 = value1
	
	-- DELETE IN A JOIN
	DELETE Table1
	FROM Table1 AS t1
	INNER JOIN Table2 AS t2 ON t1.Col1 = t2.Col1
	WHERE t2.Col3 = Condition1
	
-- DELETE. Deleats a table
	DELETE TABLE table1
	
-- TRUNCATE. Clear the table of data
	TRUNCATE TABLE table1
	
-- DROP. Drops a table, view, constraint, index, database.
	DROP TABLE table1
	
	ALTER TABLE table1
	DROP VIEW view1
	
	ALTER COLUMN column2 DROP DEFAULT
	DROP INDEX index_name ON table1
	
	DROP DATABASE database1

-- COLLATING ERRORS
--Each database has its own collation which "provides sorting rules, case, and accent sensitivity properties for your --data" (from http://technet.microsoft.com/en-us/library/ms143726.aspx) and applies to columns with textual data types, e.g. VARCHAR, CHAR, NVARCHAR, etc. When --two databases have differing collations, you cannot compare text columns with an operator like equals (=) without addressing the conflict between the two --disparate collations.
	SELECT * FROM table1 AS t1
	INNER JOIN table2 AS t2
	ON t1.column1 = t2.column1 COLLATE [language] (eg. Latin1_General_CI_AS)
	
	SELECT col1 COLLATE [language] (eg. Latin1_General_CI_AS) FROM table1
	
-- DECLARE @. Declares a variable
	DECLARE @variable data_type = value

-- @, #, ##. Temporary tables.
	DECLARE @Table1 TABLE(column1 datatype, column2 datatype,...) 	-- Table variable. Visible only to the connection that creates it, and are deleted when the batch or stored procedure ends.
	CREATE TABLE #Table1 												-- Visible only to the connection that creates it, and are deleted when the connection is closed.
	CREATE TABLE ##Table1 												-- Visible to everyone, and are deleted when the server is restarted.
	
-- Check if a table exists (if table exists)
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Table1') AND type in (N'U'))
	
-- Check if a column exists (if column exists)
	IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Column1' AND Object_ID = Object_ID(N'Schema1.Table1'))
	
-- Check if a constraint exists
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Constraint1]') AND type = 'D')

-- Check of a temporary table exists (drop if exists)
	IF OBJECT_ID('tempdb..#Table') IS NOT NULL 
		DROP TABLE #Table

-- Constraints. Specifies rules for the data in a table. Breaking them aborts data entry action
	NOT NULL 				-- A column cannot be NULL
	UNIQUE 					-- Each row for a column must have a unique value
	PRIMARY KEY 			-- A combination of NOT NULL and UNIQUE. Ensures that a column (or combination of two or more columns) have a unique identity which helps to find a particular record in a table more easily and quickly
	FOREIGN KEY 			-- Ensure the referential integrity of the data in one table to match values in another table
	CHECK 					-- Ensures that the value in a column meets a specific condition
	DEFAULT 				-- Specifies a default value for a column

-- Column constraints. Tells us what to do in case no value is passed in an insert statement
	CREATE TABLE table1
	(
		column1 INT NOT NULL,
		column2 VARCHAR(255) DEFAULT 'text'
		column3 INT FOREIGN KEY REFERENCES table2(column3)
	)
	
-- Check all foreign keys that belong to a table
	SELECT * FROM sys.foreign_keys
	WHERE referenced_object_id = object_id('table1')
	
-- Create a foreign key
	ALTER TABLE table1 ADD FOREIGN KEY (column1) REFERENCES table2(column1)

-- CHECK. Used to limit the value range that can be placed in a column or in multiple columns in a table.
	CREATE TABLE table1
	(
		column1  int NOT NULL CHECK (column1 > number)
	)
	
-- DEFAULT. Adds a default value to a column if no other value has been specified
	CREATE TABLE table1
	(
		column1 int NOT NULL,
		column2 varchar(255) DEFAULT 'value'
	)
	
-- IDENTITY. Generates a unique number when a new record is added to a table
	CREATE TABLE table1
	(
		column1 INT IDENTITY(1,1) PRIMARY KEY,
		column2 ...
	)
	-- To specify that the "ID" column should start at value 10 and increment by 5, change it to IDENTITY(10,5)
	
-- Renaming objects.
	-- Tables
	EXEC sp_rename 'schema1.Table1', 'Table2'
	-- Columns
	EXEC sp_rename 'table1.Column1' , 'Column2', 'COLUMN'
	-- Databases
	ALTER DATABASE Database1
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	GO
	sp_rename 'Database1', 'Database2' ,'DATABASE';
	GO
	ALTER DATABASE Database2
	SET MULTI_USER
	GO

-- CREATE OR REPLACE VIEW. Creates a virtual table based on the result set of an SQL statement.
	CREATE VIEW view1 AS
	SELECT * FROM table1
	WHERE condition
	
	CREATE OR REPLACE VIEW view1 AS
	SELECT column1, column2, column3
	FROM table1
	WHERE condition
	
-- The WHILE loop. Loops through an SQL statement while condition is true.
	DECLARE @variable1
	DECLARE @variable2
	SET @variable1 = 1
	SET @variable2 = 10
	
	WHILE @variable1 <= @variable2 -- Such as @variable < number
		BEGIN
			{...statements...}
		SET @variable1 = @variable1 + 1
		END
		
-- BREAK. Used for exiting a WHILE LOOP and executing the next statements after the loop's END statement.
	WHILE @variable1 <= 10
	BEGIN
	   IF @variable1 = 2
		  BREAK
	   ELSE
		...
	END
	
-- GOTO. Causes the code to branch to the label after the GOTO statement.
	GOTO label1
	
	label1:
	{...statements...}
		
-- Subqueries. It is possible to use the results of the subquery as a set of data to feed into the main query
	SELECT * FROM table1
	WHERE column1 IN
	(
		SELECT column1 FROM table
		WHERE column2 = 'value'
	)

-- MINUS. Operates on two SELECT statements. Subtracts all the results of the second statement from the first statement. Results not present in the first statement are ignored.
	SELECT column1 FROM table1
	MINUS
	SELECT column1 FROM table2

-- EXISTS. Tests whether the subquery return any data. If it does, then the main query proceeds.
	SELECT * FROM table1
	WHERE EXISTS
	(SELECT * FROM table2
	WHERE condition)
	
-- IF NOT EXISTS. Tests if a record exits
	IF NOT EXISTS(SELECT column1 FROM table1 WHERE condition)
-- Another way to check if a record does not exist
	IF ((SELECT COUNT(column1) FROM table1 WHERE condition) = 0)

-- Combine (concatenate) different strings together
	SELECT column1 + ' ' + column2 FROM table1
	
-- STUFF. Can either insert a second string into the main string or replace a part of the main string with a second string
	STUFF('main string', 'start position', 'number of characters to replace (0 for insertinon)', 'second string')
	
-- CASE. If, then, else logic. Else is optional.
	-- Simple CASE.
	SELECT CASE(column1) WHEN 'value1' THEN 'newvalue1' ELSE WHEN 'value2' THEN 'newvalue2' ELSE 'newvalue3' END AS 'column1'
	FROM table1
	
	-- Searched CASE.
	SELECT CASE(column1)
	WHEN column1 > condition THEN 'value1'
	...
	ELSE 'value2'
	FROM table1
	
-- IF. Do logic if a condition is met.
	IF @variable1 = text1

-- USE. Select a database to use.
	USE database1
	
-- GO. A script batch separator. Can be useful in situations where a script needs to be broken down into separate parts.
	GO
	
-- PRINT. The PRINT statement is used to return messages to applications. PRINT takes either a character or Unicode string expression as a parameter and returns the string as a message to the application
	 PRINT 'text' + @variable1
	 
-- FOR XML PATH. Joins all rows of data specified from specific columns
	SELECT ',' + Column1 + ',' + Column2 FROM table1 FOR XML PATH('')
	
-- BITWISE OPERATORS. Converting numbers to bitwise 1:1, 2:2, 3:4, 4:8, 5:16. Converting bitwise to numbers (eg 258 = 9:256 + 2:2) and this means that this bitwise
	-- has two flags: 9 and 2. So in SQL we can select values that have multiple flags in their property like this: where col1 & power(2,8) != 0
																											--	or:	where col1 & 256 != 0 (include, or = 0 to exclude)
	(# & #) -- AND, compares binary represintation of two numbers (eg 5: 0101 & 1: 0001 = 0001)
																	--(eg 5: 0101 & 2: 0010 = 0000)
																	
	-- Note: counting starts with power 0
	
-- OPTION (RECOMPILE). Optimize speed by allowing the stored procedure to be recompiled. If this doesn't make any difference, try exec sp_recompile 'procedure1'
	OPTION (RECOMPILE)
	
-- sp_recompile. Optimize speed by forcing re-compiling of a stored procedure.
	EXEC sp_recompile 'procedure1'
	
-- OPTION	(OPTIMIZE {...criteria...})
	OPTION	(OPTIMIZE FOR (@string = 'Marker')) -- optimize for a particular parameter passed, making execution faster for that value, but slower for others
	OPTION	(OPTIMIZE FOR UNKNOWN) -- ok to use for any parameter but not optimized for anything particular
	
-- REPLICATE. Repeats a specified string a specified number of times.
	SELECT REPLICATE('A', 3)
	 
-- CTEs - Common table expressions. Can be used to combine several tables and filter from the resulting table at the same time. Kind of similar to derived queries - SELECT * FROM (SELECT * FROM table1) AS t1
	;
	WITH cte AS
	(
		SELECT column1, column2
		FROM table1
		WHERE column2 < '2017-01-01'

		UNION ALL

		SELECT column1, column2
		FROM table2
		WHERE column2 >= '2017-01-01'
	)
	SELECT * FROM cte
		
-- CURSORs. Loops through each row in a table performing an SQL statement.
	-- There are 4 types of cursors, each of wich have subtypes - static, dynamic, forward only, keyset driven
	DECLARE @variable1 TYPE
	
	DECLARE cursor1 CURSOR (cursor type) FOR  
	SELECT column1 FROM table1
	
	OPEN cursor1
	FETCH NEXT FROM cursor1 INTO @variable1
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		{...statements...}
		
		FETCH NEXT FROM cursor1
		INTO @variable1
	END
	CLOSE cursor1
	DEALLOCATE cursor1
	
-- STORED PROCEDUREs
	-- Create
	CREATE PROCEDURE procedure1 @variable1 nvarchar(30)
	AS
	SELECT * FROM table1
	WHERE column1 = @variable1

-- FUNCTIONs
	-- Table valued functions
	CREATE FUNCTION function (@variable1 {Data type})
	RETURNS TABLE

	AS
	RETURN
	(
		SELECT * FROM Table1
	)
	
	-- Execute
	EXEC procedure1, value1
	
-- Dynamic SQL. Used for executing strings as SQL statements
	EXEC ('SQL string code') -- Execute statement
	EXEC sp_executesql N'SQL string code' -- Using a stored procedure (stores cache and speeds up subsequent queries)
	
	-- Dynamic SQL in a stored procedure
	CREATE PROC procedure1
	@variable1 VARCHAR(100)
	AS
	DECLARE @sqlCommand NVARCHAR(MAX)
	SET @sqlCommand = N'SELECT * FROM ' + variable1
	EXEC sp_executesql @sqlCommand

	EXEC procedure1 'value'
	
	-- Passing parameters outside dynamic SQL
	DECLARE @sqlCommand NVARCHAR(1000)
	DECLARE @city VARCHAR(75)
	DECLARE @quantity int
	SET @city = 'London'
	SET @sqlCommand = 'SELECT @quantity=COUNT(*) FROM customers WHERE City = @city'
	EXECUTE sp_executesql @sqlCommand, N'@city NVARCHAR(75)', @city = @city
	RETURN @quantity
	
-- TRIGGERs (simple)
	-- CREATE. After creating a record
	CREATE TRIGGER trigger_insert
	   ON table1
	   AFTER INSERT
	AS 
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO table2
		SELECT * FROM table1
	END
	GO
	
	-- DELETE. After deleting a record
	ALTER TRIGGER trigger_delete
	   ON table1
	   FOR DELETE
	AS 
	BEGIN
		SET NOCOUNT ON;

		DELETE FROM table2
		WHERE column1 = (SELECT column1 FROM DELETED) -- delete by primary key, should be good enough
	END
	GO
	
	-- UPDATE. After updating a record
	CREATE TRIGGER trigger_update
	   ON table1
	   AFTER UPDATE
	AS 
	BEGIN
		SET NOCOUNT ON;

		DECLARE @PK VARCHAR(100)
		SELECT @PK = (SELECT PK_Column FROM INSERTED)

		UPDATE table2
		SET PK_Column = new.PK_Column,
			column2 = new.column2
		FROM table1 AS original
		INNER JOIN INSERTED AS new
		ON original.PK_Column = new.PK_Column
		WHERE old.PK_Column = @PK
	END
	GO

	
	
				--========== SYSTEM COMMANDS ==========--
				
-- Fix a database stuck in restoring state.
	RESTORE DATABASE DB1 WITH RECOVERY
				
-- sp_addlinkedserver. Add a liked serves to the current server.
	EXEC sp_addlinkedserver     
		@server=N'S1_instance1', -- Name of linked server
		@srvproduct=N'', -- product name of the OLE DB data source to add as a linked server
		@provider=N'SQLNCLI', -- Is the unique programmatic identifier (PROGID) of the OLE DB provider that corresponds to this data source
		@datasrc=N'S1\instance1' -- Is the name of the data source as interpreted by the OLE DB provider.
	
-- sp_send_dbmail. Send emails with queries or attachments.
	EXEC msdb.dbo.sp_send_dbmail 
		@recipients='email',
		@subject = 'text',
		@body_format = 'HTML',
		@body = @query_text
		
-- DBCC OPENTRAN. Reset identity seed of a table
DBCC OPENTRAN
	
-- Search for a particular table in a database
	SELECT * FROM sys.Tables WHERE name LIKE '%table1%'
	
-- Kill all active connections to a specific database
	USE [master];

	DECLARE @kill VARCHAR(8000) = '';  
	SELECT @kill = @kill + 'kill ' + CONVERT(VARCHAR(5), session_id) + ';'  
	FROM sys.dm_exec_sessions
	WHERE database_id  = db_id('Database1')

	EXEC(@kill);

-- Schedule information for jobs to be executed by SQL Server Agent.
	SELECT * FROM dbo.sysjobschedules

-- DBCC CHECKIDENT. Sets the next seed value of a table's identity to the specified numer. Example: table has 10 rows with the last having number 10, and we want the next row to have a value different to 11
	DBCC CHECKIDENT (table1, reseed, 0)

-- RAISERROR. Breaks code execution and throws a custom error.
	RAISERROR ({Error message}, {Error severity number}, {State number})



				--========== FUNCTIONS ==========--
-- DB_NAME() - Display name of the current database
	SELECT DB_NAME()				

-- Date functions
	GETDATE() - Returns the current date and time
	YEAR() - Returns the year part of a date
	MONTH() - Returns the month part of a date
	DAY() - - Returns the day part of a date
	DATEPART({interval}, {datetime}) - Returns a single part of a date/time
	DATENAME(DW, GETDATE()) - Return day names
	DATEADD({interval}, {integer}, {datetime}) - Adds or subtracts a specified time interval from a date (DATEADD(YEAR/MONTH/DAY, -5, (GETDATE())))
	DATEDIFF({interval}, {start datetime}, {end datetime}) - Returns the time between two dates
	
	-- Interval descriptions
		year, yyyy, yy = Year
		quarter, qq, q = Quarter
		month, mm, m = month
		dayofyear = Day of the year
		day, dy, y = Day
		week, ww, wk = Week
		weekday, dw, w = Weekday
		hour, hh = hour
		minute, mi, n = Minute
		second, ss, s = Second
		millisecond, ms = Millisecond
		
	-- CONVERT() - Displays date/time data in different formats
	CONVERT(VARCHAR, GETDATE(), 102)
	
	-- CONVERT datetime codes
		Without century		With century	Input/Output						Standard
		0					100				mon dd yyyy hh:miAM/PM				Default
		1					101				mm/dd/yyyy							US
		2					102				yyyy.mm.dd							ANSI
		3					103				dd/mm/yyyy							British/French
		4					104				dd.mm.yyyy							German
		5					105				dd-mm-yyyy							Italian
		6					106				dd mon yyyy							-
		7					107				Mon dd, yyyy						-
		8					108				hh:mm:ss							-
		9					109				mon dd yyyy hh:mi:ss:mmm AM (or PM)	Default + millisec
		10					110				mm-dd-yyyy							USA
		11					111				yyyy/mm/dd							Japan
		12					112				yyyymmdd							ISO
		13					113				dd mon yyyy hh:mi:ss:mmm			Europe (24 hour clock)>
		14					114				hh:mi:ss:mmm						24 hour clock
		20					120				yyyy-mm-dd hh:mi:ss					ODBC canonical (24 hour clock)
		21					121				yyyy-mm-dd hh:mi:ss.mmm				ODBC canonical (24 hour clock)
							126				yyyy-mm-ddThh:mi:ss.mmm				ISO8601
							127				yyyy-mm-ddThh:mi:ss.mmmZ			ISO8601 (with time zone Z)
							130				dd mon yyyy hh:mi:ss:mmmAM			Hijiri
							131				dd/mm/yy hh:mi:ss:mmmAM				Hijiri

	
-- AVG. Returns the average value of a numeric string
	SELECT AVG(column1) AS 'Col1Sum' FROM table1
	
-- COUNT. Returns the number of rows matching a specified criteria
	SELECT COUNT(column1) FROM table1
	SELECT COUNT(*) FROM table1 -- returns the number of records in a table
	SELECT COUNT(DISTINCT column1) FROM table1 -- returns the number of distinct values in a column
	
-- IS NULL / IS NOT NULL. Used with a WHERE condition to filter by null / not null data
	SELECT Column1 FROM Table1 WHERE Column1 IS NULL
	
-- MAX / MIN. Returns the maximum / minimum value of the selected column
	SELECT MAX(column1) / MIN(column1) FROM table1
	
-- SUM. Returns the total sum of a numeric column
	SELECT SUM(column1) FROM table1
	
-- WITH ROLLUP. ROLLUP operators let you extend the functionality of GROUP BY clauses by calculating subtotals and grand totals for a set of columns.
	SELECT ISNULL(CAST(column1 AS VARCHAR(5)), 'Total'), COUNT(*)
	FROM table1
	GROUP BY CAST(ta_gamenumber AS VARCHAR(5))
	WITH ROLLUP

-- WITH CUBE. The CUBE operator is similar in functionality to the ROLLUP operator; however, the CUBE operator can calculate subtotals and grand totals for all permutations of the columns specified in it.
	SELECT ISNULL(CAST(column1 AS VARCHAR(5)), 'Total'), column2, COUNT(*)
	from TA
	FROM table1
	GROUP BY CAST(ta_gamenumber AS VARCHAR(5)), column2
	WITH CUBE
	
-- EOMONTH. Returns the last day of a month.
	DECLARE @Date1 datetime
	SET @Date1 = '04/27/2014'
	SELECT EOMONTH (@Date1)
	
-- LAG(). Allows returning a record in a table that belongs to the previous row than the one being queried. Eliminates the need to join the table on itself. The offset, default value out of bounds and partitioning is optional.
	SELECT LAG(Column1, {offset}, {default value out of bounds}) OVER (PARTITION BY Column2 ORDER BY Column3), Column1 from Table1
	
-- LEAD(). Allows returning a record in a table that belongs to the next row than the one being queried. Eliminates the need to join the table on itself. The offset, default value out of bounds and partitioning is optional.
	SELECT LEAD(Column1, {offset}, {default value out of bounds}) OVER (PARTITION BY Column2 ORDER BY Column3), Column1 from Table1
	
-- GROUP BY. Used together with aggregate functions to group results by one or more columns
	SELECT column1, aggregate_function(column1)
	FROM table1
	WHERE column1 = value
	GROUP BY column1;
	
-- HAVING. Added to SQL because the WHERE function could not be used with aggregate functions
	SELECT column1, aggregate_function(column1)
	FROM table1
	WHERE column1 = value
	GROUP BY column1
	HAVING aggregate_function(column) = value
	
-- UPPER. Converts the value of a field to upper case
	SELECT UPPER(column1) FROM table1
	
-- LOWER. Converts the value of a field to lower case
	SELECT LOWER(column1) FROM table1
	
-- MID. Used to extract data from a string
	SELECT MID(column1, start_position, length) AS extracted_text FROM table1
	
-- LEN. Returns the length of a string in a column
	SELECT LEN(column1) FROM table1
	
-- ROUND. Rounds a numeric field to the number of decimals specified.
	SELECT ROUND(column1, number) FROM table1
	
-- CEILING. Returns the smallest integer greater than or equal to the specified numeric expression.
	SELECT CEILING(1.5) -- 2

-- FLOOR. Returns the largest integer less than or equal to the specified numeric expression.
	SELECT FLOOR(1.5) -- 1
	
-- NULLIF. Replace data with NULL
	NULLIF(column1, 'text to replace with NULL')
	
-- ISNULL. Treating null values as something else (for mathematical purposes)
	ISNULL(column1,value)
	
-- COALESCE - Return the first non-null expression in a list:
	SELECT COALESCE(NULL, NULL, NULL, 'text1', NULL, 'text2')

-- REPLACE. Replaces a specified string in a particular column with another specified string.
	REPLACE(column1, 'text to replace', 'new text')

-- NEWID(). Show rows in a random order.
	ORDER BY NEWID()
	
-- HASHBYTES - generates hash from an input
	HASHBYTES({hashing algorithm}, string1)

-- Window functions, ranking
	--ROW_NUMBER() assigns unique numbers to each row within the PARTITION given the ORDER BY clause. Use 'OVER(ORDER BY (SELECT ''))' in order to rank data in exact same order as it was previoustly
		SELECT ROW_NUMBER() OVER(PARTITION BY column2 ORDER BY column2)
		FROM table1
	
	--RANK() - behaves like ROW_NUMBER(), except that “equal” rows are ranked the same.
		SELECT RANK() OVER(PARTITION BY column2 ORDER BY column2)
		FROM table1
	
	--DENSE_RANK() - Trivially, DENSE_RANK() is a rank with no gaps, i.e. it is “dense”. We can write:
		SELECT DENSE_RANK() OVER(PARTITION BY column2 ORDER BY column2)
		FROM table1
		
	--PERCENT_RANK() - Calculates the relative rank of a row withing a group of rows (to the top one in the group)
		SELECT Column1, Column2,
		RANK() OVER(ORDER BY Column1) Rnk,
		PERCENT_RANK() OVER(ORDER BY Column1) AS PctDist
		FROM Table1
		ORDER BY PctDist DESC
		
	--Window functions - general
		-- Sum all the rows on top of the current row
		SUM(column1) OVER (PARTITION BY column2 ORDER BY column3 ROWS BETWEEN UNBOUNDED PRECEEDING AND 1 PRECEEDING)
	
-- PARSENAME. Delimit a string separated by a dot, with a maximum number of 4, going from right to left. Use PARSENAME(REPLACE([column1],'delimiter','.'),1-4) for any delimiter.
	PARSENAME(column1,value)
	
-- CHARINDEX. Character indexing.
	-- The SQL Server (Transact-SQL) CHARINDEX functions returns the location of a substring in a string. The search is NOT case-sensitive.
	CHARINDEX(substring, string, start_position)

-- CAST. Convert an expression or a column to a different format.
	CAST(expression AS data_type)

-- CONVERT. Very similar to CAST. Converts an expression or a column to a different format.
	CONVERT(expression, data_type)
	
-- SUBSTRING. Used to return a portion of string.
	SUBSTRING(string, start_position, {length})
	
-- RTRIM / LTRIM. Used to truncate string of empty spaces on the right and left.
	RTRIM(LTRIM(string1))
	
-- LEFT / RIGHT. Select the specified number of characters of a sring starting from the outmost left / right positions. Trim / truncate a string.
	RIGHT('string1', number1)
	LEFT('string1', number1)
	
-- INDEX. Indexes a specific column in a table.
	-- A simple index
	CREATE {CLUSTERED} INDEX index_name ON table1(column1);
	
-- Transactions. Allows more control over data flow.
	-- COMMIT. Saves all transactions to the database since the last COMMIT or ROLLBACK command
	-- ROLLBACK. The ROLLBACK command is the transactional command used to undo transactions that have not already been commited to the database
	BEGIN TRANSACTION
	SQL_command
	COMMIT / ROLLBACK
	
	-- SAVEPOINT. A point in a transaction when you can roll the transaction back to a certain point without rolling back the entire transaction
	SAVEPOINT savepoint1
	SQL_command
	SAVEPOINT savepoint2
	SQL_command
	ROLLBACK TO savepoint1
	
	-- RELEASE SAVEPOINT. The RELEASE SAVEPOINT command is used to remove a SAVEPOINT that you have created
	RELEASE SAVEPOINT savepoint1

-- TRY CATCH. TRY/CATCH helps to write logic separate the action and error handling code. The code meant for the action is enclosed in the TRY block and the code for error handling is enclosed in the CATCH block. 
-- In case the code within the TRY block fails, the control automatically jumps to the CATCH block, letting the transaction roll back and resume execution. In addition to this, the CATCH block captures and provides 
-- error information that shows you the ID, message text, state, severity and transaction state of an error.
	BEGIN TRY
	sql_statement
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber
		 ,ERROR_SEVERITY() AS ErrorSeverity
		 ,ERROR_STATE() AS ErrorState
		 ,ERROR_PROCEDURE() AS ErrorProcedure
		 ,ERROR_LINE() AS ErrorLine
		 ,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	
-- PIVOT / UNPIVOT. Transforms rows into columns / columns into rows. 
	SELECT * FROM
	(
		SELECT column1, column2 FROM table1
	) AS table1
	PIVOT
	(
		SUM(column2) FOR column1 IN ([value1], [value2], [value3])
	) AS table2
	
	SELECT * FROM
	(
		SELECT column1, column2 FROM table1
	) AS table1
	UNPIVOT
	(
		{column name} FOR column2 IN ([value1], [value2])
	) AS table2
	
-- ABS. Convert a number to an absolute number
	ABS(number1)
	
-- CHECKSUM. Build a hash index based on an expression or column list.
	CHECKSUM(Column1, Column2, Column3)

-- NEWID. Creates unique identifiers based on a combination of a pseudorandom number and MAC address of the primary NIC. Can be used to retreive random data from a table using 'ORDER BY NEWID()'
	NEWID()
	
-- SCOPE_IDENTITY() Returns the last identity value inserted into an identity column in the same scope. A scope is a module: a stored procedure, trigger, function, or batch. 
-- Therefore, two statements are in the same scope if they are in the same stored procedure, function, or batch.
	SCOPE_IDENTITY()
	
-- STATISTICS. Display CPU execution and I/O time of the query
	SET STATISTICS TIME ON	
	
-- NOLOCK. Releases queried information without locking the database (waiting for other users to finish updating data)
	SELECT * FROM table1 WITH (NOLOCK)	
	
-- Object dependencies
	-- GUI
		-- Right-click on a table, click 'View dependencies'. This will show what stored procedures call a particular table
	-- sp_depends 'object'
		sp_depends 'table'
	
-- Schema information
	-- Tables containing column information
		INFORMATION_SCHEMA.COLUMNS
		sys.columns



				--========== GLOBAL VARIABLES ==========--
-- @@CONNECTIONS. The number of logins or attempted logins since SQL Server was last started.
	SELECT GETDATE() AS 'Today''s Date and Time', @@CONNECTIONS AS 'Login Attempts'
-- @@MAX_CONNECTIONS. The maximum number of simultaneous connections that can be made with SQL Server in this computer environment. The user can configure SQL Server for any number of connections less than or equal to the value of @@max_connections with sp_configure ''number of user connections''. 
	SELECT @@MAX_CONNECTIONS AS 'Max Connections'
-- @@CPU_BUSY. The amount of time, in ticks, that the CPU has spent doing SQL Server work since the last time SQL Server was started.
	SELECT @@CPU_BUSY * CAST(@@TIMETICKS AS FLOAT) AS 'CPU microseconds', GETDATE() AS 'As of' ;
-- @@ERROR. Commonly used to check the error status (succeeded or failed) of the most recently executed statement. It contains 0 if the previous transaction succeeded; otherwise, it contains the last error number generated by the system. A statement such as:
	IF @@ERROR <> 0 PRINT  'Your error message';
-- @@IDENTITY. The last value inserted into an IDENTITY (primary key) column by an insert or select into statement. @@identity is reset each time a row is inserted into a table. If a statement inserts multiple rows, @@identity reflects the IDENTITY value for the last row inserted. If the affected table does not contain an IDENTITY column, @@identity is set to 0. The value of @@identity is not affected by the failure of an insert or select into statement, or the rollback of the transaction that contained it. @@identity retains the last value inserted into an IDENTITY column, even if the statement that inserted it fails to commit.
	{...Insert statement...}
	SELECT @@IDENTITY AS 'Identity';
-- @@IDLE. The amount of time, in ticks, that SQL Server has been idle since it was last started.
	SELECT @@IDLE * CAST(@@TIMETICKS AS float) AS 'Idle microseconds', GETDATE() AS 'as of'
-- @@IO_BUSY. The amount of time, in ticks, that SQL Server has spent doing input and output operations since it was last started.
	SELECT @@IO_BUSY*@@TIMETICKS AS 'IO microseconds', GETDATE() AS 'as of'
-- @@LANGID. The local language id of the language currently in use (specified in syslanguages.langid).
	SET LANGUAGE 'us_english' SELECT @@LANGID AS 'Language ID'
-- @@LANGUAGE. The name of the language currently in use (specified in syslanguages.name).
	SELECT @@LANGUAGE AS 'Language Name';
-- @@MAXCHARLEN. The maximum length, in bytes, of a character in SQL Server's default character set.
	SELECT @@MAX_PRECISION AS 'Max Precision'
-- @@PACK_RECEIVED. The number of input packets read by SQL Server since it was last started.
	SELECT @@PACK_RECEIVED AS 'Packets Received'
-- @@PACK_SENT. The number of output packets written by SQL Server since it was last started.
	SELECT @@PACK_SENT AS 'Pack Sent'
-- @@PACKET_ERRORS. The number of errors that have occurred while SQL Server was sending and receiving packets.
	SELECT @@PACKET_ERRORS AS 'Packet Errors'
-- @@ROWCOUNT  
-- @@SERVERNAME. Returns the current server name
	SELECT @@SERVERNAME AS 'Server name'
-- @@SPID
-- @@TEXTSIZE 
-- @@TIMETICKS
-- @@TOTAL_ERRORS
-- @@TOTAL_READ / @@TOTAL_WRITE
-- @@TRANCOUNT
-- @@VERSION  



				--========== OTHER ==========--
-- Parameter sniffing
	-- Can assign a secondary variable to the main variable (passed to the SP) and use the secondary variable in the SP instead and see if it helps improve speed
	
-- Best practices
	Type SQL commands in upper case
	For draft SQL code use lower case for speed and distinguishing it from tested code
	Type code in camel case
	Indent SQL code
	Consult the SQL data normalisation guidelines when designing tables
	
-- GENERAL COMMENTS
	INDEX SCAN -- scanning a whole table heap to match data, the undesireable effect.
	INDEX SEEK -- scanning indexed data, the desireable way
	
-- Date data types
	DATE -- format YYYY-MM-DD
	DATETIME -- format: YYYY-MM-DD HH:MI:SS
	SMALLDATETIME -- format: YYYY-MM-DD HH:MI:00 Rounded to the nearest minute.
	TIMESTAMP -- format: a unique number

-- SQL general data types
	CHARACTER(n)			-- Character string. Fixed-length n
	VARCHAR(n)				-- CHARACTER VARYING(n) - Character string. Variable length. Maximum length n
	BINARY(n)				-- Binary string. Fixed-length n
	BOOLEAN					-- TRUE or FALSE values
	VARBINARY(n)			-- BINARY VARYING(n) - Binary string. Variable length. Maximum length n
	INTEGER(p)				-- Integer numerical (no decimal). Precision p
	SMALLINT				-- Integer numerical (no decimal). Precision 5
	INTEGER					-- Integer numerical (no decimal). Precision 10
	BIGINT					-- Integer numerical (no decimal). Precision 19
	DECIMAL(p,s)			-- Exact numerical, precision p, scale s. Example: decimal(5,2) is a number that has 3 digits before the decimal and 2 digits after the decimal
	NUMERIC(p,s)			-- Exact numerical, precision p, scale s. (Same as DECIMAL)
	FLOAT(p)				-- Approximate numerical, mantissa precision p. A floating number in base 10 exponential notation. The size argument for this type consists of a single number specifying the minimum precision
	REAL					-- Approximate numerical, mantissa precision 7
	FLOAT					-- Approximate numerical, mantissa precision 16
	DOUBLE PRECISION		-- Approximate numerical, mantissa precision 16
	DATE					-- Stores year, month, and day values
	TIME					-- Stores hour, minute, and second values
	TIMESTAMP				-- Stores year, month, day, hour, minute, and second values
	INTERVAL				-- Composed of a number of integer fields, representing a period of time, depending on the type of interval
	ARRAY					-- A set-length and ordered collection of elements
	MULTISET				-- A variable-length and unordered collection of elements
	XML						-- Stores XML data
	
-- MS SQL-specific data types
	Text					-- Use for text or combinations of text and numbers. 255 characters maximum	 
	Memo					-- Memo is used for larger amounts of text. Stores up to 65,536 characters. Note: You cannot sort a memo field. However, they are searchable	 
	Byte					-- Allows whole numbers from 0 to 255	1 byte
	Integer					-- Allows whole numbers between -32,768 and 32,767	2 bytes
	Long					-- Allows whole numbers between -2,147,483,648 and 2,147,483,647	4 bytes
	Single					-- Single precision floating-point. Will handle most decimals	4 bytes
	Double					-- Double precision floating-point. Will handle most decimals	8 bytes
	Currency				-- Use for currency. Holds up to 15 digits of whole dollars, plus 4 decimal places. Tip: You can choose which country''s currency to use	8 bytes
	AutoNumber				-- AutoNumber fields automatically give each record its own number, usually starting at 1	4 bytes
	Date/Time				-- Use for dates and times	8 bytes
	Yes/No					-- A logical field can be displayed as Yes/No, True/False, or On/Off. In code, use the constants True and False (equivalent to -1 and 0). Note: Null values are not allowed in Yes/No fields	1 bit
	Ole Object				-- Can store pictures, audio, video, or other BLOBs (Binary Large OBjects)	up to 1GB
	Hyperlink				-- Contain links to other files, including web pages	 
	Lookup Wizard			-- Let you type a list of options, which can then be chosen from a drop-down list	4 bytes


	
				--========== CUSTOM SCRIPTS ==========--
-- Create a column in a table if it doesn't exist
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'column1' AND Object_ID = Object_ID(N'table1'))
		ALTER TABLE table1 ADD column2 INT NULL
		EXEC sp_rename '[DB].[dbo].[table1].OldColumnName', 'NewColumnName', 'COLUMN'; 
				
-- Search for a particular column in all tables (Search column)
	SELECT column_name, table_name 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE column_name LIKE '%column1%'
	
-- Search for text in a group of objects (search stored procedures)
	SELECT  OBJECT_NAME(id), text
	FROM syscomments 
	WHERE text LIKE '%2018-07-20%'
	ORDER BY OBJECT_NAME(id)

-- Search for a particular column in a particular table
	SELECT name FROM
		(SELECT name
		FROM sys.columns
		WHERE object_id = OBJECT_ID('table1')) AS name
	WHERE name LIKE '%column1%'
	
-- Search for stored procedures in a database (display stored procedures, display all stored procedures)
	SELECT name, type
	FROM dbo.sysobjects
	WHERE (type = 'P')

-- Show duplicate entries in a table
	SELECT COUNT(column1) AS [Duplicate entries], column2
	FROM table1
	GROUP BY column2
	HAVING (COUNT(column2)>1)
	
-- Transpose a single row into a single column
	SELECT * FROM table1
	PIVOT (MAX(string) FOR string IN (column1,column2,column3,column4,column5)) AS TagTime;
	
-- Compress a sparcely populated matrix into fewest rows
	SELECT * FROM
	(SELECT DISTINCT ID FROM @table1) AS t1
			LEFT JOIN
	(SELECT DISTINCT ID, Column1 FROM @table1 WHERE Column1 != '') AS t2 -- != '' gets rid of spaces, can be IS NOT NULL for nulls
			ON t1.ID = t2.ID
	(SELECT DISTINCT ID, Column2 FROM @table1 WHERE Column2 != '') AS t3
			ON t1.ID = t3.ID
	
-- Random number generation
	ABS(CHECKSUM(NEWID())) %number1
	-- Between 1 and 10
	SELECT FLOOR(RAND() * (10 + 1));
	
-- Display all jobs
	SELECT 
	 j.name AS 'JobName',
	 run_date,
	 run_time,
	 msdb.dbo.agent_datetime(run_date, run_time) AS 'RunDateTime'
	FROM msdb.dbo.sysjobs j 
	INNER JOIN msdb.dbo.sysjobhistory h 
		ON j.job_id = h.job_id 
	WHERE j.enabled = 1  --Only Enabled Jobs
	--order by JobName, RunDateTime desc

-- Job last run and status info
	USE msdb
	GO
	SELECT DISTINCT SJ.Name AS JobName, SJ.description AS JobDescription,
	SJH.run_date AS LastRunDate, 
	CASE SJH.run_status 
	WHEN 0 THEN 'Failed'
	WHEN 1 THEN 'Successful'
	WHEN 3 THEN 'Cancelled'
	WHEN 4 THEN 'In Progress'
	END AS LastRunStatus
	FROM sysjobhistory SJH, sysjobs SJ
	WHERE SJH.job_id = SJ.job_id and SJH.run_date = 
	(SELECT MAX(SJH1.run_date) FROM sysjobhistory SJH1 WHERE SJH.job_id = SJH1.job_id)
	--AND SJ.Name LIKE 'Populate NFLTicketing_Information%'
	ORDER BY SJH.run_date desc

	

				--========== CUSTOM FUCNTIONS ==========--
DECLARE @DynamicTable NVARCHAR(MAX); SET @DynamicTable = '<!DOCTYPE html><html><head><style>table {border-collapse: collapse;}table, th, td {border: 0.5px solid black;}</style></head><body>'SET @DynamicTable = @DynamicTable + '<table><h1>WEB_Disputes<h1><tr>'+'<th>DisputeID</th>'+'<th>Message</th>'+'<th>Enum</th>'+'<th>LogDate</th>'+'</tr>'+
isnull(CAST(( 
SELECT 
	td = ISNULL(CAST(DisputeID AS VARCHAR(100)), ''),'', 
	td = ISNULL(CAST(Message AS VARCHAR(100)), ''),'', 
	td = ISNULL(CAST(Enum AS VARCHAR(100)), ''),'', 
	td = ISNULL(CAST(LogDate AS VARCHAR(100)), ''),'' FROM WEB_Disputes 
WHERE Enum = 5044 FOR XML PATH('tr'), TYPE
) AS NVARCHAR(MAX)), '')+'</table>'+'</body></html>'; 

SELECT @DynamicTable



				--========== KNOWN ISSUES ==========--
-- NOT IN - the not in operator fails when filtering a list of strings that contains a NULL. Make sure to exclude any nulls inside a NOT IN
	
	

				--========== REFERENCES ==========--
http://www.w3schools.com/sql
http://blog.jooq.org/2014/08/12/the-difference-between-row_number-rank-and-dense_rank/
http://sqlfool.com/
http://www.1keydata.com/sql/sql-exists.html
http://www.tutorialspoint.com/sql/sql-transactions.htm
https://technet.microsoft.com/en-us/library/ms190715(v=sql.105).aspx
http://stackoverflow.com/questions/2920836/local-and-global-temporary-tables-in-sql-server
http://www.databasejournal.com/features/mssql/concat-and-stuff-functions-in-sql-server-2012.html
https://www.mssqltips.com/sqlservertip/1023/checksum-functions-in-sql-server-2005/
http://blog.sqlauthority.com/2012/11/16/sql-server-retrieving-random-rows-from-table-using-newid/
http://stackoverflow.com/questions/12550346/how-sql-server-creates-uniqueidentifier-using-newid
http://social.technet.microsoft.com/wiki/contents/articles/17948.t-sql-right-left-substring-and-charindex-functions.aspx
https://www.codeproject.com/Articles/39131/Global-Variables-in-SQL-Server
https://blog.sqlauthority.com/2013/05/03/sql-server-delete-from-select-statement-using-join-in-delete-statement-multiple-tables-in-delete-statement/
https://blog.sqlauthority.com/2007/03/15/sql-server-dbcc-reseed-table-identity-value-reset-table-identity/
https://www.w3schools.com/sql/func_sqlserver_datepart.asp
https://www.w3schools.com/sql/func_sqlserver_convert.asp
https://blog.jooq.org/2016/04/25/10-sql-tricks-that-you-didnt-think-were-possible/
https://www.mssqltips.com/sqlservertip/3000/use-sql-servers-unpivot-operator-to-help-normalize-output/
https://blogs.msdn.microsoft.com/robinlester/2016/08/10/improving-query-performance-with-option-recompile-constant-folding-and-avoiding-parameter-sniffing-issues/
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addlinkedserver-transact-sql?view=sql-server-2017
https://www.techonthenet.com/sql_server/functions/lag.php
https://www.techonthenet.com/sql_server/functions/lead.php
http://www.sqlservercentral.com/articles/T-SQL/163572/
https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/dbo-sysjobschedules-transact-sql?view=sql-server-2017

Author: Konstantin Pokhilchuk