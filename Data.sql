-- Name: James Scruggs
-- File: Data.sql
-- Date: 4/26/19
-- Class: CSCI 6560
USE [Dot]
GO
-- data for customer table
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('ageach5', 'ageach5@unesco.org', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '9861h74t'), 'Arvy', 'Geach', '63 Anzinger Plaza', '149-252-1017')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('amcgarrieb', 'amcgarrieb@youtu.be', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '72eup92RX'), 'Armi', 'McGarrie', '26352 Saint Paul Alley', '770-997-8351')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('bkubasek9', 'bkubasek9@altervista.org', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '48UG628w0'), 'Barbaraanne', 'Kubasek', '9129 Shoshone Pass', '154-639-8647')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('bucchinoa', 'bucchinoa@shop-pro.jp', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '12eUU31F2'), 'Bellina', 'Ucchino', '357 Loomis Parkway', '463-931-5963')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('dscyner1', 'dscyner1@alexa.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '88BqW354'), 'Dido', 'Scyner', '2 Sheridan Road', '542-362-2101')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('egentner2', 'egentner2@bizjournals.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '48f8o99PP'), 'Elenore', 'Gentner', '7615 Hansons Avenue', '827-232-3144')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('hcorben6', 'hcorben6@amazon.co.jp', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '531Bw66eo'), 'Honey', 'Corbe', '8 Golden Leaf Plaza', '141-909-3406')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('jlecordier0', 'jlecordier0@flickr.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '66qUJ16M2'), 'Jacinthe', 'Lecordier', '4119 Sycamore Point', '813-811-1118')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('lperee', 'lperee@webeden.co.uk', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '27fHx178o'), 'Lishe', 'Pere', '9056 Bluestem Point', '264-264-6896')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('mbuxcyc', 'mbuxcyc@usnews.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '10HLa22jD'), 'Mege', 'Buxcy', '30 Southridge Terrace', '293-988-5156')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('mcarrel3', 'mcarrel3@prnewswire.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '47deY878t'), 'Marrilee', 'Carrel', '3537 Kings Pass', '900-913-7113')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('mratcliff4', 'mratcliff4@wsj.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '59prw11AJ'), 'Mega', 'Ratcliff', '316 Barnett Crossing', '818-467-6902')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('rrummings8', 'rrummings8@is.gd', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '22t2c93dr'), 'Rochella', 'Rummings', '7 Aberg Hill', '827-299-1975')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('rtalmadge7', 'rtalmadge7@unesco.org', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '58DZI95FS'), 'Rosella', 'Talmadge', '75 Maywood Park', '325-281-2815')
insert into CUSTOMER (UserID, Email, Password, Firstname, Lastname, Address, Phone) values ('rvasyukhind', 'rvasyukhind@domainmarket.com', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '17wEp13dy'), 'Rachele', 'Vasyukhi', '38 Summerview Circle', '476-874-8051')

-- data for creditcard table
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('07kTm85Yu', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3555328550601056'), 'Lianne Aggas', CAST('2022-09-08' AS Date), 402, '44 Arrowood Court', 'mbuxcyc')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('14kDO82JQ', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3546345114437613'), 'Tasia Krystek', CAST('2021-11-09' AS Date), 469, '04 Vidon Plaza', 'jlecordier0')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('170Sr36hq', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3576877628317090'), 'Nikkie Gallie', CAST('2021-10-17' AS Date), 632, '80 Texas Way', 'egentner2')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('19Vb796no', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '5010122853902236'), 'Vyky Delepine', CAST('2022-08-05' AS Date), 897, '3 Acker Park', 'ageach5')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('24Ode36TE', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '6304124601602902'), 'Stacy Groomebridge', CAST('2022-07-03' AS Date), 155, '3 Reindahl Court', 'bkubasek9')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('29TIE98Qf', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3581735075853277'), 'Decca Mustchi', CAST('2021-04-12' AS Date), 24, '82544 Lakewood Center', 'lperee')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('33rkP93jT', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3568397925049353'), 'Bernice Brandrick', CAST('2021-01-01' AS Date), 367, '3487 Lillian Alley', 'mratcliff4')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('35CoG60KY', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3577549904810580'), 'Giustino Fleming', CAST('2020-12-28' AS Date), 225, '0 Briar Crest Place', 'rrummings8')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('39JKG89hf', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3530095555340739'), 'Kelsey Bakster', CAST('2021-07-07' AS Date), 582, '02 Fallview Trail', 'bucchinoa')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('43CgK266w', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '6771091185988904'), 'Corabelle Haddingto', CAST('2021-01-06' AS Date), 121, '35427 Walton Circle', 'rtalmadge7')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('468cp79EK', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '30288713689334'), 'Pauly Venny', CAST('2021-09-06' AS Date), 228, '68482 Fairview Center', 'dscyner1')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('48al567vG', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3589454896686187'), 'Henka Danbye', CAST('2020-04-23' AS Date), 510, '9446 Brickson Park Parkway', 'mcarrel3')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('79Dhv56NO', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3567184515094887'), 'Faustine Tayspell', CAST('2021-03-16' AS Date), 36, '5 Center Plaza', 'hcorben6')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('88gfs35gH', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3572399719652792'), 'Vanya Gooder', CAST('2021-10-31' AS Date), 715, '0023 Crescent Oaks Avenue', 'amcgarrieb')
insert into CREDITCARD (Credit_Card_ID, Credit_Card_Number, Holder_Name, Expire_Date, CVC_Code, Billing_Address, OwnerID) values ('92dIW56SS', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), '3553528027124168'), 'Burnard Ingerfield', CAST('2020-08-25' AS Date), 362, '23608 Warbler Center', 'rvasyukhind')

