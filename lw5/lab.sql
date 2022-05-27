-- 1. Добавить внешние ключи
#booking
ALTER TABLE booking
    ADD FOREIGN KEY (id_client) REFERENCES client (id_client);

#room
ALTER TABLE room
    ADD FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel),
    ADD FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category);

#room_in_booking
ALTER TABLE room_in_booking
    ADD FOREIGN KEY (id_room) REFERENCES room (id_room),
    ADD FOREIGN KEY (id_booking) REFERENCES booking (id_booking);

-- 2.Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.
SELECT c.name, c.phone
FROM client c
         JOIN booking b ON c.id_client = b.id_client
         JOIN room_in_booking rib ON b.id_booking = rib.id_booking
         JOIN room r ON rib.id_room = r.id_room
         JOIN hotel h on r.id_hotel = h.id_hotel
         JOIN room_category rc ON r.id_room_category = rc.id_room_category
WHERE rc.name = 'Люкс'
  AND rib.checkout_date > '2019-04-01 00:00:00'
  AND rib.checkin_date < '2019-04-01 00:00:00'
  AND h.name = 'Космос';

-- Проверка что команата занята
-- 3.Дать список свободных номеров всех гостиниц на 22 апреля.
SELECT DISTINCT r.number, h.name
FROM room r
         JOIN room_in_booking rib on r.id_room = rib.id_room
         JOIN hotel h on h.id_hotel = r.id_hotel
WHERE rib.checkout_date < '2019-04-22 00:00:00';

-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров.
SELECT rc.name, COUNT(c.id_client)
FROM client c
         JOIN booking b ON c.id_client = b.id_client
         JOIN room_in_booking rib ON b.id_booking = rib.id_booking
         JOIN room r ON rib.id_room = r.id_room
         JOIN room_category rc ON r.id_room_category = rc.id_room_category
         JOIN hotel h ON h.id_hotel = r.id_hotel
WHERE h.name = 'Космос'
  AND rib.checkin_date < '2019-03-23 00:00:00'
  AND rib.checkout_date > '2019-03-23 00:00:00'
GROUP BY rc.name;

-- 5.Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда.
SELECT r.number, c.name, MAX(checkout_date)
FROM client c
         JOIN booking b ON c.id_client = b.id_client
         JOIN room_in_booking rib ON b.id_booking = rib.id_booking
         JOIN room r ON rib.id_room = r.id_room
         JOIN hotel h ON h.id_hotel = r.id_hotel
WHERE h.name = 'Космос'
  AND rib.checkout_date > '2019-03-31 00:00:00'
  AND rib.checkout_date < '2019-05-01 00:00:00'
GROUP BY r.number;

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.
UPDATE room_in_booking rib
    JOIN booking b ON rib.id_booking = b.id_booking
    JOIN room r ON rib.id_room = r.id_room
    JOIN room_category rc ON r.id_room_category = rc.id_room_category
    JOIN hotel h ON h.id_hotel = r.id_hotel
SET rib.checkout_date = ADDDATE(rib.checkout_date, INTERVAL 2 DAY)
WHERE h.name = 'Космос'
  AND rc.name = 'Бизнес'
  AND DATE(rib.checkin_date) = '2019-05-10';


-- Для проверки 6
SELECT r.number, DATE_ADD(rib.checkout_date, INTERVAL 2 DAY), checkout_date
FROM room_in_booking rib
         JOIN booking b ON rib.id_booking = b.id_booking
         JOIN room r ON rib.id_room = r.id_room
         JOIN room_category rc ON r.id_room_category = rc.id_room_category
         JOIN hotel h ON h.id_hotel = r.id_hotel
WHERE h.name = 'Космос'
  AND rc.name = 'Бизнес'
  AND DATE(rib.checkin_date) = '2019-05-10';

-- 7.Найти все "пересекающиеся" варианты проживания.
SELECT rib.id_room_in_booking, rib.id_booking, r.id_room, rib.checkin_date, rib.checkout_date, rib1.id_room_in_booking, rib1.id_booking, r2.id_room, rib1.checkin_date, rib1.checkout_date
    FROM room_in_booking rib
JOIN room_in_booking rib1 ON rib.id_room = rib1.id_room
JOIN room r on r.id_room = rib.id_room
JOIN room r2 on r2.id_room = rib1.id_room
WHERE (rib1.checkin_date <= rib.checkin_date AND rib1.checkout_date >= rib.checkin_date
OR rib.checkin_date <= rib1.checkin_date AND rib.checkout_date >= rib1.checkin_date);

-- 8. Создать бронирование в транзакции.
START TRANSACTION;
  INSERT INTO booking(id_client, booking_date)
  VALUES((SELECT id_client FROM  client LIMIT 1), NOW());

  INSERT INTO room_in_booking(id_booking, id_room, checkin_date, checkout_date)
  VALUE((SELECT id_booking FROM  booking ORDER BY id_booking DESC LIMIT 1), 5, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY));
COMMIT;


-- 9. Добавить индексы
CREATE INDEX name_idx ON client (name ASC);
CREATE INDEX name_idx ON hotel (name ASC);
CREATE INDEX name_idx ON room_category (name ASC);
CREATE INDEX check_in_out_idx ON  room_in_booking (checkin_date ASC, checkout_date ASC);








