/*
				Assignment 6
                  Worth 10%
                Total Assignment is out of 100 marks  
				
                Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/


/*
 Question 1 (10 marks)
 
 a) Create two tables with the same numbers of columns and datatypes (mininum 3 columns in each table) (3 marks)


 b) Populate those tables with data (3 marks)

 c) Create a SELECT statement for each table and UNION them together (4 marks)

*/
-- Create the first table
CREATE TABLE Table1 (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

-- Create the second table
CREATE TABLE Table2 (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

 -- Populate Table1 with data
INSERT INTO Table1 (id, name, age) VALUES
(1, 'John', 30),
(2, 'Alice', 25),
(3, 'Bob', 35);

-- Populate Table2 with data
INSERT INTO Table2 (id, name, age) VALUES
(101, 'Emily', 28),
(102, 'Michael', 40),
(103, 'Sarah', 33);

 -- SELECT statement for Table1
SELECT id, name, age
FROM Table1

UNION

-- SELECT statement for Table2
SELECT id, name, age
FROM Table2;

/*
 Question 2 (10 marks)
 
 Create a query that lists the department number, employee number, and salaries of all employees in department D11.  
 UNION the same information , but this time sum up all the salaries to create a one line summary entry for the D11 department (hint sum the salary).  Sort the list by Salary.
 
*/

-- Query to list department number, employee number, and salaries of all employees in department D11
SELECT WORKDEPT, EMPNO, SALARY
FROM EMPLOYEE
WHERE WORKDEPT = 'D11'

UNION

-- Query to summarize the salaries for department D11
SELECT WORKDEPT, 'Total' AS EMPNO, SUM(SALARY) AS TOTAL_SALARY
FROM EMPLOYEE
WHERE WORKDEPT = 'D11'
GROUP BY WORKDEPT

ORDER BY SALARY;


/*
 Question 3 (10 marks)
 
a )  Write a query that uses NATURAL JOIN TO connect the EMPLOYEE and EMPPROJACT table.   Include the Employee number , First and Last name, Salary, Salary increased by 3% and Project number      ( 3 marks )

b) Use INNER JOIN OR JOIN with the same query with USING statement   ( 3 marks )
 
c) Use INNER JOIN OR JOIN with the same query with joined columns (hint a = a )    ( 4 marks )
 
*/
 SELECT EMPNO, FIRSTNME, LASTNAME, SALARY, 
       ROUND(SALARY * 1.03, 2) AS increased_salary, PROJNO
FROM EMPLOYEE e 
NATURAL JOIN EMPPROJACT ep;

SELECT e.EMPNO, e.FIRSTNME, e.LASTNAME, e.SALARY, 
       ROUND(e.SALARY * 1.03, 2) AS increased_salary, ep.PROJNO
FROM EMPLOYEE e
JOIN EMPPROJACT ep USING (EMPNO);

SELECT e.EMPNO, e.FIRSTNME, e.LASTNAME, e.SALARY, 
       ROUND(e.SALARY * 1.03, 2) AS increased_salary, ep.PROJNO
FROM EMPLOYEE e
JOIN EMPPROJACT ep ON e.EMPNO = ep.EMPNO;

/*
 Question 4 ( 25 marks )
 
  a) Create three tables.  Two of the tables will have PRIMARY KEYS (mininum 3 columns in each table) and the third table will have two columns that are the foreign keys to each of the PRIMARY KEYS (6 marks)
 
 b) Populate these table with data (5 marks)

 c) Create a SELECT statement using NATURAL JOINS to connect the three tables together (7 marks)
 
 d) Run the Reverse Engineer function in MySQL workbench on these tables and provide the .MWB file in your submission ( 7 marks )
 
*/
-- Creating the first table with primary key
CREATE TABLE Table4a (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

-- Creating the second table with primary key
CREATE TABLE Table4b (
    id INT PRIMARY KEY,
    address VARCHAR(100),
    phone VARCHAR(15)
);

-- Creating the third table with foreign keys
CREATE TABLE Table4c (
    id1 INT,
    id2 INT,
    FOREIGN KEY (id1) REFERENCES Table4a(id),
    FOREIGN KEY (id2) REFERENCES Table4b(id)
);

 -- Populating Table4a with data
INSERT INTO Table4a (id, name, age) VALUES
(1, 'John', 30),
(2, 'Alice', 25),
(3, 'Bob', 35);

-- Populating Table4b with data
INSERT INTO Table4b (id, address, phone) VALUES
(101, '123 Main St', '555-1234'),
(102, '456 Oak Ave', '555-5678'),
(103, '789 Elm St', '555-9012');

-- Populating Table4c with data
INSERT INTO Table4c (id1, id2) VALUES
(1, 101),
(2, 102),
(3, 103);

-- SELECT statement using NATURAL JOIN to connect the three tables together
SELECT *
FROM Table4a
NATURAL JOIN Table4b
NATURAL JOIN Table4c;

/*
 Question 5 (15 marks)
 
  Write a query that uses INNER JOIN TO connect the EMPLOYEE, EMPPROJACT, PROJACT and PROJECT tables.   Include the Project number , Department number, Project start and end date and AC STAFF  
WHERE They belong to department D11 , Salary is more than or equal to 65 percent of $15,000 AND Salary is less than or equal to 130 percent of $40,000 

   
*/

SELECT 
    p.PROJNO AS Project_Number,
    p.DEPTNO AS Department_Number,
    p.PRSTDATE AS Project_Start_Date,
    p.PRENDATE AS Project_End_Date,
    pa.ACSTAFF AS AC_Staff
FROM 
    EMPLOYEE e
INNER JOIN 
    EMPPROJACT epa ON e.EMPNO = epa.EMPNO
INNER JOIN 
    PROJACT pa ON epa.PROJNO = pa.PROJNO AND epa.ACTNO = pa.ACTNO
INNER JOIN 
    PROJECT p ON pa.PROJNO = p.PROJNO
WHERE 
    e.WORKDEPT = 'D11'
    AND e.SALARY >= 0.65 * 15000
    AND e.SALARY <= 1.3 * 40000;




/*
 Question 6 (15 marks)
 
 Create a query that lists empno, projno, emptime, emendate.  Left join the project to the empprojact table using projno and left join the act table using actno and then right join employee table using empno. 
 Where projno is AD3113 and empno is 000270 and emptime is greater than 0.5
 
 
*/
SELECT 
    epa.EMPNO AS empno,
    epa.PROJNO AS projno,
    epa.EMPTIME AS emptime,
    epa.EMENDATE AS emendate
FROM 
    EMPPROJACT epa
LEFT JOIN 
    PROJECT p ON epa.PROJNO = p.PROJNO
LEFT JOIN 
    ACT a ON epa.ACTNO = a.ACTNO
RIGHT JOIN 
    EMPLOYEE e ON epa.EMPNO = e.EMPNO
WHERE 
    epa.PROJNO = 'AD3113'
    AND epa.EMPNO = '000270'
    AND epa.EMPTIME > 0.5;

/*
 Question 7 (15 marks)
 
  Describe all of the relationships between the tables in the attached image file TableRelationships.jpg
  
  a) describe all the foreign key and primary keys, by detailing the CREATE table statements for all the tables (10 marks)
  b) describe the relationship between each table ( 1..1 (exactly one match)  1..n (one or more matches)) (5 marks)

 
  

- 1-to-1 Relationships:
  1. Each transaction detail  corresponds to exactly one account .
  2. Each account belongs to exactly one branch . 
  3. Each loan  is associated with exactly one branch .

- 1-to-n Relationships:
  1. Each account  is associated with exactly one customer , but each customer can have multiple accounts. 
  2. Each loan  is associated with exactly one customer , but each customer can have multiple loans. 

*/
CREATE TABLE trandetails (
    tnumber VARCHAR(6) PRIMARY KEY,
    acnumber VARCHAR(6),
    dot DATE,
    medium_of_transaction VARCHAR(20),
    transaction_type VARCHAR(20),
    transaction_amount INT,
    FOREIGN KEY (acnumber)
        REFERENCES account (acnumber)
);

CREATE TABLE account (
    acnumber VARCHAR(6) PRIMARY KEY,
    custid VARCHAR(6),
    bid VARCHAR(6),
    opening_balance INT,
    aod DATE,
    atype VARCHAR(10),
    astatus VARCHAR(10),
    FOREIGN KEY (custid)
        REFERENCES customer (custid),
    FOREIGN KEY (bid)
        REFERENCES branch (bid)
);

CREATE TABLE customer (
    custid VARCHAR(6) PRIMARY KEY,
    fname VARCHAR(30),
    mname VARCHAR(30),
    lname VARCHAR(30),
    city VARCHAR(15),
    mobileno VARCHAR(10),
    occupation VARCHAR(10),
    dob DATE
);

CREATE TABLE branch (
    bid VARCHAR(6) PRIMARY KEY,
    bname VARCHAR(30),
    bcity VARCHAR(30)
);

CREATE TABLE loan (
    custid VARCHAR(6),
    bid VARCHAR(6),
    loan_amount INT,
    FOREIGN KEY (custid)
        REFERENCES customer (custid),
    FOREIGN KEY (bid)
        REFERENCES branch (bid)
);


 
 