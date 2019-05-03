-- Name: James Scruggs
-- File: Data.sql
-- Date: 4/26/19
-- Class: CSCI 6560
use DOT
go

Alter SECURITY POLICY OrderFilter
WITH (State = OFF)
Alter SECURITY POLICY CustomerFilter
WITH (State = OFF)
Alter SECURITY POLICY CreditCardFilter
WITH (State = OFF)
drop security policy IF EXISTS CustomerFilter
drop security policy IF EXISTS CreditCardFilter
drop security policy IF EXISTS OrderFilter
drop function DCCompany.fn_securitypredicate
drop function DCCompany.fn_securitypredicate2
DROP TABLE IF EXISTS DCCompany.Audit;
DROP TABLE IF EXISTS ORDERITEM;
drop table IF EXISTS PRODUCT -- dropped 2nd
drop table IF EXISTS [ORDER] -- dropped 3rd
drop table IF EXISTS CREDITCARD -- dropped 4th
drop table IF EXISTS CUSTOMER -- dropped 5th
drop view IF EXISTS CreditCardVW
drop view IF EXISTS ProductVW
drop view IF EXISTS CustomerVW
DROP trigger IF EXISTS PaidPriceTrigger
DROP trigger IF EXISTS Product_Audit
DROP trigger IF EXISTS TotalAmountTrigger
DROP trigger IF EXISTS UpdateStatus
DROP trigger IF EXISTS UpdatedQuantity
DROP trigger IF EXISTS DeleteOrderItemTrigger
DROP trigger IF EXISTS deleteProductView
DROP trigger IF EXISTS insertProductView
DROP trigger IF EXISTS insertCCView
DROP procedure IF EXISTS deleteOrderItem
DROP procedure IF EXISTS updateQuantityOrderItem
DROP procedure IF EXISTS InsertOrderItem
DROP procedure IF EXISTS InsertOrderItem
Drop ASYMMETRIC KEY AsymKey
DROP USER IF EXISTS mbuxcyc
DROP USER IF EXISTS ageach5
DROP LOGIN mbuxcycL
DROP USER IF EXISTS CSRUser
DROP USER IF EXISTS CSRUser2
DROP LOGIN CSRLogin
DROP USER IF EXISTS SalesUser
DROP USER IF EXISTS SalesUser2
DROP LOGIN SalesLogin
DROP USER IF EXISTS SalesManagerUser
DROP USER IF EXISTS SalesManagerUser2
DROP LOGIN SalesManagerLogin
DROP USER IF EXISTS OPUser
DROP USER IF EXISTS OPUser2
DROP LOGIN OPLogin
DROP ROLE IF EXISTS [Customer service representative]
DROP ROLE IF EXISTS Sales
DROP ROLE IF EXISTS [Sales Manager]
DROP ROLE IF EXISTS [Order Processors]
DROP ROLE IF EXISTS Customer


ALTER DATABASE AUDIT SPECIFICATION Change_Object_Permissions WITH (STATE=OFF);
DROP DATABASE AUDIT SPECIFICATION Change_Object_Permissions

USE master
go

ALTER SERVER AUDIT [PermissionTracking] WITH (STATE=OFF);
DROP SERVER AUDIT [PermissionTracking]

USE Dot
GO

DROP PROC IF EXISTS usp_GetFailedLoginsForUser
DROP PROC usp_GetUserSessionInfo

exec sp_trace_setstatus 2, 0
exec sp_trace_setstatus 2, 2

drop schema DCCompany

use master
go
drop database Dot
