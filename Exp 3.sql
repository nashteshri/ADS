CREATE TABLE emp (
    eno INT PRIMARY KEY,
    ename VARCHAR(50),
    city VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO emp (eno, ename, city, salary) VALUES (1, 'Prachi', 'Miraj', 62000);
INSERT INTO emp (eno, ename, city, salary) VALUES (2, 'Komal', 'Solapur', 55000);
INSERT INTO emp (eno, ename, city, salary) VALUES (3, 'Samiksha', 'Kolhapur', 80000);
INSERT INTO emp (eno, ename, city, salary) VALUES (4, 'amruta', 'Sangli', 25000);
INSERT INTO emp (eno, ename, city, salary) VALUES (5, 'Pranjali', 'Kohapur', 16000);
INSERT INTO emp (eno, ename, city, salary) VALUES (6, 'Vaishnavi', 'Karvir', 13000);
INSERT INTO emp (eno, ename, city, salary) VALUES (7, 'Aditi', 'Rahdhanagari', 22000);
INSERT INTO emp (eno, ename, city, salary) VALUES (8, 'Radhika', 'kolhapur', 24000);
INSERT INTO emp (eno, ename, city, salary) VALUES (9, 'kiran', 'sangli', 9000);
INSERT INTO emp (eno, ename, city, salary) VALUES (10, 'manish', 'miraj', 30000);

-- Hrizontal Fragmentation
CREATE TABLE emph1 AS
SELECT * FROM emp WHERE salary <= 15000;

SELECT
    * FROM emph1
    

CREATE TABLE emph2 AS
SELECT * FROM emp WHERE salary > 15000;

--Vertical fragmentation

CREATE TABLE empv1 AS
SELECT eno, ename FROM emp;

CREATE TABLE empv2 AS
SELECT eno, city, salary FROM emp;


--Queries

--1. Find the salary of all employees.
SELECT salary
from emp;

--2. Find the name of all employees where salary = 15000.
SELECT ename
from emp
where salary== 15000;

--3.Find the employee’s name and city where employee salary is between 15000 to  25000.
SELECT ename, city
from emp
where salary between 15000 and 25000;

--4.. Find the employee’s name and city where employee number is known.
SELECT ename, city 
FROM emp
where eno =1;



