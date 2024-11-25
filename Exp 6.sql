CREATE TABLE customerTable (
    cus_code INTEGER PRIMARY KEY,
    cus_lname VARCHAR2(10),
    cus_fname VARCHAR2(10),
    cus_initial VARCHAR2(1),
    cus_areacode INTEGER,
    cus_phone INTEGER,
    cus_balance NUMBER(10, 2)
);

CREATE SEQUENCE cus_code_seq
START WITH 1
INCREMENT BY 1;

SELECT sequence_name 
FROM user_sequences;

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Smith', 'John', 'J', 123, 4567890, 1000.50);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Doe', 'Jane', 'A', 124, 9876543, 200.75);


INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Brown', 'Mike', 'M', 125, 1234567, 1500.00);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Johnson', 'Emily', 'E', 126, 2345678, 2500.25);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Williams', 'Chris', 'C', 127, 3456789, 3200.10);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Jones', 'Anna', 'A', 128, 4567890, 1800.60);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Garcia', 'David', 'D', 129, 5678901, 400.00);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Martinez', 'Linda', 'L', 130, 6789012, 950.75);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Hernandez', 'James', 'J', 131, 7890123, 5000.50);

INSERT INTO customerTable (cus_code, cus_lname, cus_fname, cus_initial, cus_areacode, cus_phone, cus_balance)
VALUES (cus_code_seq.NEXTVAL, 'Lopez', 'Sophia', 'S', 132, 8901234, 650.30);

SELECT * FROM customerTable;



<-- 2. Trigger-->

-- Create the Student Report table
-- Create the Student Report table
CREATE TABLE Student_Report (
    tid INT PRIMARY KEY,                -- Use INT without size
    name VARCHAR2(30),                  -- Use VARCHAR2 instead of VARCHAR
    subj1 INT CHECK (subj1 BETWEEN 0 AND 20),  -- Ensure marks are between 0 and 20
    subj2 INT CHECK (subj2 BETWEEN 0 AND 20),  -- Ensure marks are between 0 and 20
    subj3 INT CHECK (subj3 BETWEEN 0 AND 20),  -- Ensure marks are between 0 and 20
    total INT DEFAULT 0,                -- Total starts at 0
    per INT DEFAULT 0                    -- Percentage starts at 0
);

<-- create the trigger-->
-- Create trigger to calculate total and percentage on insert
CREATE OR REPLACE TRIGGER calculate_total_per
BEFORE INSERT ON Student_Report
FOR EACH ROW
BEGIN
    -- Calculate total marks
    :NEW.total := NVL(:NEW.subj1, 0) + NVL(:NEW.subj2, 0) + NVL(:NEW.subj3, 0);
    
    -- Calculate percentage
    :NEW.per := ROUND((:NEW.total / 60) * 100); -- Max marks = 60
END;
/


-- Insert records into the Student_Report table
INSERT INTO Student_Report (tid, name, subj1, subj2, subj3) VALUES (1, 'Alice', 15, 18, 17);
INSERT INTO Student_Report (tid, name, subj1, subj2, subj3) VALUES (2, 'Bob', 10, 12, 14);
INSERT INTO Student_Report (tid, name, subj1, subj2, subj3) VALUES (3, 'Charlie', 5, 8, 6);


-- Display records from the Student_Report table
SELECT * FROM Student_Report;


<--3. Create the Course table-->

CREATE TABLE Course (
    course_num INT PRIMARY KEY,
    course_name VARCHAR2(20),
    dept_name VARCHAR2(15),
    credits INT
);

-- Procedure to find course names and credits where course name starts with 'C'
CREATE OR REPLACE PROCEDURE FindCoursesStartingWithC IS
    CURSOR c_courses IS
        SELECT course_name, credits
        FROM Course
        WHERE course_name LIKE 'C%';  -- Course names starting with 'C'
        
    v_course_name Course.course_name%TYPE;   -- Variable to hold course name
    v_credits Course.credits%TYPE;            -- Variable to hold credits
BEGIN
    OPEN c_courses;
    LOOP
        FETCH c_courses INTO v_course_name, v_credits;
        EXIT WHEN c_courses%NOTFOUND;  -- Exit loop if no more records
        DBMS_OUTPUT.PUT_LINE('Course Name: ' || v_course_name || ', Credits: ' || v_credits);
    END LOOP;
    CLOSE c_courses;
END;
/


-- Procedure to find course names from 'CSE' department
CREATE OR REPLACE PROCEDURE FindCoursesInCSE IS
    CURSOR c_cse_courses IS
        SELECT course_name
        FROM Course
        WHERE dept_name = 'CSE';  -- Department name is 'CSE'
        
    v_course_name Course.course_name%TYPE;  -- Variable to hold course name
BEGIN
    OPEN c_cse_courses;
    LOOP
        FETCH c_cse_courses INTO v_course_name;
        EXIT WHEN c_cse_courses%NOTFOUND;  -- Exit loop if no more records
        DBMS_OUTPUT.PUT_LINE('Course Name: ' || v_course_name);
    END LOOP;
    CLOSE c_cse_courses;
END;
/


-- Call the procedure to find courses starting with 'C'
BEGIN
    FindCoursesStartingWithC;
END;
/

-- Call the procedure to find courses in the 'CSE' department
BEGIN
    FindCoursesInCSE;
END;
/



