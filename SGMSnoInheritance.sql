CREATE TABLE instrument (
 instrument_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 type_name VARCHAR(500) NOT NULL,
 brand_name VARCHAR(500) NOT NULL,
 price_per_month INT NOT NULL
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (instrument_id);


CREATE TABLE lesson_price (
 price_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 price_type INT NOT NULL,
 price_skill INT,
 discount INT,
 instructor_pay INT NOT NULL,
 type VARCHAR(500) NOT NULL
);

ALTER TABLE lesson_price ADD CONSTRAINT PK_lesson_price PRIMARY KEY (price_id);

CREATE TYPE role_enum AS ENUM ('student', 'intructor');

CREATE TABLE person (
 person_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 social_security_number VARCHAR(12) NOT NULL,
 first_name VARCHAR(500) NOT NULL,
 last_name VARCHAR(500) NOT NULL,
 role VARCHAR(500) NOT NULL
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (person_id);


CREATE TABLE phone (
 phone_number VARCHAR(20) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE phone ADD CONSTRAINT PK_phone PRIMARY KEY (phone_number,person_id);


CREATE TABLE room (
 room_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 location VARCHAR(500)
);

ALTER TABLE room ADD CONSTRAINT PK_room PRIMARY KEY (room_id);

CREATE TYPE skill_enum AS ENUM ('beginner', 'intermediate', 'advanced');
CREATE TABLE skill_level (
 skill_id VARCHAR(10) NOT NULL,
 instrument VARCHAR(500),
 skill skill_enum
);


ALTER TABLE skill_level ADD CONSTRAINT PK_skill_level PRIMARY KEY (skill_id);


CREATE TABLE student (
 person_id INT NOT NULL,
 family_id VARCHAR(10)
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (person_id);


CREATE TABLE address (
 person_id INT NOT NULL,
 street VARCHAR(500) NOT NULL,
 city VARCHAR(500) NOT NULL,
 zip_code VARCHAR(6) NOT NULL
);

ALTER TABLE address ADD CONSTRAINT PK_address PRIMARY KEY (person_id);


CREATE TABLE contact_person (
 person_id INT NOT NULL,
 relation_to_student VARCHAR(500) NOT NULL,
 email VARCHAR(500),
 phone_number VARCHAR(500) NOT NULL
);

ALTER TABLE contact_person ADD CONSTRAINT PK_contact_person PRIMARY KEY (person_id);


CREATE TABLE email (
 email VARCHAR(500) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE email ADD CONSTRAINT PK_email PRIMARY KEY (email,person_id);


CREATE TABLE instructor (
 person_id INT NOT NULL,
 ensemble_abillity BOOLEAN NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (person_id);


CREATE TABLE instrument_lease (
 lease_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 person_id INT NOT NULL,
 lease_start_date VARCHAR(500),
 instrument_id INT NOT NULL,
 active BOOLEAN
);

ALTER TABLE instrument_lease ADD CONSTRAINT PK_instrument_lease PRIMARY KEY (lease_id,person_id);


CREATE TABLE lesson (
 lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 genre VARCHAR(500),
 min_participants INT NOT NULL,
 max_participants INT NOT NULL,
 lesson_type VARCHAR(500) NOT NULL,
 confirmed BOOLEAN,
 room_id INT NOT NULL,
 time_start TIMESTAMP(6),
 duration_minutes INT,
 price_id INT NOT NULL
);

ALTER TABLE lesson ADD CONSTRAINT PK_lesson PRIMARY KEY (lesson_id);


CREATE TABLE person_skill (
 skill_id VARCHAR(10) NOT NULL,
 person_id INT NOT NULL
);

ALTER TABLE person_skill ADD CONSTRAINT PK_person_skill PRIMARY KEY (skill_id,person_id);


CREATE TABLE booking (
 booking_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 lesson_id INT NOT NULL,
 student_person_id INT,
 instructor_person_id INT
);


ALTER TABLE booking ADD CONSTRAINT PK_booking PRIMARY KEY (booking_id);


ALTER TABLE phone ADD CONSTRAINT FK_phone_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE address ADD CONSTRAINT FK_address_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE contact_person ADD CONSTRAINT FK_contact_person_0 FOREIGN KEY (person_id) REFERENCES student (person_id);


ALTER TABLE email ADD CONSTRAINT FK_email_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE instrument_lease ADD CONSTRAINT FK_instrument_lease_0 FOREIGN KEY (person_id) REFERENCES student (person_id);
ALTER TABLE instrument_lease ADD CONSTRAINT FK_instrument_lease_1 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);


ALTER TABLE lesson ADD CONSTRAINT FK_lesson_0 FOREIGN KEY (room_id) REFERENCES room (room_id);
ALTER TABLE lesson ADD CONSTRAINT FK_lesson_1 FOREIGN KEY (price_id) REFERENCES lesson_price (price_id);


ALTER TABLE person_skill ADD CONSTRAINT FK_person_skill_0 FOREIGN KEY (skill_id) REFERENCES skill_level (skill_id);
ALTER TABLE person_skill ADD CONSTRAINT FK_person_skill_1 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE booking ADD CONSTRAINT FK_booking_0 FOREIGN KEY (lesson_id) REFERENCES lesson (lesson_id);
ALTER TABLE booking ADD CONSTRAINT FK_booking_1 FOREIGN KEY (student_person_id) REFERENCES student (person_id);
ALTER TABLE booking ADD CONSTRAINT FK_booking_2 FOREIGN KEY (instructor_person_id) REFERENCES instructor (person_id);