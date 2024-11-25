-- Define type for Exams
CREATE TYPE Exam_Type AS OBJECT (
    year NUMBER(4),
    city VARCHAR2(30)
);

-- Define a Nested Table type for ExamSet
CREATE TYPE ExamSet_Type AS TABLE OF Exam_Type;

-- Define type for Skills
CREATE TYPE Skill_Type AS OBJECT (
    type VARCHAR2(30),
    ExamSet ExamSet_Type
);

-- Define a Nested Table type for SkillSet
CREATE TYPE SkillSet_Type AS TABLE OF Skill_Type;

-- Define type for Children
CREATE TYPE Children_Type AS OBJECT (
    name VARCHAR2(30),
    birthday DATE
);

-- Define a Nested Table type for ChildrenSet
CREATE TYPE ChildrenSet_Type AS TABLE OF Children_Type;


--//create table EMP//
CREATE TABLE Emp (
    ename VARCHAR2(30),
    ChildrenSet ChildrenSet_Type,
    SkillSet SkillSet_Type
) 
NESTED TABLE ChildrenSet STORE AS children_store_table
NESTED TABLE SkillSet STORE AS skill_store_table
(NESTED TABLE ExamSet STORE AS exam_store_table);



---insertion of Data---


INSERT INTO Emp VALUES (
    'John Doe',
    ChildrenSet_Type(
        Children_Type('Alice', DATE '1999-12-31'),
        Children_Type('Bob', DATE '2005-05-15')
    ),
    SkillSet_Type(
        Skill_Type('typing', ExamSet_Type(Exam_Type(2001, 'Dayton'))),
        Skill_Type('programming', ExamSet_Type(Exam_Type(2020, 'New York')))
    )
);

INSERT INTO Emp VALUES (
    'Jane Smith',
    ChildrenSet_Type(
        Children_Type('Charlie', DATE '2002-11-23')
    ),
    SkillSet_Type(
        Skill_Type('management', ExamSet_Type(Exam_Type(2018, 'Boston'))),
        Skill_Type('typing', ExamSet_Type(Exam_Type(2019, 'Dayton')))
    )
);

INSERT INTO Emp VALUES (
    'David Brown',
    ChildrenSet_Type(
        Children_Type('Eva', DATE '1998-08-08')
    ),
    SkillSet_Type(
        Skill_Type('design', ExamSet_Type(Exam_Type(2015, 'Chicago')))
    )
);

--Q.1 Find the names of all employees who have a child born on or after January 1, 2000.
--sql--
SELECT 
    e.ename
FROM 
    Emp e,
    TABLE(e.ChildrenSet) c
WHERE 
    c.birthday >= DATE '2000-01-01';

Q.2 
SELECT 
    e.ename
FROM 
    Emp e,
    TABLE(e.SkillSet) s,
    TABLE(s.ExamSet) ex
WHERE 
    s.type = 'typing'
    AND ex.city = 'Dayton';

Q.3
SELECT DISTINCT 
    s.type
FROM 
    Emp e,
    TABLE(e.SkillSet) s;

