-- Restaurant
CREATE TABLE Restaurant (
    id INTEGER NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    address VARCHAR2(128) NOT NULL,
    CONSTRAINT pk_restaurant PRIMARY KEY (id),
    CONSTRAINT u_phone UNIQUE (phone_number),
    CONSTRAINT u_address UNIQUE (address)
);

INSERT INTO Restaurant (id, phone_number, address) VALUES (1, '+18148654700', '201 Old Main, University Park, PA 16802');
INSERT INTO Restaurant (id, phone_number, address) VALUES (2, '+16106483200', '30 East Swedesford Rd, Malvern, PA 19355');

-- MenuItem
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

INSERT INTO MenuItem (id, name, description, price, contains_alcohol) VALUES (1, 'Deluxe Bacon Cheeseburger', 'Fresh beef patties, two strips of crisp bacon, smoked American cheese, fresh romaine, tomatoes, Pittsburgh pickles, onion, mayo on a buttery bun.', 1499, 'N');
INSERT INTO MenuItem (id, name, description, price, contains_alcohol) VALUES (2, 'Corona', 'Corona Beer, imported from the fridge', 799, 'Y');

-- StaffMember
CREATE TABLE StaffMember (
    id INTEGER NOT NULL ,
    first_name VARCHAR2(32) NOT NULL,
    last_name VARCHAR2(32) NOT NULL,
    hashed_password VARCHAR(256) NOT NULL,
    date_of_birth DATE,
    CONSTRAINT pk_staff_member PRIMARY KEY (id)
);

INSERT INTO StaffMember (id, first_name, last_name, hashed_password, date_of_birth) VALUES (1, 'John', 'Doe', 'NuB97FRxeivdYJi2gwNwlA==', TO_DATE('1855/02/02', 'yyyy/mm/dd'));
INSERT INTO StaffMember (id, first_name, last_name, hashed_password, date_of_birth) VALUES (2, 'Jane', 'Doe', 'NuB97FRxeivdYJi2gwNwlA==', TO_DATE('2000/01/01', 'yyyy/mm/dd'));

-- RoleMapping
CREATE TABLE RoleMapping (
    staff_id INTEGER NOT NULL,
    role_name VARCHAR2(32) NOT NULL,
    CONSTRAINT pk_role_mapping PRIMARY KEY (staff_id, role_name),
    CONSTRAINT fk_staff_id FOREIGN KEY (staff_id) REFERENCES StaffMember (id)
);

INSERT INTO RoleMapping (staff_id, role_name) VALUES (1, 'manager');
INSERT INTO RoleMapping (staff_id, role_name) VALUES (1, 'server');
INSERT INTO RoleMapping (staff_id, role_name) VALUES (1, 'kithcen_staff');
INSERT INTO RoleMapping (staff_id, role_name) VALUES (2, 'server');

-- CustomerContactInfo
CREATE TABLE CustomerContactInfo (
    phone_number VARCHAR2(20) NOT NULL PRIMARY KEY,
    name VARCHAR2(64) NOT NULL
);

INSERT INTO CustomerContactInfo (phone_number, name) VALUES ('+18148654700', 'John Doe');
INSERT INTO CustomerContactInfo (phone_number, name) VALUES ('+16106483200', 'Jane Doe');

CREATE TABLE CustomerIdentification (
    id_number VARCHAR2(20) NOT NULL,
    date_of_birth DATE,
    first_name VARCHAR2(32) NOT NULL,
    last_name VARCHAR2(32) NOT NULL,
    CONSTRAINT pk_customer_id PRIMARY KEY (id_number)
);

INSERT INTO CustomerIdentification (id_number, date_of_birth, first_name, last_name) VALUES ('I1234568', TO_DATE('1855/02/02', 'yyyy/mm/dd'), 'John', 'Doe');
INSERT INTO CustomerIdentification (id_number, date_of_birth, first_name, last_name) VALUES ('S-123-456-57-901-0', TO_DATE('1957/01/12', 'yyyy/mm/dd'), 'Jane', 'Doe');

CREATE TABLE WaitQueue (
    id INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    type VARCHAR2(12) NOT NULL,
    CONSTRAINT pk_wait_queue PRIMARY KEY (id),
    CONSTRAINT type_valid_values CHECK (type = 'walk-in' OR type = 'reservation'),
    CONSTRAINT u_restaurant_type UNIQUE (restaurant_id, type),
    CONSTRAINT fk_wait_queue_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id)
);

INSERT INTO WaitQueue (id, restaurant_id, type) VALUES (1, 1, 'walk-in');
INSERT INTO WaitQueue (id, restaurant_id, type) VALUES (2, 1, 'reservation');
INSERT INTO WaitQueue (id, restaurant_id, type) VALUES (3, 2, 'walk-in');
INSERT INTO WaitQueue (id, restaurant_id, type) VALUES (4, 2, 'reservation');

