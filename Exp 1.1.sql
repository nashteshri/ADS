create table abc(
    pid integer Primary key
)

create type Nameobject AS OBJECT (
    fname VARCHAR(20),
    lname VARCHAR(20)
);

create type phonearraylist AS VARRAY(4) OF VARCHAR(15);

// Create Structured Type for Publisher
CREATE TYPE Publisher_Type AS OBJECT (
 pub_id VARCHAR2(10),
 pub_name VARCHAR2(30),
 branch VARCHAR2(30)
);

// Create VARRAY Type for Author IDs
CREATE TYPE Author_Varray AS VARRAY(10) OF VARCHAR2(10);
-- Create Nested Table Type for Keywords
CREATE TYPE Keywords_Table AS TABLE OF VARCHAR2(100);
-- Create Nested Table Type for Phone Numbers in Customer Table
CREATE TYPE Phone_Table AS TABLE OF VARCHAR2(15);
-- Create Table Author
CREATE TABLE Author (
 author_id VARCHAR2(10) PRIMARY KEY,
 name Nameobject,
 phone_no phonearraylist
);


-- Create Table Book
CREATE TABLE Book (
 ISBN NUMBER PRIMARY KEY,
 title VARCHAR2(30),
 author_id Author_Varray,
 category VARCHAR2(20),
 publisher Publisher_Type,
 keywords Keywords_Table,
 price NUMBER(10, 2)
) NESTED TABLE keywords STORE AS keywords_store_table;


-- Create Table Customer
CREATE TABLE Customer (
 customer_id VARCHAR2(10) PRIMARY KEY,
 name Nameobject,
 phone Phone_Table
) NESTED TABLE phone STORE AS phone_store_table;


-- Create Table Book_Sale
CREATE TABLE Book_Sale (
 sale_id VARCHAR2(10) PRIMARY KEY,
 customer_id VARCHAR2(10),
 ISBN NUMBER,
 FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
 FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);


--Now, inserting Sampe data into 
-- Insert data into Author
INSERT INTO Author VALUES (
 'A001', 
 Nameobject('Prachi', 'Patil'), 
 phonearraylist('1234567890', '0987654321')
);
INSERT INTO Author VALUES (
 'A003',
 Nameobject('Komal', 'Jadhav'),
 phonearraylist('1234567890', '9876543210')
);
INSERT INTO Author VALUES (
 'A005',
 Nameobject('Shruti', 'Ghate'),
 phonearraylist('0123456789', '9876543210')
);
INSERT INTO Author VALUES (
 'A002', 
 Nameobject('johm', 'Doe'), 
 phonearraylist('1234509876', '0987612345')
);

INSERT INTO Author VALUES (
 'A006', 
 Nameobject('Prachi', 'Patil'), 
 phonearraylist('1234509876', '0987612345')
);


-- Insert data into Book
INSERT INTO Book VALUES (
 1001, 
 'Database Systems', 
 Author_Varray('A001', 'A002'), 
 'Education', 
 Publisher_Type('P001', 'Tata MaGraw Hill', 'India'), 
 Keywords_Table('SQL', 'NoSQL'), 
 499.99
);
INSERT INTO Book VALUES (
 1004,
 'The Great Gatsby',
 Author_Varray('A004'),
 'Literature',
 Publisher_Type('P004', 'Penguin Random House', 'US'),
 Keywords_Table('Novel', 'American Literature', 'Jazz Age'),
 299.99
);
INSERT INTO Book VALUES (
 1005,
 'Wise and Otherwise',
 Author_Varray('A005'),
 'Literature',
 Publisher_Type('P005', 'HarperCollins', 'UK'),
 Keywords_Table('Novel', 'Romance', 'Historical Fiction'),
 349.99
);
INSERT INTO Book VALUES (
 1002, 
 'Advanced Databases', 
 Author_Varray('A001'), 
 'Technology', 
 Publisher_Type('P002', 'O''Reilly Media', 'US'), 
 Keywords_Table('Database', 'Advanced'), 
 599.99
);


-- Insert data into Customer
INSERT INTO Customer VALUES (
 'C002', 
 Nameobject('Bob', 'Builder'), 
 Phone_Table('1234765432')
);
INSERT INTO Customer VALUES (
 'C001', 
 Nameobject('Alice', 'Wonderland'), 
 Phone_Table('1234987654')
);

INSERT INTO Customer VALUES (
 'C003',
 Nameobject('Sherlock', 'Holmes'),
 Phone_Table('1234567890')
);
INSERT INTO Customer VALUES (
 'C004',
 Nameobject('Dr. Watson', 'Watson'),
 Phone_Table('0123456789')
);


-- Insert data into Book_Sale

INSERT INTO Book_Sale VALUES (
 'S001', 
 'C001', 
 1001
);
INSERT INTO Book_Sale VALUES (
 'S002', 
 'C002', 
 1002
);
INSERT INTO Book_Sale VALUES (
 'S004',
 'C003',
 1004
);
INSERT INTO Book_Sale VALUES (
 'S005',
 'C004',
 1005
);





//Q1
SELECT 
    b.ISBN,
    b.title,
    a.name.fname || ' ' || a.name.lname AS author_name
FROM 
    Book b
JOIN 
    TABLE(b.author_id) a_id ON 1=1
JOIN 
    Author a ON a.author_id = a_id.COLUMN_VALUE;

//Q.2
SELECT 
    c.name.fname || ' ' || c.name.lname AS customer_name
FROM 
    Book_Sale bs
JOIN 
    Book b ON bs.ISBN = b.ISBN
JOIN 
    Customer c ON bs.customer_id = c.customer_id
WHERE 
    b.publisher.pub_name LIKE 'Tata MaGraw Hill'
ORDER BY 
    c.name.lname, c.name.fname;


//Q3
SELECT 
    c.name.fname || ' ' || c.name.lname AS customer_name,
    b.title AS book_title,
    b.publisher.pub_name AS publisher_name
FROM 
    Book_Sale bs
JOIN 
    Book b ON bs.ISBN = b.ISBN
JOIN 
    Customer c ON bs.customer_id = c.customer_id
WHERE 
    b.publisher.branch IN ('UK', 'US')
ORDER BY 
    c.name.lname;
    
//Q.4

SELECT 
    b.category,
    COUNT(*) AS book_count
FROM 
    Book b
GROUP BY 
    b.category
ORDER BY 
    b.category;

//.5
SELECT 
    a.name.fname AS author_first_name,
    COUNT(bs.sale_id) AS books_sold_count
FROM 
    Book b
JOIN 
    TABLE(b.author_id) a_id ON 1=1
JOIN 
    Author a ON a.author_id = a_id.COLUMN_VALUE
LEFT JOIN 
    Book_Sale bs ON b.ISBN = bs.ISBN
GROUP BY 
    a.name.fname
ORDER BY 
    a.name.fname;




