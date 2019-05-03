-- Name: James Scruggs
-- File: Objects.sql
-- Date: 4/26/19
-- Class: CSCI 6560
use Dot;
GO
-- OrderItem.PaidPrice should always be greater or equal to the cost price of the product.
CREATE TRIGGER PaidPriceTrigger on ORDERITEM
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @price DECIMAL(19,2);
	DECLARE @paidprice DECIMAL(19,2);
	DECLARE @prodid VARCHAR(255);
	DECLARE @disc FLOAT;
	DECLARE @costprice DECIMAL(19,2);
	DECLARE @cursor CURSOR;

	SET @cursor = CURSOR FOR
	WITH cte AS(
		select i.Product_id, Sales_Price, Discount, CONVERT(DECIMAL(19,2), (CONVERT(VARCHAR(30), DecryptByAsymkey(ASYMKEY_ID('AsymKey'), Cost_Price, N'a string password')))) as Cost_Price
			from PRODUCT p JOIN inserted i on p.Product_id = i.Product_id
	)
	select Product_id, Sales_Price, Discount, Cost_Price FROM cte;

	OPEN @cursor;

	FETCH next FROM @cursor INTO @prodid, @price, @disc, @costprice

	WHILE @@fetch_status = 0
	BEGIN
		SET @paidprice = @price - (@price * @disc);
		IF (@paidprice >= @costprice)
		BEGIN
			INSERT INTO ORDERITEM
				SELECT Order_id, Product_id, @paidprice as PaidPrice, Quantity
				FROM inserted where Product_id = @prodid;
		END
		ELSE
		BEGIN
			INSERT INTO ORDERITEM
				SELECT Order_id, Product_id, @costprice as PaidPrice, Quantity
				FROM inserted where Product_id = @prodid;
		END
			
		FETCH next FROM @cursor INTO @prodid, @price, @disc, @costprice
			
	END
	close @cursor
	deallocate @cursor	
END
GO

-- OrderItem.PaidPrice and Order.Total_Amount should always be calculated automatically and
-- consistent./ Start charging the credit card whenever the order status is changed to [shipped]./
-- order is placed, deduct OrderItem.Quantity from Product.Quantity 

create TRIGGER TotalAmountTrigger on [ORDER]
INSTEAD OF INSERT
AS
BEGIN
	
	DECLARE @orderid VARCHAR(255);
	DECLARE @productid VARCHAR(255);
	DECLARE @quantity INT;
	DECLARE @total DECIMAL(19,2);
	DECLARE @status VARCHAR(14);
	DECLARE @credit_card_num VARCHAR(30);
	SELECT @orderid = Order_id FROM inserted	

	select @total = Total FROM
	(select Order_id, SUM(CAST(PaidPrice * Quantity as DECIMAL(19,2))) as Total FROM OrderItem WHERE Order_id = @orderid GROUP BY Order_id) as tempTable;
	
	select @status = Status FROM inserted;

	INSERT INTO [ORDER]
	SELECT Order_id, UserID, Order_Date, @total as Total_Amount, Credit_Card_ID, Shipping_address, Status
	FROM inserted;

	IF @status = 'shipped'
	BEGIN
		select @credit_card_num = Credit_Card_Number from CreditCardVW c join
			inserted i on c.Credit_Card_ID = i.Credit_Card_ID;
		PRINT 'Credit Card ending with '+ RIGHT(@credit_card_num, 4) + ' is charged ' + CONVERT(VARCHAR(30),@total)
				+ ' for the order with order id ' + @orderid + '.';
	END
	ELSE IF @status = 'placed'
	BEGIN
		select @productid = Product_id, @quantity = Quantity from OrderItem where Order_id = @orderid;
		update Product set Quantity = Quantity - @quantity where Product_id = @productid;
	END				
END
GO

create trigger UpdateStatus on [ORDER]
with execute as owner
FOR UPDATE
AS
	IF UPDATE(Status)
	BEGIN
		DECLARE @credit_card_num VARCHAR(30);
		DECLARE @status VARCHAR(14);
		DECLARE @orderid VARCHAR(255);
		DECLARE @total DECIMAL(19,2);
		DECLARE @userid	VARCHAR(255);
		select @status = Status, @orderid = Order_id, @total = Total_Amount, @userid = UserID FROM inserted;
		IF @status = 'shipped'
		BEGIN
			execute as user = @userid;
			select @credit_card_num = Credit_Card_Number from CreditCardVW c join
				inserted i on c.Credit_Card_ID = i.Credit_Card_ID;
			PRINT 'Credit Card ending with '+ RIGHT(@credit_card_num, 4) + ' is charged ' + CONVERT(VARCHAR(30),@total)
				+ ' for the order with order id ' + @orderid + '.';
			revert
		END
	END
GO

create trigger UpdatedQuantity 
ON OrderItem
FOR UPDATE
AS
	IF UPDATE(Quantity)
	BEGIN
		DECLARE @orderid VARCHAR(255);
		DECLARE @total DECIMAL(19,2);

		DECLARE @cursor CURSOR;

		SET @cursor = CURSOR FOR
		SELECT Order_id FROM inserted

		OPEN @cursor
		FETCH next FROM @cursor INTO @orderid

		WHILE @@fetch_status = 0
		BEGIN
			select @total = Total FROM
			(select Order_id, SUM(CAST(PaidPrice * Quantity as DECIMAL(19,2))) as Total FROM OrderItem WHERE Order_id = @orderid GROUP BY Order_id) as tempTable;
		
			UPDATE [ORDER]
			SET Total_Amount = @total
			WHERE Order_id = @orderid;

			FETCH next FROM @cursor INTO @orderid
		END
		close @cursor
		deallocate @cursor
	END
