-- 1 .Добавить внешние ключи --
ALTER TABLE student
    ADD FOREIGN KEY (id_group) REFERENCES `group` (id_group);

ALTER TABLE lesson
    ADD FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher),
    ADD FOREIGN KEY (id_group) REFERENCES `group` (id_group),
    ADD FOREIGN KEY (id_subject) REFERENCES subject (id_subject);

ALTER TABLE mark
    ADD FOREIGN KEY (id_lesson) REFERENCES lesson (id_lesson),
    ADD FOREIGN KEY (id_student) REFERENCES student (id_student);

-- 2. Выдать оценки студентов по информатике если они обучаются данномупредмету. Оформить выдачу данных с использованием view.
CREATE VIEW computer_science_students_grades AS
SELECT s.name, m.mark
FROM mark m
         LEFT JOIN lesson l on l.id_lesson = m.id_lesson
         LEFT JOIN student s on m.id_student = s.id_student
         INNER JOIN subject sub on l.id_subject = sub.id_subject
WHERE sub.name = 'Информатика'
ORDER BY s.id_student;

-- 3. Дать информацию о должниках с указанием фамилии студента и названия предмета
--       Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе
--       Оформить в виде процедуры, на входе идентификатор группы
CREATE PROCEDURE debstors(
    IN identify_group INT
)
BEGIN
    SELECT debsters.name AS debster,
           subject.name
    FROM `group`
             JOIN lesson on `group`.id_group = lesson.id_group
             JOIN subject on subject.id_subject = lesson.id_subject
             RIGHT JOIN (
        SELECT student.name,
               `group`.id_group
        FROM student
                 JOIN `group` on `group`.id_group = student.id_group
                 LEFT JOIN mark on student.id_student = mark.id_student
        WHERE mark.mark IS NULL
    ) debsters ON debsters.id_group = `group`.id_group
    WHERE `group`.id_group = identify_group
    GROUP BY subject.name, debsters.name
    ORDER BY debsters.name;
END;

-- вызов процедуры
CALL debstors(1);


-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов,
--       по которым занимается не менее 35 студентов
SELECT subject.name,
       AVG(mark.mark) AS average_rating
FROM lesson
         JOIN mark on lesson.id_lesson = mark.id_lesson
         JOIN student on mark.id_student = student.id_student
         JOIN subject on lesson.id_subject = subject.id_subject
GROUP BY subject.name
HAVING COUNT(student.id_student) >= 35;


-- 5. Дать оценки студентов специальности БИ по всем проводимым предметам
--       с указанием группы, фамилии, предмета, даты
--       При отсутствии оценки заполнить значениями NULL поля оценки
SELECT `group`.name,
       student.name,
       subject.name,
       lesson.date,
       mark.mark
FROM `group`
         JOIN student on `group`.id_group = student.id_group
         JOIN lesson on `group`.id_group = lesson.id_group
         JOIN subject on lesson.id_subject = subject.id_subject
         LEFT JOIN mark on student.id_student = mark.id_student
WHERE `group`.name = 'БИ';


-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05
--       повысить эти оценки на 1 балл
UPDATE
    mark
        JOIN lesson on lesson.id_lesson = mark.id_lesson
        JOIN subject on subject.id_subject = lesson.id_subject
        JOIN `group` on `group`.id_group = lesson.id_group
SET mark = mark + 1
WHERE `group`.name = 'ПС'
  AND mark < 5
  AND subject.name = 'БД'
  AND lesson.date < '2019-05-12'
;


-- 7. Добавить необходимые индексы
CREATE INDEX IX_group_name ON `group` (name ASC);
CREATE INDEX IX_subject_name ON subject (name ASC);
CREATE INDEX IX_lesson_date ON lesson (date ASC);

