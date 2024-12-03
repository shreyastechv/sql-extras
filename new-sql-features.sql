-- Table creation
CREATE TABLE userData (
	userId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NewId(),
	userName VARCHAR(40),
	userDOB DATE,
	_createdAt DATETIME DEFAULT GetDate(),
	_updatedAt DATETIME DEFAULT GetDate()
	);

-- Data insertion
INSERT INTO userData (
	userName,
	userDOB
	)
VALUES (
	'Shreyas',
	'2001-11-27'
	),
	(
	'Jithin',
	'2001-11-24'
	),
	(
	'Dinil',
	'2001-10-12'
	);

SELECT * FROM userData;

-- User Defined Funtion
CREATE FUNCTION dbo.CalculateAge (@dob DATE)
RETURNS INT
AS
BEGIN
	DECLARE @age INT
	DECLARE @now DATE = GetDate()

	SET @age = (CONVERT(INT, CONVERT(CHAR(8), @now, 112)) - CONVERT(CHAR(8), @dob, 112)) / 10000

	RETURN @age
END;

SELECT userName, dbo.CalculateAge(userDOB) AS Age FROM userData;

-- Trigger
CREATE TRIGGER trgUpdateTimestamp ON userData
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE userData
	SET _updatedAt = GetDate()
	FROM userData
	INNER JOIN inserted ON userData.userId = inserted.userId
END;

UPDATE userData
SET userDOB = '2001-11-23'
WHERE userName = 'Shreyas';

SELECT * FROM userData;

-- Stored Procedure
CREATE PROCEDURE ShowDOB @name VARCHAR(40)
AS
SELECT userDOB AS 'Date of Birth'
FROM userData
WHERE userName = @name;

EXEC ShowDOB @name = 'Shreyas';

-- Cursor
DECLARE c1 CURSOR SCROLL
FOR
SELECT *
FROM userData;

OPEN c1;

FETCH NEXT
FROM c1;

WHILE @@FETCH_STATUS = 0
BEGIN
	FETCH NEXT
	FROM c1
END;

CLOSE c1;
DEALLOCATE c1;
