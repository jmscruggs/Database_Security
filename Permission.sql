-- Name: James Scruggs
-- File: Permission.sql
-- Date: 4/26/19
-- Class: CSCI 6560
------------------CREATE ROLE Customer-----------------------------------
CREATE ROLE Customer;
GRANT SELECT ON ProductVW (Product_ID, Name, Quantity, Description, Sales_Price, Discount) TO Customer;
DENY SELECT ON ProductVW (Cost_Price) TO Customer;
DENY INSERT, DELETE ON ProductVW TO Customer;

GRANT UPDATE ON CreditCardVW (Holder_Name, Billing_Address) TO Customer;
DENY SELECT,INSERT, DELETE, UPDATE ON CreditCard TO Customer;
GRANT CONTROL ON ASYMMETRIC KEY::AsymKey TO Customer; -- Needed for selecting from CreditCardVW
GRANT SELECT,INSERT, DELETE ON CreditCardVW TO Customer;
GRANT SELECT, UPDATE ON CustomerVW TO Customer; -- row level security in place 
DENY ALL ON Customer TO Customer
GRANT SELECT, UPDATE ON [Order] TO Customer; -- row level security in place
DENY UPDATE ON CustomerVW (Password) TO Customer -- no one can modify password

------------------CREATE ROLE Customer service representative-------------------
CREATE ROLE [Customer service representative];
GRANT SELECT ON ProductVW (Product_ID, Name, Quantity, Description, Sales_Price, Discount) TO [Customer service representative];
DENY SELECT ON ProductVW (Cost_Price) TO [Customer service representative];
GRANT SELECT ON CustomerVW TO [Customer service representative]; 
GRANT SELECT ON [Order] TO [Customer service representative]; -- row level security in place
GRANT SELECT ON OrderItem TO [Customer service representative];
GRANT CONTROL ON ASYMMETRIC KEY::AsymKey TO [Customer service representative]; -- Needed for selecting from CustomerVW

-- deleting a row in OrderItem (exec deleteOrderItem '2j4l87je')
GRANT EXECUTE ON deleteOrderItem TO [Customer service representative] 
DENY DELETE ON [Order] TO [Customer service representative];

-- updating a row in OrderItem (exec updateQuantityOrderItem 8, '4z1m09dn')
GRANT EXECUTE ON updateQuantityOrderItem TO [Customer service representative] 
DENY UPDATE ON OrderItem TO [Customer service representative]

-- inserting a row in OrderItem (exec InsertOrderItem 'th15h3r3', '53Tjr78bl', 23)
GRANT EXECUTE ON InsertOrderItem TO [Customer service representative] 
DENY INSERT ON OrderItem TO [Customer service representative]

-------------------CREATE ROLE Sales-----------------------------------------------
CREATE ROLE Sales;
GRANT SELECT, INSERT ON ProductVW TO Sales --Decryption/ Encryption happens here
DENY UPDATE ON ProductVW (Cost_Price, Sales_Price, Discount) TO Sales
GRANT UPDATE ON ProductVW (Name, Quantity, Description) TO Sales -- Updates can happen directly on the base table.
DENY ALL ON Product TO Sales
-- COME BACK TO DELETE HIS PERMISSIONS ON OTHER TABLES
GRANT CONTROL ON ASYMMETRIC KEY::AsymKey TO Sales; -- Needed for selecting from ProductVW

--------------------CREATE ROLE Sales Manager---------------------------------------
CREATE ROLE [Sales Manager]
GRANT SELECT,INSERT,DELETE,UPDATE ON ProductVW TO [Sales Manager]
DENY UPDATE ON ProductVW (Product_id) TO [Sales Manager]
DENY ALL ON Product TO [Sales Manager]
GRANT CONTROL ON ASYMMETRIC KEY::AsymKey TO [Sales Manager]; -- Needed for selecting from ProductVW

