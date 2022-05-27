USE lw6;

-- 1. ADD Foreign Keys;
ALTER TABLE dealer
    ADD FOREIGN KEY (id_company) REFERENCES company (id_company);

ALTER TABLE `order`
    ADD FOREIGN KEY (id_production) REFERENCES production (id_production),
    ADD FOREIGN KEY (id_dealer) REFERENCES dealer (id_dealer),
    ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy (id_pharmacy);

ALTER TABLE production
    ADD FOREIGN KEY (id_company) REFERENCES company (id_company),
    ADD FOREIGN KEY (id_medicine) REFERENCES medicine (id_medicine);

-- 2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” суказанием названий аптек, дат, объема заказов.
SELECT ph.name, o.date, o.quantity
FROM `order` o
         INNER JOIN production p ON o.id_production = p.id_production
         INNER JOIN pharmacy ph ON o.id_pharmacy = ph.id_pharmacy
         INNER JOIN medicine m ON p.id_medicine = m.id_medicine
         INNER JOIN company c ON p.id_company = c.id_company
WHERE m.name = 'Кордеон'
  AND c.name = 'Аргус';

-- 3.Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.
SELECT DISTINCT m.name
FROM production p
         INNER JOIN `order` o ON p.id_production = o.id_production
         CROSS JOIN `order` o1 ON o1.id_production = o.id_production AND o1.date < '2019-01-25 00:00:00'
         INNER JOIN medicine m ON p.id_medicine = m.id_medicine
         INNER JOIN company c ON p.id_company = c.id_company
WHERE c.name = 'Фарма';

-- 4.Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
SELECT MIN(p.raring), MAX(p.raring), c.name, COUNT(*)
FROM `order` o
         INNER JOIN production p ON o.id_production = p.id_production
         INNER JOIN medicine m ON p.id_medicine = m.id_medicine
         INNER JOIN company c ON p.id_company = c.id_company
GROUP BY c.id_company
HAVING COUNT(*) >= 120;

-- 5.Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL
SELECT d.name, c.name, IF(p.id_pharmacy IS NOT NULL, p.name, NULL)
FROM `order` o
         RIGHT JOIN dealer d ON o.id_dealer = d.id_dealer
         LEFT JOIN company c ON d.id_company = c.id_company
         LEFT JOIN pharmacy p ON o.id_pharmacy = p.id_pharmacy
WHERE c.name = 'AstraZeneca'
GROUP BY d.id_dealer;

-- 6.Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.
SELECT m.name, p.price, m.cure_duration
FROM production p
         INNER JOIN medicine m ON p.id_medicine = m.id_medicine;/*
WHERE p.price > 3000
  AND m.cure_duration < 7;*/

UPDATE production p
    INNER JOIN medicine m ON p.id_medicine = m.id_medicine
SET p.price = p.price * 0.8
WHERE p.price > 3000
  AND m.cure_duration < 7;

-- 7. Добавить индексы
CREATE INDEX idx_order$id_production ON `order` (id_production ASC);
CREATE INDEX idx_order$id_pharmacy ON `order` (id_pharmacy ASC);
CREATE INDEX idx_order$id_dealer ON `order` (id_dealer ASC);

CREATE INDEX idx_production$id_medicine ON production (id_medicine ASC);
CREATE INDEX idx_production$id_company ON production (id_company ASC);

CREATE INDEX idx_dealer$id_company ON dealer (id_company ASC);