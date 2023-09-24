INSERT INTO Restaurant (id,phone_number,address) VALUES (1, '+18148654700', '201 Old Main, University Park, PA 16802');
INSERT INTO Restaurant (id,phone_number,address) VALUES (2, '+16106483200', '30 East Swedesford Rd, Malvern, PA 19355');

INSERT INTO MenuItem (id,name,description,price,contains_alcohol) VALUES (1, 'Deluxe Bacon Cheeseburger', 'Fresh beef patties, two strips of crisp bacon, smoked American cheese, fresh romaine, tomatoes, Pittsburgh pickles, onion, mayo on a buttery bun.', 1499, 'N');
INSERT INTO MenuItem (id,name,description,price,contains_alcohol) VALUES (2, 'Corona', 'Corona Beer, imported from the fridge', 799, 'Y');

INSERT INTO StaffMember (id,first_name,last_name,hashed_password,date_of_birth) VALUES (1, 'John', 'Doe', 'NuB97FRxeivdYJi2gwNwlA==', TO_DATE('1855/02/02', 'yyyy/mm/dd'));
INSERT INTO StaffMember (id,first_name,last_name,hashed_password,date_of_birth) VALUES (2, 'Jane', 'Doe', 'NuB97FRxeivdYJi2gwNwlA==', TO_DATE('2000/01/01', 'yyyy/mm/dd'));

INSERT INTO RoleMapping (staff_id,role_name) VALUES (1,  'manager');
INSERT INTO RoleMapping (staff_id,role_name) VALUES (1,  'server');
INSERT INTO RoleMapping (staff_id,role_name) VALUES (1,  'kithcen_staff');
INSERT INTO RoleMapping (staff_id,role_name) VALUES (2,  'server');

INSERT INTO CustomerContactInfo (phone_number,name) VALUES ('+18148654700', 'John Doe');
INSERT INTO CustomerContactInfo (phone_number,name) VALUES ('+16106483200', 'Jane Doe');

INSERT INTO CustomerIdentification (id_number,date_of_birth,first_name,last_name) VALUES ('I1234568', TO_DATE('1855/02/02', 'yyyy/mm/dd'), 'John', 'Doe');
INSERT INTO CustomerIdentification (id_number,date_of_birth,first_name,last_name) VALUES ('S-123-456-57-901-0', TO_DATE('1957/01/12', 'yyyy/mm/dd'), 'Jane', 'Doe');

INSERT INTO WaitQueue (id,restaurant_id,type) VALUES (1, 1, 'walk-in');
INSERT INTO WaitQueue (id,restaurant_id,type) VALUES (2, 1, 'reservation');
INSERT INTO WaitQueue (id,restaurant_id,type) VALUES (3, 2, 'walk-in');
INSERT INTO WaitQueue (id,restaurant_id,type) VALUES (4, 2, 'reservation');

INSERT INTO PartyInQueue (id,wait_queue_id,phone_number,party_size,priority,status) VALUES (1, 1, '+18148654700', 1, 1, 'completed');
INSERT INTO PartyInQueue (id,wait_queue_id,phone_number,party_size,priority,status) VALUES (2, 1, '+16106483200', 5, 2, 'waiting');

INSERT INTO OfferedItems (restaurant_id,menu_item_id) VALUES (1, 1);
INSERT INTO OfferedItems (restaurant_id,menu_item_id) VALUES (1, 2);
INSERT INTO OfferedItems (restaurant_id,menu_item_id) VALUES (2, 1);

INSERT INTO RestaurantTable (restaurant_id,name,width,length) VALUES (1, 'Booth 1', 1, 1.5);
INSERT INTO RestaurantTable (restaurant_id,name,width,length) VALUES (1, 'Booth 2', 1, 1.5);
INSERT INTO RestaurantTable (restaurant_id,name,width,length) VALUES (1, 'Floor 1', 1, 1);

INSERT INTO TableMap (restaurant_id,name) VALUES (1, 'Weekday Layout A');
INSERT INTO TableMap (restaurant_id,name) VALUES (1, 'Christmas Eve 2023 layout');

INSERT INTO TableMapItem (restaurant_id,map_name,table_name,x_location,y_location,rotation) VALUES (1, 'Weekday Layout A', 'Booth 1', 0, 0, 90);
INSERT INTO TableMapItem (restaurant_id,map_name,table_name,x_location,y_location,rotation) VALUES (1, 'Weekday Layout A', 'Booth 2', 2, 0, 90);
INSERT INTO TableMapItem (restaurant_id,map_name,table_name,x_location,y_location,rotation) VALUES (1, 'Weekday Layout A', 'Floor 1', 1, 5, 0);

INSERT INTO Reservation (restaurant_id,table_name,reservation_date_time,customer_phone_number) VALUES (1, 'Booth 1', TO_DATE('1855/02/02', 'yyyy/mm/dd'), '+18148654700');
INSERT INTO Reservation (restaurant_id,table_name,reservation_date_time,customer_phone_number) VALUES (1, 'Booth 2', TO_DATE('2000/01/01', 'yyyy/mm/dd'), '+18148654700');

INSERT INTO RestaurantOrder (id,restaurant_id,server_id,table_name) VALUES (1, 1, 1, NULL);
INSERT INTO RestaurantOrder (id,restaurant_id,server_id,table_name) VALUES (2, 1, 1, NULL);
INSERT INTO RestaurantOrder (id,restaurant_id,server_id,table_name) VALUES (3, 1, 2, 'Booth 1');
INSERT INTO RestaurantOrder (id,restaurant_id,server_id,table_name) VALUES (4, 1, 2, 'Booth 2');

INSERT INTO OrderItem (id,order_id,menu_item_id,customer_id,quantity,notes,status) VALUES (1, 3, 2, 'I1234568', 3, '', 'served');
INSERT INTO OrderItem (id,order_id,menu_item_id,customer_id,quantity,notes,status) VALUES (2, 3, 1, NULL, 2, 'add cheese', 'placed');
INSERT INTO OrderItem (id,order_id,menu_item_id,customer_id,quantity,notes,status) VALUES (3, 1, 1, 'S-123-456-57-901-0', 2, '', 'served');

INSERT INTO Transaction (id,order_id,amount,transaction_type,status) VALUES (1, 1, 30000, 'credit', 'pre-approved');
INSERT INTO Transaction (id,order_id,amount,transaction_type,status) VALUES (2, 2, 30000, 'credit', 'pre-approved');
INSERT INTO Transaction (id,order_id,amount,transaction_type,status) VALUES (3, 3, 6095, 'gift_card', 'paid');
INSERT INTO Transaction (id,order_id,amount,transaction_type,status) VALUES (4, 1, 1598, 'gift_card', 'unpaid');

INSERT INTO GiftCardTransaction (id,gift_card_number,expiration_month,expiration_year) VALUES (3, 400012345678910, 01, 1885);
INSERT INTO GiftCardTransaction (id,gift_card_number,expiration_month,expiration_year) VALUES (4, 400012345678910, 01, 1885);

INSERT INTO CreditCardTransaction (id,credit_card_number,name_on_card,expiration_month,expiration_year,cvv,gratuity_amount) VALUES (1, 400012345678910, 'John A Doe', 01, 1885, 123, 1000);
INSERT INTO CreditCardTransaction (id,credit_card_number,name_on_card,expiration_month,expiration_year,cvv,gratuity_amount) VALUES (2, 400012345678910, 'John A Doe', 01, 1885, 123, 0);
