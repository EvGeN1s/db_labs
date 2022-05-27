#3.1 INSERT
#a) INSERT without column names
INSERT INTO tenant
VALUES (1, '1999-03-04 20:03:01', 'Petrov Ivan Ivanovich', 'Russia');

#b) INSERT with column names
INSERT INTO tenant (birth_date, name, country)
VALUES ('2002-06-04 13:15:01', 'Ivanov Alexander Petrovich', 'Russia'),
       ('1975-01-31 14:12:00', 'Lebron James Westowich', 'USA');

INSERT INTO flat (square, celling_height)
VALUES (45, 4);

INSERT INTO flat_registration (flat_id, tenant_id, registration_date)
    VALUE (
           2, 3, NOW()
    );

#c) INSERT from another table
#Create temp table
CREATE TABLE tenant2
(
    tenant_id INT AUTO_INCREMENT,
    name      VARCHAR(255) NOT NULL,
    PRIMARY KEY (tenant_id)
);

INSERT INTO tenant2(name)
SELECT name
FROM tenant;


#2 DELETE
#a) DELETE All Data from table
TRUNCATE tenant2;

#b) DELETE Data from table with condition
DELETE
FROM tenant2
WHERE name = 'Lebron James Westowich';

#3 UPDATE
#a) Update all values in table
UPDATE tenant
SET country = 'France';

#b) Update one attribute with condition
UPDATE tenant
SET birth_date='1999-01-01 00:00:00'
WHERE country = 'USA';

#c) Update few attributes in table
UPDATE tenant
SET birth_date='2000-03-04 04:20:00',
    country='USSR'
WHERE birth_date > '2000-00-00 00:00:00'
  AND country = 'Russia';

#4 SELECT
#a) Select few rows from table
SELECT name, birth_date
FROM tenant;

#b) Select all row from table
SELECT *
FROM tenant;

#c) Select all rows with condition (6.a)
SELECT *
FROM tenant
WHERE birth_date < '2000-01-01 00:00:00';

#5 SELECT with order
#a) Order by
SELECT *
FROM tenant
ORDER BY name
LIMIT 2;

#b) Order by DESC
SELECT *
FROM tenant
ORDER BY name DESC;

#c) Order by few attributes
SELECT *
FROM tenant
ORDER BY birth_date, country
LIMIT 2;

#d) Order by top
SELECT name, birth_date, country
FROM tenant
ORDER BY name;

#6 Work with date
#b) SELECT with data limits
SELECT *
FROM tenant
WHERE birth_date > '1999-01-01 00:00:00'
  AND birth_date < '2001-01-01 00:00:00';

#c) SELECT Year from datetime value
SELECT name, YEAR(birth_date) AS birth_year
FROM tenant;

#7 Aggregation functions
#a) COUNT
SELECT COUNT(*) AS total_values
FROM tenant;

#b) COUNT unic values
SELECT COUNT(DISTINCT (YEAR(birth_date))) AS total_unic_birth_years
FROM tenant;

#c) Show unic values
SELECT DISTINCT(YEAR(birth_date))
FROM tenant;

#d) Max value
SELECT MAX(birth_date)
FROM tenant;

#e) Min value
SELECT MIN(name)
FROM tenant;

#f) COUNT() + GROUP BY
SELECT COUNT(*)
FROM tenant
GROUP BY country;

#8 SELECT GROUP BY + HAVING
#SELECT

#9 JOIN
#a) LEFT JOIN + WHERE
SELECT *
FROM flat f
         LEFT JOIN flat_registration fr ON f.flat_id = fr.flat_id
WHERE f.celling_height < 4;

#b) Same as a) RIGHT JOINS
SELECT *
FROM flat_registration fr
         RIGHT JOIN flat f ON f.flat_id = fr.flat_id
WHERE f.celling_height < 4;

#c) LEFT JOIN + WHERE for evry table
SELECT *
FROM flat f
         LEFT JOIN flat_registration fr ON f.flat_id = fr.flat_id
WHERE f.celling_height < 4
  AND fr.expiry_date IS NULL;

#d) INNER JOIN
SELECT *
FROM flat f
         INNER JOIN flat_registration fr ON f.flat_id = fr.flat_id
WHERE f.celling_height > 3;

#10 Sub requests
#a) WHERE IN
SELECT f.flat_id
FROM flat f
         INNER JOIN flat_registration fr on f.flat_id = fr.flat_id
WHERE flat_registration_id IN (
    SELECT flat_registration_id
    FROM flat_registration
             INNER JOIN tenant t ON flat_registration.tenant_id = t.tenant_id
    WHERE t.birth_date < '2000-00-00 00:00:00'
);

#b) Sub request in select params
SELECT name, birth_date, (SELECT MAX(birth_date) FROM tenant) AS older
FROM tenant;


#c) SELECT sub request
SELECT MAX(birth_date)
FROM (SELECT t.birth_date
      FROM flat_registration fr
               INNER JOIN tenant t on fr.tenant_id = t.tenant_id
      WHERE expiry_date IS NULL) AS birth_dates;

#d) JOIN sub request
SELECT MAX(flat.celling_height)
FROM flat
         JOIN (SELECT celling_height
               FROM flat f
                        INNER JOIN flat_registration fr ON f.flat_id = fr.flat_id
             WHERE fr.expiry_date IS NULL ) AS j

