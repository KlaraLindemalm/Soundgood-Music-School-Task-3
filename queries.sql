--LESSONS_PER_MONTH
CREATE MATERIALIZED VIEW lessons_per_month AS
SELECT
    EXTRACT(MONTH FROM time_start) AS month,
    sum(case when lesson_type='individual' then 1 else 0 end) as individual,
    sum(case when lesson_type='group' then 1 else 0 end) as group,
    sum(case when lesson_type='ensemble' then 1 else 0 end) as ensemble
FROM lesson 
WHERE EXTRACT(YEAR FROM time_start) = 2022
GROUP BY month
ORDER BY month;


--STUDENT_SIBLING_COUNT
CREATE MATERIALIZED VIEW student_sibling_count AS
(SELECT siblings, COUNT(siblings)*(siblings+1) AS number_of_students
FROM (
    SELECT COUNT(family_id)-1 AS siblings
    FROM student
    GROUP BY family_id
    HAVING COUNT(family_id) != 0 ) AS result
GROUP BY siblings)
UNION
(SELECT 0, COUNT(*) 
FROM student
WHERE family_id IS NULL)
ORDER BY siblings ASC;


--INSTRUCTOR_LESSON_COUNT
CREATE MATERIALIZED VIEW instructor_lesson_count AS
SELECT instructor_person_id, COUNT(lesson_id) AS numberOfLessons
FROM (
    SELECT DISTINCT booking.lesson_id, booking.instructor_person_id, lesson.time_start
    FROM booking
    INNER JOIN lesson
    ON booking.lesson_id=lesson.lesson_id)  AS instructor_lessons
WHERE EXTRACT(MONTH FROM time_start) = EXTRACT(MONTH FROM current_date) AND EXTRACT(YEAR FROM time_start) = EXTRACT(YEAR FROM current_date)
GROUP BY instructor_person_id
HAVING COUNT(instructor_person_id) > 0
ORDER BY COUNT(lesson_id) DESC;


--ENSEMBLED_HELD_NEXT_WEEK
CREATE VIEW ensembles_held_next_week AS
SELECT lesson_id, genre, to_char(time_start, 'DAY') as weekday, max_participants, booked_participants,
CASE 
    WHEN max_participants - booked_participants = 0 THEN 'full'
    WHEN max_participants - booked_participants = 1 THEN 'one seat available'
    WHEN max_participants - booked_participants = 2 THEN 'two seats available'
    ELSE 'more than two seats left'
    END AS availability 
FROM (
    SELECT lesson.lesson_id, max_participants, time_start, genre, lesson_type, COUNT(booking_id) AS booked_participants
    FROM lesson
    INNER JOIN booking ON booking.lesson_id = lesson.lesson_id
    WHERE lesson_type='ensemble' AND time_start BETWEEN date_trunc('week', current_date+7)  AND date_trunc('week', current_date+14)
    GROUP BY lesson.lesson_id) AS lesson_booking
GROUP BY lesson_id, max_participants, genre, weekday, booked_participants;