CREATE TABLE PartyInQueue (
    id INTEGER NOT NULL,
    wait_queue_id INTEGER NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    party_size INTEGER NOT NULL,
    priority INTEGER NOT NULL,
    status VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_party_in_queue PRIMARY KEY (id),
    CONSTRAINT pos_party_size CHECK (party_size > 0),
    CONSTRAINT enum_status CHECK (status IN ('waiting', 'contacted', 'completed')),
    CONSTRAINT fk_wait_queue_id FOREIGN KEY (wait_queue_id) REFERENCES WaitQueue (id),
    CONSTRAINT fk_phone_number FOREIGN KEY (phone_number) REFERENCES CustomerContactInfo (phone_number)
);

INSERT INTO PartyInQueue (id, wait_queue_id, phone_number, party_size, priority, status) VALUES (1, 1, '+18148654700', 1, 1, 'completed');
INSERT INTO PartyInQueue (id, wait_queue_id, phone_number, party_size, priority, status) VALUES (2, 1, '+16106483200', 5, 2, 'waiting');

CREATE TABLE OfferedItems (
    restaurant_id INTEGER NOT NULL,
    menu_item_id INTEGER NOT NULL,
    CONSTRAINT pk_offered_items PRIMARY KEY (restaurant_id, menu_item_id),
    CONSTRAINT fk_offered_item_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id),
    CONSTRAINT fk_offered_item_menu_item FOREIGN KEY (menu_item_id) REFERENCES MenuItem (id)
);

INSERT INTO OfferedItems (restaurant_id, menu_item_id) VALUES (1, 1);
INSERT INTO OfferedItems (restaurant_id, menu_item_id) VALUES (1, 2);
INSERT INTO OfferedItems (restaurant_id, menu_item_id) VALUES (2, 1);

CREATE TABLE RestaurantTable (
    restaurant_id INTEGER NOT NULL,
    name VARCHAR(32) NOT NULL,
    width FLOAT NOT NULL,
    length FLOAT NOT NULL,
    CONSTRAINT pos_width CHECK (width > 0),
    CONSTRAINT pos_length CHECK (length > 0),
    CONSTRAINT pk_table PRIMARY KEY (restaurant_id, name),
    CONSTRAINT fk_restaurant_table_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id)
);

INSERT INTO RestaurantTable (restaurant_id, name, width, length) VALUES (1, 'Booth 1', 1, 1.5);
INSERT INTO RestaurantTable (restaurant_id, name, width, length) VALUES (1, 'Booth 2', 1, 1.5);
INSERT INTO RestaurantTable (restaurant_id, name, width, length) VALUES (1, 'Floor 1', 1, 1);

CREATE TABLE TableMap (
    restaurant_id INTEGER NOT NULL,
    name VARCHAR(32) NOT NULL,
    CONSTRAINT pk_table_map PRIMARY KEY (restaurant_id, name),
    CONSTRAINT fk_table_map_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurant (id)
);

INSERT INTO TableMap (restaurant_id, name) VALUES (1, 'Weekday Layout A');
INSERT INTO TableMap (restaurant_id, name) VALUES (1, 'Christmas Eve 2023 layout');

CREATE TABLE TableMapItem (
    restaurant_id INTEGER NOT NULL,
    map_name VARCHAR(32) NOT NULL,
    table_name VARCHAR(32) NOT NULL,
    x_location FLOAT NOT NULL,
    y_location FLOAT NOT NULL,
    rotation FLOAT NOT NULL,
    CONSTRAINT pk_table_map_item PRIMARY KEY (restaurant_id, map_name, table_name),
    CONSTRAINT rotation_range CHECK (rotation > -360 AND rotation < 360),
    CONSTRAINT fk_map_item_restaurant_map FOREIGN KEY (restaurant_id, map_name) REFERENCES TableMap (restaurant_id, name),
    CONSTRAINT fk_map_item_restrauant_table FOREIGN KEY (restaurant_id, table_name) REFERENCES RestaurantTable (restaurant_id, name)
);

INSERT INTO TableMapItem (restaurant_id, map_name, table_name, x_location, y_location, rotation) VALUES (1, 'Weekday Layout A', 'Booth 1', 0, 0, 90);
INSERT INTO TableMapItem (restaurant_id, map_name, table_name, x_location, y_location, rotation) VALUES (1, 'Weekday Layout A', 'Booth 2', 2, 0, 90);
INSERT INTO TableMapItem (restaurant_id, map_name, table_name, x_location, y_location, rotation) VALUES (1, 'Weekday Layout A', 'Floor 1', 1, 5, 0);
