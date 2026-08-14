-- ============================================================
-- Student Management System - Database Schema (MySQL 8+)
-- Database : studentdb1
-- Safe to run: does NOT drop existing tables or data.
-- ============================================================

CREATE DATABASE IF NOT EXISTS studentdb1
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE studentdb1;

-- ------------------------------------------------------------
-- Students (login accounts)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS students (
  id           INT          NOT NULL AUTO_INCREMENT,
  fullname     VARCHAR(100) DEFAULT NULL,
  username     VARCHAR(50)  DEFAULT NULL,
  password     VARCHAR(100) DEFAULT NULL,
  phone        VARCHAR(15)  DEFAULT NULL,
  email        VARCHAR(100) DEFAULT NULL,
  student_code VARCHAR(30)  DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY username (username),
  UNIQUE KEY phone (phone),
  UNIQUE KEY email (email),
  UNIQUE KEY student_code (student_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- Student phones (multiple phones per student)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS student_phones (
  id           INT          NOT NULL AUTO_INCREMENT,
  student_code VARCHAR(30)  NOT NULL,
  phone        VARCHAR(15)  NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- Student details (one row per student, keyed by students.id)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS student_details (
  id                 INT          NOT NULL,
  student_code       VARCHAR(30)  DEFAULT NULL,
  reg_no             VARCHAR(30)  DEFAULT NULL,
  name               VARCHAR(50)  DEFAULT NULL,
  college_name       VARCHAR(100) DEFAULT NULL,
  department         VARCHAR(50)  DEFAULT NULL,
  semester           VARCHAR(20)  DEFAULT NULL,
  section            VARCHAR(10)  DEFAULT NULL,
  dob                VARCHAR(20)  DEFAULT NULL,
  blood_group        VARCHAR(10)  DEFAULT NULL,
  gender             VARCHAR(20)  DEFAULT NULL,
  mobile             VARCHAR(20)  DEFAULT NULL,
  phone              VARCHAR(20)  DEFAULT NULL,
  address            VARCHAR(200) DEFAULT NULL,
  category           VARCHAR(30)  DEFAULT NULL,
  nationality        VARCHAR(30)  DEFAULT NULL,
  admission_year     VARCHAR(10)  DEFAULT NULL,
  parent_name        VARCHAR(50)  DEFAULT NULL,
  parent_phone       VARCHAR(20)  DEFAULT NULL,
  parent_blood_group VARCHAR(10)  DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY student_code (student_code),
  CONSTRAINT fk_student_details FOREIGN KEY (id) REFERENCES students (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- Teachers
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS teachers (
  id          INT          NOT NULL AUTO_INCREMENT,
  fullname    VARCHAR(100) DEFAULT NULL,
  username    VARCHAR(50)  DEFAULT NULL,
  password    VARCHAR(50)  DEFAULT NULL,
  phone       VARCHAR(20)  DEFAULT NULL,
  email       VARCHAR(100) DEFAULT NULL,
  semester    VARCHAR(20)  DEFAULT NULL,
  section     VARCHAR(10)  DEFAULT NULL,
  department  VARCHAR(50)  DEFAULT NULL,
  secret_code VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- Attendance
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS attendance (
  attendance_id INT         NOT NULL AUTO_INCREMENT,
  student_id    INT         DEFAULT NULL,
  att_date      DATE        DEFAULT NULL,
  status        VARCHAR(10) DEFAULT NULL,
  marked_by     VARCHAR(50) DEFAULT NULL,
  semester      VARCHAR(20) DEFAULT NULL,
  section       VARCHAR(5)  DEFAULT NULL,
  department    VARCHAR(50) DEFAULT NULL,
  student_code  VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (attendance_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- Marks card (subjects: English, Kannada, Hindi, Social, Science, Maths)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS marks_card (
  id           INT NOT NULL,
  student_code VARCHAR(30) DEFAULT NULL,
  sub1         INT DEFAULT NULL,
  sub2         INT DEFAULT NULL,
  sub3         INT DEFAULT NULL,
  sub4         INT DEFAULT NULL,
  sub5         INT DEFAULT NULL,
  sub6         INT DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY student_code (student_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ------------------------------------------------------------
-- Admin users (used by the admin login + teacher registration gate)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id       INT          NOT NULL AUTO_INCREMENT,
  name     VARCHAR(100) DEFAULT NULL,
  username VARCHAR(50)  DEFAULT NULL,
  password VARCHAR(50)  DEFAULT NULL,
  phone    VARCHAR(20)  DEFAULT NULL,
  email    VARCHAR(100) DEFAULT NULL,
  regno    VARCHAR(50)  DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- Seed data (inserted only if missing)
-- ============================================================

-- Default admin account  ->  username: admin   password: admin123
INSERT IGNORE INTO users (name, username, password, phone, email, regno)
VALUES ('System Admin', 'admin', 'admin123', '9999999999', 'admin@college.edu', 'ADMIN001');

-- Sample students (password: Student@123)
INSERT IGNORE INTO students (id, fullname, username, password, phone, email, student_code) VALUES
(1, 'Sumith KS',     'sumith1', 'Student@123', '9988776651', 'sumith@gmail.com',  'STU100001'),
(2, 'Arun Kumar',    'arun1',   'Student@123', '9988776652', 'arun@gmail.com',    'STU100002'),
(3, 'Rakesh M',      'rakesh1', 'Student@123', '9988776653', 'rakesh@gmail.com',  'STU100003'),
(4, 'Naveen P',      'naveen1', 'Student@123', '9988776654', 'naveen@gmail.com',  'STU100004'),
(5, 'Kiran H',       'kiran1',  'Student@123', '9988776655', 'kiran@gmail.com',   'STU100005');

INSERT IGNORE INTO student_details
(id, student_code, reg_no, name, college_name, department, semester, section,
 dob, blood_group, gender, mobile, phone, address, category, nationality,
 admission_year, parent_name, parent_phone, parent_blood_group)
VALUES
(1, 'STU100001', 'REG1001', 'Sumith KS',  'VTU College', 'AIML', '1', 'A', '2006-01-15', 'B+', 'Male', '9988776651', '9988776651', 'Bengaluru', 'GM', 'India', '2025', 'Ramappa', '9988776601', 'O+'),
(2, 'STU100002', 'REG1002', 'Arun Kumar', 'VTU College', 'CSE',  '1', 'A', '2006-03-22', 'O+', 'Male', '9988776652', '9988776652', 'Mysuru',    'GM', 'India', '2025', 'Kumaraswamy', '9988776602', 'A+'),
(3, 'STU100003', 'REG1003', 'Rakesh M',   'VTU College', 'ECE',  '1', 'B', '2006-07-10', 'A+', 'Male', '9988776653', '9988776653', 'Hubli',     'OBC','India', '2025', 'Manjunath', '9988776603', 'B+'),
(4, 'STU100004', 'REG1004', 'Naveen P',   'VTU College', 'ISE',  '1', 'B', '2005-11-05', 'AB+', 'Male','9988776654', '9988776654', 'Mangaluru', 'GM', 'India', '2025', 'Prakash', '9988776604', 'AB+'),
(5, 'STU100005', 'REG1005', 'Kiran H',    'VTU College', 'MECH', '1', 'C', '2006-05-19', 'O-', 'Male', '9988776655', '9988776655', 'Belagavi',  'SC', 'India', '2025', 'Hanumanth', '9988776605', 'O+');

-- Sample teachers (password: Teacher@123)
INSERT IGNORE INTO teachers (id, fullname, username, password, phone, email, semester, section, department, secret_code) VALUES
(1, 'Ravi Sir',   'teacher1', 'Teacher@123', '9988776601', 'ravi@college.edu',  '1', 'A', 'AIML', 'SEC001'),
(2, 'Sanjay Sir', 'teacher2', 'Teacher@123', '9988776602', 'sanjay@college.edu','1', 'B', 'ECE',  'SEC002'),
(3, 'Mahesh Sir', 'teacher3', 'Teacher@123', '9988776603', 'mahesh@college.edu','1', 'C', 'MECH', 'SEC003'),
(4, 'Kiran Sir',  'teacher4', 'Teacher@123', '9988776604', 'kiran@college.edu', '2', 'A', 'CSE',  'SEC004'),
(5, 'Prakash Sir','teacher5', 'Teacher@123', '9988776605', 'prakash@college.edu','2','B', 'ISE',  'SEC005');

-- Sample marks (ENG, KAN, HIN, SOC, SCI, MAT)
INSERT IGNORE INTO marks_card (id, student_code, sub1, sub2, sub3, sub4, sub5, sub6) VALUES
(1, 'STU100001', 90, 98, 90, 90, 98, 90),
(2, 'STU100002', 85, 79, 88, 90, 81, 76),
(3, 'STU100003', 70, 75, 80, 85, 90, 95),
(4, 'STU100004', 92, 94, 89, 90, 88, 93),
(5, 'STU100005', 65, 72, 78, 80, 75, 70);

-- Sample attendance
INSERT IGNORE INTO attendance
(attendance_id, student_id, att_date, status, marked_by, semester, section, department, student_code)
SELECT 1, 1, '2026-07-01', 'Present', 'teacher1', '1', 'A', 'AIML', 'STU100001'
WHERE NOT EXISTS (SELECT 1 FROM attendance WHERE attendance_id = 1);

INSERT IGNORE INTO attendance
(attendance_id, student_id, att_date, status, marked_by, semester, section, department, student_code)
SELECT 2, 2, '2026-07-01', 'Absent',  'teacher1', '1', 'A', 'CSE',  'STU100002'
WHERE NOT EXISTS (SELECT 1 FROM attendance WHERE attendance_id = 2);
