CREATE DATABASE inventory_rent;

USE inventory_rent;

CREATE TABLE inventory_type
(
    type_id integer      NOT NULL AUTO_INCREMENT,
    name    varchar(255) NOT NULL,
    PRIMARY KEY (type_id)
);

CREATE TABLE inventory
(
    inventory_id INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(255) NOT NULL,
    type_id      INT          NOT NULL,
    buying_price INT          NOT NULL,
    PRIMARY KEY (inventory_id),
    FOREIGN KEY (type_id) REFERENCES inventory_type (type_id)
);

CREATE TABLE inventory_rent_tariff
(
    inventory_rent_tariff_id INT  NOT NULL AUTO_INCREMENT,
    inventory_id             INT  NOT NULL,
    time                     TIME NOT NULL,
    price                    INT  NOT NULL,
    PRIMARY KEY (inventory_rent_tariff_id),
    FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id)
);



CREATE TABLE client
(
    client_id  INT          NOT NULL AUTO_INCREMENT,
    name       VARCHAR(255) NOT NULL,
    male       ENUM ('male', 'female'),
    birth_date DATE,
    PRIMARY KEY (client_id)
);

CREATE TABLE inventory_rent
(
    inventory_rent_id        INT      NOT NULL AUTO_INCREMENT,
    inventory_rent_tariff_id INT      NOT NULL,
    client_id                INT      NOT NULL,
    start_date               DATETIME NOT NULL,
    end_date                 DATETIME DEFAULT NULL,
    PRIMARY KEY (inventory_rent_id),
    FOREIGN KEY (inventory_rent_tariff_id) REFERENCES inventory_rent_tariff(inventory_rent_tariff_id),
    FOREIGN KEY (client_id) REFERENCES client(client_id)
);