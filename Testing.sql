-- Name: James Scruggs
-- File: Testing.sql
-- Date: 4/26/19
-- Class: CSCI 6560

--------------1). Customer permissions test-----------------
-- Can view information of all products excluding Cost_Price--
execute as user='ageach5'

-- Querying Cost_Price gives an error
select Name, Quantity, Description, Sales_Price, Discount from PRODUCTVW

-- Can view their own information and last 4 digits of credit cards
select * from CUSTOMERVW
select * from CREDITCARDVW

-- Can update their own information
update CustomerVW set Email = 'changed@gmail.com'
select * from CUSTOMERVW

-- Can can insert/remove a credit card
-- Note: if order is placed on credit card, then credit card cannot be deleted...
select * from [order] 
delete from CreditCardVW where Credit_Card_ID = '19Vb796no'
select * from CREDITCARDVW
insert into CreditCardVW (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('19Vb796no',  '5010122853902236', 'Vyky Delepine', '2022-08-05', 897, '3 Acker Park', 'ageach5')

--can only modify Holder_Name and Billing_Address of existing credit card
update CREDITCARDVW set Holder_Name = 'April Geach'
select * from CREDITCARDVW
revert

------------------2). Customer Service Representative permissions test--------
execute as user='CSRUser2'

-- Can view information of all products excluding Cost_Price
select Name, Quantity, Description, Sales_Price, Discount from PRODUCTVW

-- Can view customer information and orders
select * from CUSTOMERVW 
select * from [Order]

-- Can remove an order item from a placed order only if the order status is “in
-- preparation”
select * from [Order] o join OrderItem oi on o.Order_id = oi.Order_id
exec deleteOrderItem '2j4l87je'
select * from [Order] o join OrderItem oi on o.Order_id = oi.Order_id

-- Order was also deleted because if did not contain any order items.
select * from [Order]

-- Can update the quantity of an order item from a placed order only if the order status is
-- “in preparation”.
select * from [Order] o join OrderItem oi on o.Order_id = oi.Order_id where status = 'in preparation'
exec updateQuantityOrderItem 8, '4z1m09dn'
select * from [Order] o join OrderItem oi on o.Order_id = oi.Order_id where status = 'in preparation'

-- Can insert a new order item to a placed order only if the order status is “in
-- preparation”
select * from [Order] o left join OrderItem oi on o.Order_id = oi.Order_id
exec InsertOrderItem 'th15h3r3', '53Tjr78bl', 23
select * from [Order] o left join OrderItem oi on o.Order_id = oi.Order_id
revert

----------------3). Sales permissions test--------------------
execute as user='SalesUser2'

-- Can select/insert/update product table
select * from ProductVW
insert into ProductVW (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('7428fsdf8', 'Donut - Chocolate W sprinkles', 2, 'Testing', 9.58, 74.30, 0.43)
select * from ProductVW
update ProductVW set Description = 'Donut' where Product_id = '13LWE52iM'
select * from ProductVW

-- Cannot modify Cost_Price, Sales_Price, and Discount attributes.
update ProductVW set Cost_Price = 52.02 where Product_id = '13LWE52iM'
update ProductVW set Sales_Price = 52.02 where Product_id = '13LWE52iM'
update ProductVW set Discount = .02 where Product_id = '13LWE52iM'
revert

-------------------4). Sales Manager permissions test---------------------
execute as user='SalesManagerUser2'