--------------------CREATE ROLE Order Processors------------------------------------
CREATE ROLE [Order Processors]
GRANT SELECT ON [Order] (Order_id, UserID, Order_Date, Shipping_address, Status) TO [Order Processors];
GRANT SELECT ON OrderItem (Order_id, Product_id, Quantity) TO [Order Processors];
GRANT UPDATE ON [Order] (Status) TO [Order Processors];

------NO ONE can modify UserID, Credit_Card_ID, Product_id, Order_id-----
DENY UPDATE ON Customer(UserID) TO Customer, [Customer service representative],
		Sales, [Sales Manager], [Order Processors];
DENY UPDATE ON CreditCard(Credit_Card_ID) TO Customer, [Customer service representative],
		Sales, [Sales Manager], [Order Processors];
DENY UPDATE ON Product(Product_id) TO Customer, [Customer service representative],
		Sales, [Sales Manager], [Order Processors];
DENY UPDATE ON [Order](Order_id) TO Customer, [Customer service representative],
		Sales, [Sales Manager], [Order Processors];
DENY UPDATE ON OrderItem(Order_id, Product_id) TO Customer, [Customer service representative],
		Sales, [Sales Manager], [Order Processors];

---------------------CREATE LOGINS/USERS----------------
create login mbuxcycL WITH PASSWORD = '1234';
create user mbuxcyc for login mbuxcycL
EXEC sp_addrolemember 'Customer', 'mbuxcyc';
create user ageach5 WITHOUT LOGIN
EXEC sp_addrolemember 'Customer', 'ageach5';
create user hcorben6 WITHOUT LOGIN
EXEC sp_addrolemember 'Customer', 'hcorben6';

create login CSRLogin WITH PASSWORD = '1234';
create user CSRUser for login CSRLogin
EXEC sp_addrolemember 'Customer service representative', 'CSRUser';
create user CSRUser2 WITHOUT LOGIN
EXEC sp_addrolemember 'Customer service representative', 'CSRUser2';


create login SalesLogin WITH PASSWORD = '1234';
create user SalesUser for login SalesLogin
EXEC sp_addrolemember 'Sales', 'SalesUser';
create user SalesUser2 WITHOUT LOGIN
EXEC sp_addrolemember 'Sales', 'SalesUser2';


create login SalesManagerLogin WITH PASSWORD = '1234';
create user SalesManagerUser for login SalesManagerLogin
EXEC sp_addrolemember 'Sales Manager', 'SalesManagerUser';
create user SalesManagerUser2 WITHOUT LOGIN
EXEC sp_addrolemember 'Sales Manager', 'SalesManagerUser2';


create login OPLogin WITH PASSWORD = '1234';
create user OPUser for login OPLogin
EXEC sp_addrolemember 'Order Processors', 'OPUser';
create user OPUser2 WITHOUT LOGIN
EXEC sp_addrolemember 'Order Processors', 'OPUser2';
-----------------------------------------------
go

CREATE FUNCTION DCCompany.fn_securitypredicate(@OwnerID AS VARCHAR(255))  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result   
WHERE @OwnerID = USER_NAME() OR IS_MEMBER('Customer service representative') = 1
	OR IS_MEMBER('db_owner') = 1;
GO

CREATE FUNCTION DCCompany.fn_securitypredicate2(@OwnerID AS VARCHAR(255))  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result   
WHERE @OwnerID = USER_NAME() OR IS_MEMBER('Customer service representative') = 1
OR IS_MEMBER('Order Processors') = 1 OR IS_MEMBER('db_owner') = 1;
GO

CREATE SECURITY POLICY CreditCardFilter  
ADD FILTER PREDICATE DCCompany.fn_securitypredicate(OwnerID)
ON dbo.CreditCard 
WITH (STATE = ON);


CREATE SECURITY POLICY CustomerFilter  
ADD FILTER PREDICATE DCCompany.fn_securitypredicate(UserID)
ON dbo.Customer
WITH (STATE = ON);

CREATE SECURITY POLICY OrderFilter  
ADD FILTER PREDICATE DCCompany.fn_securitypredicate2(UserID)
ON dbo.[Order]
WITH (STATE = ON); 
--------------------------------------------------------------