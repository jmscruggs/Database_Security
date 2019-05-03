-- Name: James Scruggs
-- File: Auditing.sql
-- Date: 4/26/19
-- Class: CSCI 6560
Use Dot
GO

-- Add the table 
CREATE table DCCompany.Audit (
	AuditID UNIQUEIDENTIFIER RowGUIDCol NOT NULL
		CONSTRAINT DF_Audit_AuditID Default (NEWID())
		CONSTRAINT PK_Audit PRIMARY KEY NONCLUSTERED (AuditID),
	AuditDate DATETIME NOT NULL,
	SysUser VARCHAR(MAX) NULL,
	Application VARCHAR(50) NOT NULL,
	TableName VARCHAR(50) NOT NULL,
	Operation CHAR(1) NOT NULL,
	PrimaryKey VARCHAR(50) NOT NULL,
	RowDescription VARCHAR(255) NULL,
	SecondaryRow VARCHAR(50) NULL,
	[Column] VARCHAR(50) NOT NULL,
	OldValue VARCHAR(MAX) NULL,
	NewValue VARCHAR(MAX) NULL
	);
GO
-- Track changes made to the product table, including information of the user who makes the 
CREATE TRIGGER Product_Audit
ON Product
After Insert, Update
NOT FOR REPLICATION
AS

DECLARE @Operation CHAR(1)

IF EXISTS(SELECT * FROM Deleted)
	Set @Operation = 'U'
ELSE
	Set @Operation = 'I'

IF UPDATE(Name)
	INSERT DCCompany.Audit
	(AuditDate, SysUser, Application, TableName, Operation,
		PrimaryKey, RowDescription, SecondaryRow, [Column],
		OldValue, NewValue)
		SELECT GetDate(), suser_name(), APP_NAME(), 'Product', @Operation,
			inserted.Product_id, Inserted.Description, NULL, 'Name',
			deleted.Name, inserted.Name
		FROM inserted
			LEFT OUTER JOIN deleted
				ON inserted.Product_id = deleted.Product_id
				AND inserted.Name <> deleted.Name
IF UPDATE(Quantity)
	INSERT DCCompany.Audit
	(AuditDate, SysUser, Application, TableName, Operation,
		PrimaryKey, RowDescription, SecondaryRow, [Column],
		OldValue, NewValue)
		SELECT GetDate(), USER, APP_NAME(), 'Product', @Operation,
			inserted.Product_id, Inserted.Description, NULL, 'Quantity',
			deleted.Quantity, inserted.Quantity
		FROM inserted
			LEFT OUTER JOIN deleted
				ON inserted.Product_id = deleted.Product_id
				AND inserted.Quantity <> deleted.Quantity
IF UPDATE(Description)
	INSERT DCCompany.Audit
	(AuditDate, SysUser, Application, TableName, Operation,
		PrimaryKey, RowDescription, SecondaryRow, [Column],
		OldValue, NewValue)
		SELECT GetDate(), suser_name(), APP_NAME(), 'Product', @Operation,
			inserted.Product_id, Inserted.Description, NULL, 'Description',
			deleted.Description, inserted.Description
		FROM inserted
			LEFT OUTER JOIN deleted
				ON inserted.Product_id = deleted.Product_id
				AND inserted.Description <> deleted.Description
IF UPDATE(Cost_Price)
	INSERT DCCompany.Audit
	(AuditDate, SysUser, Application, TableName, Operation,
		PrimaryKey, RowDescription, SecondaryRow, [Column],
		OldValue, NewValue)
		SELECT GetDate(), suser_sname(), APP_NAME(), 'Product', @Operation,
			inserted.Product_id, Inserted.Description, NULL, 'Cost_Price',
			CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), deleted.Cost_Price, N'a string password')), CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), inserted.Cost_Price, N'a string password'))
		FROM inserted
			LEFT OUTER JOIN deleted
				ON inserted.Product_id = deleted.Product_id
				AND inserted.Cost_Price <> deleted.Cost_Price
IF UPDATE(Sales_Price)
	INSERT DCCompany.Audit
	(AuditDate, SysUser, Application, TableName, Operation,
		PrimaryKey, RowDescription, SecondaryRow, [Column],
		OldValue, NewValue)
		SELECT GetDate(), suser_name(), APP_NAME(), 'Product', @Operation,
			inserted.Product_id, Inserted.Description, NULL, 'Sales_Price',
			deleted.Sales_Price, inserted.Sales_Price
		FROM inserted
			LEFT OUTER JOIN deleted
				ON inserted.Product_id = deleted.Product_id
				AND inserted.Sales_Price <> deleted.Sales_Price
IF UPDATE(Discount)
	INSERT DCCompany.Audit
	(AuditDate, SysUser, Application, TableName, Operation,
		PrimaryKey, RowDescription, SecondaryRow, [Column],
		OldValue, NewValue)
		SELECT GetDate(), suser_name(), APP_NAME(), 'Product', @Operation,
			inserted.Product_id, Inserted.Description, NULL, 'Discount',
			deleted.Discount, inserted.Discount
		FROM inserted
			LEFT OUTER JOIN deleted
				ON inserted.Product_id = deleted.Product_id
				AND inserted.Discount <> deleted.Discount
