create database if not exists communal_payments;

USE communal_payments;

DROP TABLE flat;

CREATE TABLE IF NOT exists flat
(
    flat_id        int     NOT NULL AUTO_INCREMENT,
    square         int     NOT NULL,
    has_boiler     boolean DEFAULT FALSE,
    celling_height int     NOT NULL,
    primary key (flat_id)
) ENGINE InnoDB;

CREATE TABLE tenant
(
    tenant_id  INT          NOT NULL AUTO_INCREMENT,
    birth_date DATE         NOT NULL,
    name       VARCHAR(255) NOT NULL,
    country    VARCHAR(255) NOT NULL,
    PRIMARY KEY(tenant_id)
);

CREATE TABLE flat_registration
(
    flat_registration_id int           NOT NULL AUTO_INCREMENT,
    flat_id              int           NOT NULL,
    tenant_id            int           NOT NULL,
    registration_date    date DEFAULT NULL,
    expiry_date          date          DEFAULT NULL,
    PRIMARY KEY(flat_registration_id),
    FOREIGN KEY(flat_id) REFERENCES flat(flat_id),
    FOREIGN KEY(tenant_id) REFERENCES tenant(tenant_id)
);

CREATE TABLE utility_bill_rate
(
    utility_bill_rate_id INT          NOT NULL AUTO_INCREMENT,
    name                 varchar(255) NOT NULL,
    cost                 int          NOT NULL,
    PRIMARY KEY(utility_bill_rate_id)
);

CREATE TABLE bill
(
    bill_id              INT NOT NULL AUTO_INCREMENT,
    flat_id              INT NOT NULL,
    utility_bill_rate_id INT NOT NULL,
    date                 DATE NOT NULL,
    payed_at             date DEFAULT NULL,
    unit_usage           int  NOT NULL,
    price                int  NOT NULL,
    PRIMARY KEY(bill_id),
    FOREIGN KEY(flat_id) references flat(flat_id),
    FOREIGN KEY(utility_bill_rate_id) references utility_bill_rate(utility_bill_rate_id)
);