-- Can select/insert/update product table
select * from ProductVW
insert into ProductVW (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('dfjsd83n23', 'Milk - lowfat', 4, 'Test for Sales Mgr', 40.58, 89.30, 0.79)
select * from ProductVW
update ProductVW set Description = 'This is milk' where Product_id = 'dfjsd83n23'
select * from ProductVW

-- Can modify Cost_Price, Sales_Price, and Discount attributes.
update ProductVW set Cost_Price = 52.02 where Product_id = 'dfjsd83n23'
update ProductVW set Sales_Price = 60.0 where Product_id = 'dfjsd83n23'
update ProductVW set Discount = .22 where Product_id = 'dfjsd83n23'
select * from ProductVW

-- Can remove a product from database if its quantity is 0.
delete from productVW where Product_id = 'dfjsd83n23'
select * from ProductVW where Product_id = 'dfjsd83n23'
update ProductVW set Quantity = 0 where Product_id = 'dfjsd83n23' -- set qty = 0
delete from productVW where Product_id = 'dfjsd83n23' -- now it will delete it.
select * from ProductVW where Product_id = 'dfjsd83n23'
-- Permission is not allowed on all other tables.
revert

-------------------5). Order Processors permissions test---------------------
-- Can view Order excluding Total_Amount, Credit_Card_ID attributes
execute as user='OPUser2'
select Order_id, UserID, Order_Date, Shipping_address, Status from [Order]

-- Can view OrderItem excluding PaidPrice
select Order_id, Product_id, Quantity from OrderItem

-- Only modify Status attribute of Order table.
select Order_id, UserID, Order_Date, Shipping_address, Status from [Order]
update [Order] set Status = 'shipped' where Order_id = '0e1d86cz'
revert


-----------Constraints and Requirements---------------
---OrderItem.PaidPrice should always be greater or equal to the cost price of the product.-
select oi.PaidPrice, p.Cost_Price from OrderItem oi join ProductVW p on oi.Product_id = p.Product_id

-- OrderItem.PaidPrice and Order.Total_Amount should always be calculated automatically and
-- consistent AND when order is placed , quantities are deducted correctly.
-- You see Total_Amount and PaidPrice is derived correctly.
-- You see milks product quantity deducted by 1.
select o.Order_id, oi.PaidPrice, o.Total_Amount, oi.Quantity from OrderItem oi join [Order] o on oi.Order_id = o.Order_id 
insert into ProductVW (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('dfjsd83n23', 'Milk - lowfat', 4, 'Test for Sales Mgr', 40.58, 89.30, 0.79)
insert into OrderItem (Order_id, Product_id, Quantity) values ('th15h3r3', 'dfjsd83n23', 1)
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('th15h3r3', 'ageach5', '3-23-1990', '19Vb796no', '4001 Beilfuss Junction', 'placed');
select o.Order_id, oi.PaidPrice, o.Total_Amount, oi.Quantity from OrderItem oi join [Order] o on oi.Order_id = o.Order_id
select b.Name, a.Quantity as [OrderItem QTY], b.Quantity as [Product Qty] from
	OrderItem a join Product b on a.Product_id = b.Product_id;


-- When an order item is removed, add OrderItem.Quantity back to Product.Quantity
-- You see Milk's product quantity = 4 after following statements.
delete from OrderItem where Order_id = 'th15h3r3'
select b.Name, a.Quantity as [OrderItem QTY], b.Quantity as [Product Qty] from
	OrderItem a right join Product b on a.Product_id = b.Product_id;

-- Password, credit card number, and Product.Cost_Price must be encrypted
select Password from Customer
select Credit_Card_Number from CreditCard
select Cost_Price from Product

-- NO ONE CAN MODIFY user id, credit card id, order id, product id.

-- Track changes made to the product table, including information of the user who makes the
-- change and data before and after the change
 select * from DCCompany.Audit

 -- Track any permission changes by GRANT/REVOKE/DENY statements.
 -- Logs can be found under Securtiy > Audits > PermissionTracking
 
 -- Audit successful/failed login and logout events
 -- these stored procedures need actual failed login/logout attempts to work to show
 -- functionality.
 -- LoginName: mbuxcycL
 -- Password: 1234
 exec usp_GetFailedLoginsForUser 'mbuxcyc' -- show failed logins for user
 exec usp_GetUserSessionInfo 'mbuxcyc' -- show login/logout time for user
