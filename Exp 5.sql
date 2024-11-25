CREATE TABLE employeetable (
    id INT PRIMARY KEY,
    fname VARCHAR(25) NOT NULL,
    lname VARCHAR(25) NOT NULL,
    store_id INT NOT NULL,
    department_id INT NOT NULL
)
PARTITION BY RANGE (id) (
    PARTITION p0 VALUES LESS THAN (5),
    PARTITION p1 VALUES LESS THAN (10),
    PARTITION p2 VALUES LESS THAN (15),
    PARTITION p3 VALUES LESS THAN (20),
    PARTITION p4 VALUES LESS THAN (MAXVALUE)
);


INSERT INTO employeetable VALUES (1, 'John', 'Doe', 101, 1);
INSERT INTO employeetable VALUES (2, 'Jane', 'Smith', 102, 2);
INSERT INTO employeetable VALUES (3, 'Mike', 'Brown', 103, 3);
INSERT INTO employeetable VALUES (4, 'Sara', 'Wilson', 104, 4);
INSERT INTO employeetable VALUES (5, 'Sam', 'Adams', 105, 1);
INSERT INTO employeetable VALUES (6, 'Chris', 'Evans', 106, 2);
INSERT INTO employeetable VALUES (7, 'Steve', 'Johnson', 107, 3);
INSERT INTO employeetable VALUES (8, 'Sophia', 'Miller', 108, 4);
INSERT INTO employeetable VALUES (9, 'Emma', 'Davis', 109, 1);
INSERT INTO employeetable VALUES (10, 'Oliver', 'Clark', 110, 2);
INSERT INTO employeetable VALUES (11, 'Ethan', 'Lewis', 111, 3);
INSERT INTO employeetable VALUES (12, 'Mia', 'Walker', 112, 4);
INSERT INTO employeetable VALUES (13, 'Lucas', 'Hall', 113, 1);
INSERT INTO employeetable VALUES (14, 'Mason', 'Young', 114, 2);
INSERT INTO employeetable VALUES (15, 'James', 'King', 115, 3);
INSERT INTO employeetable VALUES (16, 'Liam', 'Scott', 116, 4);
INSERT INTO employeetable VALUES (17, 'Noah', 'Green', 117, 1);
INSERT INTO employeetable VALUES (18, 'Ava', 'Baker', 118, 2);
INSERT INTO employeetable VALUES (19, 'Sophia', 'Hill', 119, 3);
INSERT INTO employeetable VALUES (20, 'Isabella', 'Ward', 120, 4);
 
 <--Q.1-->
SELECT * 
FROM employeetable
WHERE id BETWEEN 5 AND 14;

<--Q.2-->
SELECT * 
FROM employeetable
WHERE id < 10 
AND fname LIKE 'S%';

<--Q.3-->
SELECT department_id, COUNT(*) AS employee_count
FROM employeetable
WHERE id BETWEEN 5 AND 19
GROUP BY department_id;

<--to check partitioning-->
SELECT table_name, partitioning_type 
FROM user_part_tables 
WHERE table_name = 'EMPLOYEETABLE';

SELECT partition_name, high_value, tablespace_name 
FROM user_tab_partitions 
WHERE table_name = 'EMPLOYEETABLE';


<--Hash Partitioning-->
CREATE TABLE sales_hash (
    salesman_id NUMBER(5) PRIMARY KEY,
    salesman_name VARCHAR2(30),
    sales_amount NUMBER(10),
    week_no NUMBER(2)
)
PARTITION BY HASH (salesman_id)
PARTITIONS 4;

<--Insert the values-->
INSERT INTO sales_hash VALUES (101, 'John Doe', 3500, 1);
INSERT INTO sales_hash VALUES (102, 'Jane Smith', 4500, 2);
INSERT INTO sales_hash VALUES (103, 'Mike Brown', 5000, 3);
INSERT INTO sales_hash VALUES (104, 'Sara Wilson', 2500, 4);
INSERT INTO sales_hash VALUES (105, 'Sam Adams', 1500, 1);
INSERT INTO sales_hash VALUES (106, 'Chris Evans', 2000, 2);
INSERT INTO sales_hash VALUES (107, 'Steve Johnson', 4000, 3);
INSERT INTO sales_hash VALUES (108, 'Sophia Miller', 3000, 4);
INSERT INTO sales_hash VALUES (109, 'Emma Davis', 6000, 1);
INSERT INTO sales_hash VALUES (110, 'Oliver Clark', 4500, 2);

<--Verify Partition Names:-->
SELECT partition_name 
FROM user_tab_partitions 
WHERE table_name = 'SALES_HASH';

<--Q.1  Retrieve sales details from the 2nd partition-->
SELECT * 
FROM sales_hash PARTITION (SYS_P453);

<--Q.2 Retrieve names of salesmen and sales amounts from the 4th partition where sale amount is between 2000 and 5000
SELECT salesman_name, sales_amount 
FROM sales_hash PARTITION (SYS_P455)
WHERE sales_amount BETWEEN 2000 AND 5000;

<--Q.3 Find the average sales amount per week from the 3rd partition
SELECT week_no, AVG(sales_amount) AS avg_sales
FROM sales_hash PARTITION (SYS_P454)
GROUP BY week_no;



