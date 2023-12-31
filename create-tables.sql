CREATE TABLE Restaurant (
    id INTEGER NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    address VARCHAR2(128) NOT NULL,
    CONSTRAINT pk_restaurant PRIMARY KEY (id),
    CONSTRAINT u_phone UNIQUE (phone_number),
    CONSTRAINT u_address UNIQUE (address)
);

CREATE TABLE MenuItem (
    id INTEGER NOT NULL,
    name VARCHAR2(32) NOT NULL,
    description VARCHAR2(256) NOT NULL,
    price INTEGER NOT NULL,
    contains_alcohol Char(1),
    CONSTRAINT pk_menu_item PRIMARY KEY (id),
    CONSTRAINT u_name UNIQUE(name),
    CONSTRAINT u_description UNIQUE (description),
    CONSTRAINT pos_price CHECK (price > 0),
    CONSTRAINT contains_alcohol_y_n CHECK (contains_alcohol = 'Y' OR contains_alcohol = 'N')
);

CREATE TABLE StaffMember (
    id INTEGER NOT NULL ,
    first_name VARCHAR2(32) NOT NULL,
    last_name VARCHAR2(32) NOT NULL,
    hashed_password VARCHAR(256) NOT NULL,
    date_of_birth DATE,
    CONSTRAINT pk_staff_member PRIMARY KEY (id)
);

CREATE TABLE RoleMapping (
    staff_id INTEGER NOT NULL,
    role_name VARCHAR2(32) NOT NULL,
    CONSTRAINT pk_role_mapping PRIMARY KEY (staff_id, role_name),
    CONSTRAINT fk_staff_id FOREIGN KEY (staff_id) REFERENCES StaffMember (id)
);

CREATE TABLE CustomerContactInfo (
    phone_number VARCHAR2(20) NOT NULL,
    name VARCHAR2(64) NOT NULL,
    CONSTRAINT pk_customer_contact_info PRIMARY KEY (phone_number)  
);

CREATE TABLE CustomerIdentification (
    id_number VARCHAR2(20) NOT NULL,
    date_of_birth DATE,
    first_name VARCHAR2(32) NOT NULL,
    last_name VARCHAR2(32) NOT NULL,
    CONSTRAINT pk_customer_id PRIMARY KEY (id_number)
);

CREATE TABLE WaitQueue (
    id INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    type VARCHAR2(12) NOT NULL,
    CONSTRAINT pk_wait_queue PRIMARY KEY (id),
    CONSTRAINT fk_wait_queue_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id),
    CONSTRAINT type_valid_values CHECK (type = 'walk-in' OR type = 'reservation'),
    CONSTRAINT u_restaurant_type UNIQUE (restaurant_id, type)
);

CREATE TABLE PartyInQueue (
    id INTEGER NOT NULL,
    wait_queue_id INTEGER NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    party_size INTEGER NOT NULL,
    priority INTEGER NOT NULL,
    status VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_party_in_queue PRIMARY KEY (id),
    CONSTRAINT fk_party_wait_queue_id FOREIGN KEY (wait_queue_id) REFERENCES WaitQueue (id),
    CONSTRAINT fk_party_phone_number FOREIGN KEY (phone_number) REFERENCES CustomerContactInfo (phone_number),
    CONSTRAINT pos_party_size CHECK (party_size > 0),
    CONSTRAINT enum_party_status CHECK (status IN ('waiting', 'contacted', 'completed'))
);

CREATE TABLE OfferedItems (
    restaurant_id INTEGER NOT NULL,
    menu_item_id INTEGER NOT NULL,
    CONSTRAINT pk_offered_items PRIMARY KEY (restaurant_id, menu_item_id),
    CONSTRAINT fk_offered_item_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id),
    CONSTRAINT fk_offered_item_menu_item FOREIGN KEY (menu_item_id) REFERENCES MenuItem (id)
);

CREATE TABLE RestaurantTable (
    restaurant_id INTEGER NOT NULL,
    name VARCHAR(32) NOT NULL,
    width FLOAT NOT NULL,
    length FLOAT NOT NULL,
    occupancy INTEGER NOT NULL,
    CONSTRAINT pk_table PRIMARY KEY (restaurant_id, name),
    CONSTRAINT fk_restaurant_table_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id),
    CONSTRAINT pos_width CHECK (width > 0),
    CONSTRAINT pos_length CHECK (length > 0),
    CONSTRAINT pos_occupancy CHECK (occupancy > 0)
);


CREATE TABLE TableMap (
    restaurant_id INTEGER NOT NULL,
    name VARCHAR(32) NOT NULL,
    CONSTRAINT pk_table_map PRIMARY KEY (restaurant_id, name),
    CONSTRAINT fk_table_map_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id)
);

