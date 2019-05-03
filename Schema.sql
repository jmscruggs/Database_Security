-- Name: James Scruggs
-- File: Schema.sql
-- Date: 4/26/19
-- Class: CSCI 6560
create Database Dot;
go
use Dot;
GO

CREATE Schema DCCompany
GO

CREATE TABLE CUSTOMER
(
	UserID		VARCHAR(255)	NOT NULL UNIQUE,
	Email		VARCHAR(255) NOT NULL,
	Password		VARBINARY(4000)	NOT NULL, ----decrypts to VARCHAR(255) 
	Firstname		VARCHAR(255)	NOT NULL,
	Lastname	VARCHAR(255)	NOT NULL,
	Address		VARCHAR(255),
	Phone		VARCHAR(20),
	PRIMARY KEY(UserID)
)
GO

CREATE TABLE CREDITCARD
(
	Credit_Card_ID		VARCHAR(255)	NOT NULL UNIQUE,
	Credit_Card_Number		VARBINARY(4000)	NOT NULL, --decrypts to VARCHAR(255)
	Holder_Name		VARCHAR(255)		NOT NULL,
	Expire_Date	DATE,
	CVC_Code INT,
	Billing_Address VARCHAR(255),
	OwnerID         VARCHAR(255) NOT NULL,
	FOREIGN KEY(OwnerID) REFERENCES CUSTOMER(UserID),
	PRIMARY KEY(OwnerID,Credit_Card_ID)
)
GO

CREATE TABLE PRODUCT
(
	Product_id		VARCHAR(255)	NOT NULL UNIQUE,
	Name		VARCHAR(255)	NOT NULL,
	Quantity    INT NOT NULL,
	Description	VARCHAR(255),
	Cost_Price VARBINARY(4000),--decrypts to DECIMAL(19,2),
	Sales_Price DECIMAL(19,2),
	Discount FLOAT,
	PRIMARY KEY(Product_id)
)
GO

CREATE TABLE [ORDER]
(
	Order_id	VARCHAR(255)	NOT NULL,
	UserID		VARCHAR(255)	NOT NULL,
	Order_Date	DATE,
	Total_Amount	DECIMAL(19,2), -- derived by summing Quantity*PaidPrice of all items in the order.
	Credit_Card_ID VARCHAR(255) NOT NULL,
	Shipping_address VARCHAR(255),
	Status  VARCHAR(14) NOT NULL CHECK (Status IN('placed', 'in preparation', 'ready to ship', 'shipped'))
	PRIMARY KEY(Order_id),
	FOREIGN KEY(UserID, Credit_Card_ID) REFERENCES CREDITCARD(OwnerID,Credit_Card_ID)
)
GO

CREATE TABLE ORDERITEM
(
	Order_id		VARCHAR(255)		NOT NULL,
	Product_id		VARCHAR(255)	NOT NULL,
	PaidPrice		DECIMAL(19,2), -- derived from Sales price and Discount of the product when the order is placed
	Quantity		INT,
	PRIMARY KEY(Order_id, Product_id)
)
GO

CREATE VIEW CreditCardVW AS
SELECT Credit_Card_ID, 'XXXXXXXXXXXX' + RIGHT(CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), Credit_Card_Number, N'a string password')), 4) as Credit_Card_Number, Holder_Name,
		Expire_Date, CVC_Code, Billing_Address, OwnerID
FROM CREDITCARD
GO

CREATE VIEW ProductVW AS
SELECT Product_id, Name, Quantity, Description, CONVERT(DECIMAL(19,2), CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), Cost_Price, N'a string password'))) as Cost_Price, Sales_Price, Discount
FROM PRODUCT
GO

CREATE VIEW CustomerVW AS
SELECT UserID, Email, CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), Password, N'a string password')) as Password, Firstname, 
	Lastname, Address, Phone 
FROM CUSTOMER
GO
