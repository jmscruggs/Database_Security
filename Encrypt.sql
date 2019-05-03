-- Name: James Scruggs
-- File: Encrypt.sql
-- Date: 4/26/19
-- Class: CSCI 6560
USE Dot;
go

--create an asymmetric key with a password, so
--the private key is protected by the password instead of DMK
create asymmetric key AsymKey
with algorithm = RSA_2048
encryption by password = 'a string password';

-- This query can also be generated from this query (select * from PRODUCTVW)
revert
SELECT Product_id, Name, Quantity, Description, CONVERT(DECIMAL(19,2), CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), Cost_Price, N'a string password'))) as Cost_Price, Sales_Price, Discount
FROM PRODUCT