-- data for product table
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('13LWE52iM', 'Nougat - Paste / Cream', 10, 'Aliquam sit amet diam in magna bibendum imperdiet.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 76.52)), CAST(80.10 AS Decimal(19, 2)), 0.21)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('228Ju36wk', 'Cake - Cheese Cake 9 Inch', 3, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 69.28)), CAST(74.30 AS Decimal(19, 2)), 0.43)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('53Tjr78bl', 'Wine - Fino Tio Pepe Gonzalez', 10, 'Quisque porta volutpat erat.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 73.07)), CAST(31.00 AS Decimal(19, 2)), 0.37)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('56Cdf63He', 'Carbonated Water - Orange', 19, 'Sed sagittis.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 19.72)), CAST(54.96 AS Decimal(19, 2)), 0.41)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('56d8h872b', 'Oranges - Navel, 72', 18, 'Curabitur at ipsum ac tellus semper interdum.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 66.86)), CAST(86.06 AS Decimal(19, 2)), 0.22)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('61jvK03rB', 'Bread Cranberry Foccacia', 3, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 77.72)), CAST(89.97 AS Decimal(19, 2)), 0.04)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('62inP67VB', 'Flour - So Mix Cake White', 5, 'Quisque ut erat.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 56.98)), CAST(90.97 AS Decimal(19, 2)), 0.05)
insert into PRODUCT (Product_id, Name, Quantity, Description, Cost_Price, Sales_Price, Discount) values ('96VwR09EC', 'Bread Fig And Almond', 8, 'Aenean sit amet justo.', EncryptByAsymkey(ASYMKEY_ID('AsymKey'), CONVERT(VARCHAR(30), 75.01)), CAST(15.36 AS Decimal(19, 2)), 0.1)

-- data for orderitem table
--insert into ORDERITEM (Order_id, Product_id, Quantity) values ('3e9t22mx', '13LWE52iM', 2);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('2j4l87je', '228Ju36wk', 4);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('4z1m09dn', '53Tjr78bl', 5);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('2v1m98fm', '56Cdf63He', 3);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('9q7a91yc', '56d8h872b', 10);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('0e1d86cz', '61jvK03rB', 7);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('7l6e87yr', '62inP67VB', 10);
insert into ORDERITEM (Order_id, Product_id, Quantity) values ('2b7a66tk', '96VwR09EC', 4);


-- data for order table
--insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('3e9t22mx', 'ageach5', CAST('1-11-2019' as DATE), '19Vb796no', '28 Algoma Center', 'placed');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('2j4l87je', 'amcgarrieb', CAST('1-22-2019' as DATE), '88gfs35gH', '9644 Menomonie Hill', 'in preparation');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('4z1m09dn', 'bkubasek9', CAST('2-24-2019' as DATE), '24Ode36TE', '60 Cardinal Terrace', 'in preparation');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('2v1m98fm', 'bucchinoa', CAST('3-13-2019' as DATE), '39JKG89hf', '4001 Beilfuss Junction', 'placed');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('9q7a91yc', 'mratcliff4', CAST('12-2-2018' as DATE), '33rkP93jT', '891 Nancy Pass', 'shipped');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('0e1d86cz', 'hcorben6', CAST('3-21-2019' as DATE), '79Dhv56NO', '8190 Maple Wood Hill', 'ready to ship');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('7l6e87yr', 'lperee', CAST('12-2-2018' as DATE), '29TIE98Qf', '549 Fairview Lane', 'shipped');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('2b7a66tk', 'rvasyukhind', CAST('2-21-2019' as DATE), '92dIW56SS', '362 Chinook Court', 'ready to ship');
insert into [ORDER] (Order_id, UserID, Order_Date, Credit_Card_ID, Shipping_address, Status) values ('th15h3r3', 'hcorben6', CAST('3-14-2019' as DATE), '79Dhv56NO', '107 Elm Street', 'in preparation');