GO

-- When an order item is removed, add OrderItem.Quantity back to Product.Quantity
create trigger DeleteOrderItemTrigger
ON OrderItem
FOR DELETE
AS
		DECLARE @productid VARCHAR(255);
		DECLARE @quantity INT;
		DECLARE @cursor CURSOR;
		SET @cursor = CURSOR FOR
		SELECT Product_id, Quantity FROM deleted

		OPEN @cursor
		FETCH next FROM @cursor INTO @productid, @quantity

		WHILE @@fetch_status = 0
		BEGIN
			UPDATE PRODUCT
			SET Quantity = Quantity + @quantity
			WHERE Product_id = @productid;
			
			FETCH next FROM @cursor INTO @productid, @quantity
		END
		close @cursor
		deallocate @cursor
GO

-- procedure for Customer Service Rep to use to delete from OrderItem
create procedure deleteOrderItem
	@orderid VARCHAR(255)
AS
		DELETE FROM OrderItem -- delete normally
		WHERE Order_id = (select Order_id from [Order] o WHERE o.Order_id = @orderid AND Status = 'in preparation')

		DELETE FROM [Order] -- delete normally
		WHERE NOT EXISTS (select 1 from [Order] o JOIN OrderItem oi on oi.Order_id = o.Order_id WHERE o.Order_id = @orderid)
		AND Order_id = @orderid
				
GO

-- procedure for Customer Service Rep to use to update quantity of an OrderItem
create procedure updateQuantityOrderItem
	@quantity INT,
	@orderid VARCHAR(255)
AS
		UPDATE OrderItem
		SET Quantity = @quantity
		WHERE Order_id = (select Order_id from [Order] o WHERE o.Order_id = @orderid AND Status = 'in preparation')			
GO

-- procedure for Customer Service Rep to use to insert an OrderItem
create procedure InsertOrderItem
	@orderid VARCHAR(255),
	@productid VARCHAR(255),
	@quantity INT
AS
		IF EXISTS (select 1 from [Order] o WHERE o.Order_id = @orderid AND Status = 'in preparation')
		BEGIN
			INSERT INTO OrderItem (Order_id, Product_id, Quantity)
			VALUES (@orderid, @productid, @quantity);
		END					
GO

-- trigger for Sales Manager to remove a product if quantity is 0
create trigger deleteProductView on ProductVW
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @productid VARCHAR(255)
	select @productid = Product_id from deleted;
	IF (select 1 from Product WHERE Product_id = @productid and Quantity = 0) = 1
	BEGIN
		DELETE FROM Product WHERE Product_id = @productid;
	END
END
GO

-- trigger for Sales/ Sales Manager to update a product.
create trigger updateProductView on ProductVW
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @cost_price VARCHAR(30);
	DECLARE @productid VARCHAR(255);
	IF UPDATE(Cost_Price)
	BEGIN
		set @productid = (select Product_id from inserted)
		set @cost_price = (select CONVERT(VARCHAR(30), Cost_Price) from inserted)
		UPDATE Product set Cost_Price =  EncryptByAsymkey(ASYMKEY_ID('AsymKey'),@cost_price) WHERE Product_id = @productid
	END
	ELSE IF UPDATE(Sales_Price)
	BEGIN
		set @productid = (select Product_id from inserted)
		UPDATE Product set Sales_Price = (select Sales_Price from inserted) where Product_id = @productid
	END
	ELSE IF UPDATE(Discount)
	BEGIN
		set @productid = (select Product_id from inserted)
		UPDATE Product set Discount = (select Discount from inserted) where Product_id = @productid
	END
	ELSE IF UPDATE(Description)
	BEGIN
		set @productid = (select Product_id from inserted)
		UPDATE Product set Description = (select Description from inserted) where Product_id = @productid
	END
	ELSE IF UPDATE(Quantity)
	BEGIN
		set @productid = (select Product_id from inserted)
		UPDATE Product set Quantity = (select Quantity from inserted) where Product_id = @productid
	END
	ELSE IF UPDATE(Name)
	BEGIN
		set @productid = (select Product_id from inserted)
		UPDATE Product set Name = (select Name from inserted) where Product_id = @productid
	END
	ELSE IF UPDATE(Product_id)
	BEGIN
		set @productid = (select Product_id from inserted)
		UPDATE Product set Product_id = (select Product_id from inserted) where Product_id = @productid
	END
END
GO
-- trigger for Sales/ Sales Manager to insert a product.
create trigger insertProductView on ProductVW
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @cost_price VARCHAR(30);
	set @cost_price = (select CONVERT(VARCHAR(30), Cost_Price) from inserted)
	INSERT INTO PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) 
	SELECT Product_id, Name, Quantity, Description, EncryptByAsymkey(ASYMKEY_ID('AsymKey'),@cost_price) as Cost_Price, Sales_Price, Discount FROM inserted;
END
GO

-- trigger for inserting into CreditCardVW for Customers (just encrypts the credit card number).
CREATE TRIGGER insertCCView on CreditCardVW
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) 
	SELECT Credit_Card_ID, EncryptByAsymkey(ASYMKEY_ID('AsymKey'), Credit_Card_Number) as Credit_Card_Number, 
		Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID FROM inserted;
END