GO

-- Track any permission changes by GRANT/REVOKE/DENY statements
-- Create the server audit.
USE [master];

CREATE SERVER AUDIT [PermissionTracking]
TO FILE 
(   FILEPATH = N'C:\DATA'
    ,MAXSIZE = 0 MB
    ,MAX_ROLLOVER_FILES = 2147483647
    ,RESERVE_DISK_SPACE = OFF
)
WITH
(   QUEUE_DELAY = 1000
    ,ON_FAILURE = CONTINUE
);

--Enable Audit
ALTER SERVER AUDIT [PermissionTracking] WITH (STATE=ON);

--Create Database Audit Specification
USE Dot
Go

CREATE DATABASE AUDIT SPECIFICATION Change_Object_Permissions 
FOR SERVER AUDIT [PermissionTracking]
ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP)
WITH (STATE=ON);
GO

-- Provide SQL statements to retrieve all failed logins for a given user
-- To test exec usp_GetFailedLoginsForUser 'testUser'
CREATE PROC usp_GetFailedLoginsForUser
@User varchar(128)
AS
BEGIN
	DECLARE @user_name varchar(128);
	DROP TABLE IF EXISTS #temp;
	DROP TABLE IF EXISTS #results;
	CREATE TABLE #temp
	(
		LogDate DATETIME,
		ProcessInfo VARCHAR(128),
		Text VARCHAR(MAX)
	);
	CREATE TABLE #results
	(
		[user name] varchar(128),
		[login name] varchar(128),
		LogDate DATETIME,
		ProcessInfo VARCHAR(128),
		Text VARCHAR(MAX)
	);
	INSERT INTO #temp
	EXEC master.dbo.sp_readerrorlog 0, 1

	set @user_name =
	(SELECT b.name as [login name] 
	FROM master.sys.database_principals a join sys.sql_logins b on a.sid = b.sid where a.name = @User)
	
	INSERT INTO #results
	select @User, @user_name, LogDate, ProcessInfo, Text from #temp where ProcessInfo = 'Logon' AND Text LIKE '%Login failed for user '''+@user_name+'%'

	select * from #results

	drop table #temp;
	drop table #results;
END
GO

-- Provide SQL statements to retrieve all session information for a given user. 
--------------------------------- TraceID = 2
--select * from sys.sysprocesses

declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 5

exec @rc = sp_trace_create @TraceID output, 0, N'C:\TRACE\auditTrace', @maxfilesize, NULL
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 14, 14, @on -- login time
exec sp_trace_setevent @TraceID, 14, 41, @on -- loginsid
exec sp_trace_setevent @TraceID, 15, 41, @on -- loginsid
exec sp_trace_setevent @TraceID, 15, 15, @on -- logout time
exec sp_trace_setevent @TraceID, 15, 13, @on -- Duration of time logged in
exec sp_trace_setevent @TraceID, 14, 11, @on -- login name
exec sp_trace_setevent @TraceID, 15, 11, @on -- login name
exec sp_trace_setevent @TraceID, 14, 35, @on -- Database name
exec sp_trace_setevent @TraceID, 15, 35, @on -- Database name
exec sp_trace_setevent @TraceID, 14, 38, @on
exec sp_trace_setevent @TraceID, 15, 38, @on
exec sp_trace_setevent @TraceID, 14, 40, @on
exec sp_trace_setevent @TraceID, 15, 40, @on

exec sp_trace_setstatus @TraceID, 1

GO
-- exec usp_GetUserSessionInfo 'testUser2'
CREATE PROC usp_GetUserSessionInfo
@User varchar(128)
AS
BEGIN
	DECLARE @user_name varchar(128);
	DROP TABLE IF EXISTS #temp_trc;
	CREATE TABLE #temp_trc
	(
		LoginSid   varbinary(85),
		EventClass VARCHAR(255),
		LoginName VARCHAR(255),
		SPID INT,
		StartTime DATETIME,
		EndTime DATETIME,
		Duration BIGINT,
		DatabaseName VARCHAR(255)
	);

	INSERT INTO #temp_trc  
	SELECT LoginSid, EventClass, LoginName, SPID, dateadd(millisecond, -datepart(millisecond, StartTime),StartTime) as StartTime, dateadd(millisecond, -datepart(millisecond, EndTime),EndTime) as EndTime, Duration/1000, DatabaseName
	FROM fn_trace_gettable('C:\TRACE\auditTrace.trc', default);  

	set @user_name =
	(SELECT b.name as [login name] 
	FROM master.sys.database_principals a join sys.sql_logins b on a.sid = b.sid where a.name = @User)

	select a.LoginName, @User as UserName, a.StartTime as [Logon Time], b.EndTime as [Logout Time], a.DatabaseName FROM #temp_trc a join #temp_trc b on (a.SPID != b.SPID
		AND a.LoginName = b.LoginName)
		where a.StartTime IS NOT NULL AND b.EndTime IS NOT NULL AND a.StartTime < b.EndTime AND a.LoginName = @user_name
	
	drop table #temp_trc;
END
GO

