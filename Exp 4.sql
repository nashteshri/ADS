select tablespace_name, contents from dba_tablespaces;



create tablespace tbs04 datafile 'd:\dfiles\tbs02.dbf' size 10m blocksize 8k;

create user prachi identified by prachi default tablespace tbs03 quota 5m on tbs03;

alter session set "_ORACLE_SCRIPT" = true;

grant create session ,create table to ellison;

show user;

desc dba_ts_quotas;

--1.	Creating and Managing Tablespaces

--a. Create a new tablespace named emp_data with an initial size of 20MB.
CREATE TABLESPACE emp_data
DATAFILE 'd:\dfiles\emp_data.dbf' SIZE 20M blocksize 8k;

--b.	Check the size and status of the tablespace using an SQL query.
SELECT dt.tablespace_name, df.bytes/1024/1024 AS size_mb, dt.status 
FROM dba_tablespaces dt
JOIN dba_data_files df ON dt.tablespace_name = df.tablespace_name
WHERE dt.tablespace_name = 'EMP_DATA';

--2.	Resize the Tablespace
--a.	Resize the emp_data tablespace to 50MB
SELECT file_name 
FROM dba_data_files 
WHERE tablespace_name = 'EMP_DATA';


ALTER DATABASE DATAFILE '/opt/oracle/homes/OraDBHome21cXE/dbs/d:dfilesemp_data.dbf' RESIZE 50M;



--b.	Verify the size change
SELECT file_name, bytes/1024/1024 AS size_mb
FROM dba_data_files
WHERE tablespace_name = 'EMP_DATA';

--3 temporary tablespaces
--a.	Create a temporary tablespace and assign it as the default
CREATE TEMPORARY TABLESPACE temp_space
TEMPFILE 'temp_space.dbf' SIZE 50M;

ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp_space;


----b.	Check the size and status of the tablespace using an SQL query.

SELECT dt.tablespace_name, tf.bytes/1024/1024 AS size_mb, dt.status
FROM dba_tablespaces dt
JOIN dba_temp_files tf ON dt.tablespace_name = tf.tablespace_name
WHERE dt.tablespace_name = 'TEMP_SPACE';


--4 undo tablespaces
--a.	Create an undo tablespace
CREATE UNDO TABLESPACE undo_space 
DATAFILE 'undo_space.dbf' SIZE 50M;

--b.	Check the size and status of the tablespace using an SQL query
SELECT dt.tablespace_name, df.bytes/1024/1024 AS size_mb, dt.status
FROM dba_tablespaces dt
JOIN dba_data_files df ON dt.tablespace_name = df.tablespace_name
WHERE dt.tablespace_name = 'UNDO_SPACE';



--5. Create User and Assign Tablespace Quotas
--a.	Create user hr_user on the emp_data tablespace and Assign a 10MB quota to HR_USER on the emp_data tablespace
CREATE USER b27_user IDENTIFIED BY b27_password 
DEFAULT TABLESPACE emp_data 
QUOTA 10M ON emp_data;

--b.	grant create session, create table to hr_user
GRANT CREATE SESSION, CREATE TABLE TO b27_user;

-- c.	check max_bytes and used_data for hr_user
SELECT tablespace_name, max_bytes/1024/1024 AS max_mb, bytes/1024/1024 AS used_mb
FROM dba_ts_quotas
WHERE username = 'B27_USER' AND tablespace_name = 'EMP_DATA';



--6.	Create Table in tablespace

--a.	Connect with hr_user
CONNECT b27_user/b27_password;

--b.	Create table employee in table space with attributes emp_id, emp_name, emp_address
CREATE TABLE b27Employee (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    emp_address VARCHAR2(100)
) TABLESPACE emp_data;

--c.	Insert few records in employee table
INSERT INTO b27Employee (emp_id, emp_name, emp_address) VALUES (1, 'Prachi Patil', '123 Main St');
INSERT INTO b27Employee (emp_id, emp_name, emp_address) VALUES (2, 'Komal Jachav', '456 Elm St');

--d.	check max_bytes and free_space for hr_user
SELECT tablespace_name, SUM(bytes)/1024/1024 AS free_mb
FROM dba_free_space
WHERE tablespace_name = 'EMP_DATA'
GROUP BY tablespace_name;


--7.	Updates to tablespace
--a.	Take the emp_data tablespace offline and verify that the tablespace is offline
ALTER TABLESPACE emp_data OFFLINE;

SELECT tablespace_name, status FROM dba_tablespaces WHERE tablespace_name = 'EMP_DATA';

--b.	Bring the emp_data tablespace back online and verify the tablespace status
ALTER TABLESPACE emp_data ONLINE;

SELECT tablespace_name, status FROM dba_tablespaces WHERE tablespace_name = 'EMP_DATA';

ALTER USER b27_user QUOTA 0 ON emp_data;

--c.	Remove the quota for HR_USER on the emp_data tablespace and verify the quota removal.
SELECT tablespace_name, max_bytes 
FROM dba_ts_quotas 
WHERE username = 'B27_USER' AND tablespace_name = 'EMP_DATA';