CREATE TABLE TableMapItem (
    restaurant_id INTEGER NOT NULL,
    map_name VARCHAR(32) NOT NULL,
    table_name VARCHAR(32) NOT NULL,
    x_location FLOAT NOT NULL,
    y_location FLOAT NOT NULL,
    rotation FLOAT NOT NULL,
    CONSTRAINT pk_table_map_item PRIMARY KEY (restaurant_id, map_name, table_name),
    CONSTRAINT fk_map_item_restaurant_map FOREIGN KEY (restaurant_id, map_name) REFERENCES TableMap (restaurant_id, name),
    CONSTRAINT fk_map_item_restrauant_table FOREIGN KEY (restaurant_id, table_name) REFERENCES RestaurantTable (restaurant_id, name),
    CONSTRAINT rotation_range CHECK (rotation > -360 AND rotation < 360)
);

CREATE TABLE Reservation (
    restaurant_id INTEGER NOT NULL,
    table_name VARCHAR2(32) NOT NULL,
    reservation_date_time DATE NOT NULL,
    customer_phone_number VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_reserve PRIMARY KEY (restaurant_id, table_name, reservation_date_time),
    CONSTRAINT fk_reserve_restrauant_id FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id),
    CONSTRAINT fk_reserve_restrauant_table FOREIGN KEY (restaurant_id, table_name) REFERENCES RestaurantTable (restaurant_id, name),
    CONSTRAINT fk_reserve_phone_number FOREIGN KEY (customer_phone_number) REFERENCES CustomerContactInfo (phone_number)
);

CREATE TABLE RestaurantOrder (
    id INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    server_id INTEGER NOT NULL,
    table_name VARCHAR2(32),
    CONSTRAINT pk_order PRIMARY KEY (id),
    CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id),
    CONSTRAINT fk_order_server FOREIGN KEY (server_id) REFERENCES StaffMember (id),
    CONSTRAINT fk_order_table FOREIGN KEY (restaurant_id, table_name) REFERENCES RestaurantTable (restaurant_id, name)
);

CREATE TABLE OrderItem (
    id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    menu_item_id INTEGER NOT NULL,
    customer_id VARCHAR2(20),
    quantity INTEGER NOT NULL,
    notes VARCHAR2(1024),
    status VARCHAR2(8),
    CONSTRAINT pk_order_item PRIMARY KEY (id),
    CONSTRAINT fk_order_item_order_id FOREIGN KEY (order_id) REFERENCES RestaurantOrder (id),
    CONSTRAINT fk_order_item_menu_item_id FOREIGN KEY (menu_item_id) REFERENCES MenuItem (id),
    CONSTRAINT fk_order_item_customer_id FOREIGN KEY (customer_id) REFERENCES CustomerIdentification (id_number),
    CONSTRAINT pos_order_quantity CHECK (quantity > 0),
    CONSTRAINT enum_order_item_status CHECK (status IN ('placed', 'ready', 'served'))
);

CREATE TABLE Transaction (
    id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    transaction_type VARCHAR2(10) NOT NULL,
    status VARCHAR2(12) NOT NULL,
    CONSTRAINT pk_transaction PRIMARY KEY (id),
    CONSTRAINT fk_transaction_order_id FOREIGN KEY (order_id) REFERENCES RestaurantOrder (id),
    CONSTRAINT pos_trans_amount CHECK (amount > 0),
    CONSTRAINT enum_transaction_type CHECK (transaction_type IN ('gift_card', 'cash', 'credit')),
    CONSTRAINT enum_transaction_status CHECK (status IN ('unpaid', 'pre-approved', 'paid'))
);

CREATE TABLE GiftCardTransaction (
    id INTEGER NOT NULL,
    gift_card_number NUMBER(16) NOT NULL,
    expiration_month INTEGER NOT NULL,
    expiration_year INTEGER NOT NULL,
    CONSTRAINT pk_gift_trans PRIMARY KEY (id),
    CONSTRAINT fk_gift_trans_id FOREIGN KEY (id) REFERENCES Transaction (id),
    CONSTRAINT gift_exp_month_range CHECK (expiration_month BETWEEN 1 AND 12)
);

CREATE TABLE CreditCardTransaction (
    id INTEGER NOT NULL,
    credit_card_number NUMBER(16) NOT NULL,
    name_on_card VARCHAR2(64) NOT NULL,
    expiration_month INTEGER NOT NULL,
    expiration_year INTEGER NOT NULL,
    cvv INTEGER NOT NULL,
    gratuity_amount INTEGER NOT NULL,
    CONSTRAINT pk_credit_trans PRIMARY KEY (id),
    CONSTRAINT fk_credit_trans_id FOREIGN KEY (id) REFERENCES Transaction (id),
    CONSTRAINT credit_exp_month_range CHECK (expiration_month BETWEEN 1 AND 12),
    CONSTRAINT credit_cvv_range CHECK (cvv BETWEEN 0 and 999),
    CONSTRAINT gratuity_amount_range CHECK (gratuity_amount >= 0)
);
