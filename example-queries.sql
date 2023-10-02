-- Query 1
SELECT MenuItem.name, OrderItem.quantity, OrderItem.notes, OrderItem.order_id, RestaurantOrder.table_name
FROM OrderItem
JOIN MenuItem
ON OrderItem.menu_item_id = MenuItem.id
JOIN RestaurantOrder
ON OrderItem.order_id = RestaurantOrder.id
WHERE OrderItem.status = 'placed' AND RestaurantOrder.restaurant_id = 1
ORDER BY OrderItem.order_id ASC;

-- Query 2
SELECT RestaurantOrder.server_id, SUM(CreditCardTransaction.gratuity_amount) AS total_gatuity
FROM CreditCardTransaction
JOIN Transaction
ON Transaction.id = CreditCardTransaction.id
JOIN RestaurantOrder 
ON Transaction.order_id = RestaurantOrder.id
WHERE Transaction.status = 'paid'
GROUP BY RestaurantOrder.server_id;

-- Query 3
SELECT MenuItem.name, OrderItem.quantity, MenuItem.price AS price_per_item, OrderItem.quantity*MenuItem.price AS total_price
FROM OrderItem
JOIN MenuItem
ON OrderItem.menu_item_id = MenuItem.id
JOIN RestaurantOrder
ON OrderItem.order_id = RestaurantOrder.id
WHERE RestaurantOrder.id = 1;

-- Query 4
SELECT Reservation.table_name, Reservation.reservation_date_time, Restaurant.phone_number AS restaurant_phone_number, Restaurant.address 
FROM Reservation
JOIN Restaurant
ON Reservation.restaurant_id = Restaurant.id
WHERE Reservation.customer_phone_number = '+18148654700';

-- Query 5
SELECT RestaurantTable.name, RestaurantTable.occupancy
FROM RestaurantTable
WHERE RestaurantTable.restaurant_id = 1;

-- Query 6
SELECT TableMapItem.table_name, RestaurantTable.occupancy, TableMapItem.x_location, TableMapItem.y_location, RestaurantTable.width, RestaurantTable.length, TableMapItem.rotation
FROM TableMapItem
JOIN RestaurantTable
ON TableMapItem.restaurant_id = restauranttable.restaurant_id AND TableMapItem.table_name = restauranttable.name 
WHERE TableMapItem.restaurant_id = 1 AND TableMapItem.map_name='Map 1';

-- Query 7
SELECT CustomerContactInfo.name, PartyInQueue.phone_number, PartyInQueue.party_size, PartyInQueue.priority
FROM PartyInQueue
JOIN CustomerContactInfo
ON PartyInQueue.phone_number = CustomerContactInfo.phone_number
WHERE PartyInQueue.status = 'waiting' AND PartyInQueue.wait_queue_id IN (
    SELECT id
    FROM WaitQueue
    WHERE restaurant_id = 1 AND type='walk-in'
)
ORDER BY PartyInQueue.priority ASC;

-- Query 8

SELECT order_id, SUM(item_balance)
FROM (
    -- get price of food ordered for each order
    SELECT RestaurantOrder.id AS order_id, OrderItem.quantity*MenuItem.price AS item_balance
    FROM OrderItem
    JOIN MenuItem
    ON OrderItem.menu_item_id = MenuItem.id
    JOIN RestaurantOrder
    ON OrderItem.order_id = RestaurantOrder.id

    UNION

    -- get amount paid for each order 
    SELECT order_id, -amount as item_balance
    FROM Transaction 
    WHERE status='paid'
)
GROUP BY order_id
HAVING SUM(item_balance) > 0;