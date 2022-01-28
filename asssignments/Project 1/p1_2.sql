/* ========== PROJECT 1.1 ORIGINAL DATABASE SCHEMA ========== */

DROP TABLE department CASCADE;
DROP TABLE employee CASCADE;
DROP TABLE status CASCADE;
DROP TABLE supervisor CASCADE;
DROP TABLE depmanager CASCADE;

/* Department table - list of all departments and their names */
CREATE TABLE department (
	did		char(2) UNIQUE, /* An ID number for each department */
	depname	varchar(20) PRIMARY KEY /* Unique department */
);
INSERT INTO department (did, depname)
VALUES
	('D1', 'hot foods'),
	('D2', 'sandwich'),
	('D3', 'snacks'),
	('D4', 'beverage');
SELECT * FROM department;

/* Employee table - list of employees, department they work in */
CREATE TABLE employee (
	ssn		char(11) PRIMARY KEY,
	name	varchar(20) NOT NULL,
	salary	decimal(8, 2),
	sdate	date /* Employee hire date */,
	depname	varchar(20),
	FOREIGN KEY (depname) REFERENCES department
);
INSERT INTO employee (ssn, name, salary, sdate, depname)
VALUES
	('134-56-8877', 'Jim Jones', 28000, '01-26-2015', 'hot foods'),
	('138-56-8050', 'Rita Bita', 32000, '02-15-2017', 'beverage'),
	('334-55-8877', 'Holly Dew', 29000, '01-15-2016', 'sandwich'),
	('666-56-6666', 'Pablo Escobar', 48000, '01-26-2014', 'snacks'),
	('888-91-8870', 'Al Capone', 40000, '01-26-2015', 'hot foods'),
	('111-22-3333', 'Bonnie Clyde', 42000, '04-07-2015', 'sandwich');
SELECT * FROM employee;

/* Manager table - mapping of managers to their apointment date */
CREATE TABLE manager (
	m_ssn	char(11) PRIMARY KEY, /* Manager SSN */
	apdate	date, /* Date of manager appointment to department */
	FOREIGN KEY (m_ssn) REFERENCES employee(ssn)
);
INSERT INTO manager (m_ssn, apdate)
VALUES
	('138-56-8050', '03-18-2018'),
	('666-56-6666', '05-05-2015'),
	('888-91-8870', '01-01-2016'),
	('111-22-3333', '01-01-2016');
SELECT * FROM manager;

/* Supervisor table - mapping of supervisor to supervisee */
CREATE TABLE supervisor (
	ssn	char(11) NOT NULL PRIMARY KEY,
	s_ssn	char(11) NOT NULL,
	FOREIGN KEY (ssn) REFERENCES employee,
	FOREIGN KEY (s_ssn) REFERENCES employee(ssn)
);
INSERT INTO supervisor (ssn, s_ssn)
VALUES
	('134-56-8877', '138-56-8050'),
	('138-56-8050', '334-55-8877'),
	('334-55-8877', '666-56-6666'),
	('666-56-6666', '138-56-8050'),
	('888-91-8870', '666-56-6666'),
	('111-22-3333', '888-91-8870');
SELECT * FROM supervisor;

/* ========== PROJECT 1.2 ========== */

/* MODIFICATION OF THE DATABASE TO REFLECT NEW BUSINESS RULE */
/* Add employee status (employee, supervisor and/or manager) and discount amount as additional attributes in employee table */
/* Employee table - list of employees, department they work in */
ALTER TABLE employee ADD title varchar(20);
ALTER TABLE employee ADD discount decimal(5, 4);

UPDATE employee SET title = 'Employee', discount = 0.15 WHERE ssn = '134-56-8877';
UPDATE employee SET title = 'Manager', discount = 0.25 WHERE ssn = '138-56-8050';
UPDATE employee SET title = 'Supervisor', discount = 0.2 WHERE ssn = '334-55-8877';
UPDATE employee SET title = 'Manager', discount = 0.25 WHERE ssn = '666-56-6666';
UPDATE employee SET title = 'Manager', discount = 0.25  WHERE ssn = '888-91-8870';
UPDATE employee SET title = 'Manager', discount = 0.25 WHERE ssn = '111-22-3333';

SELECT * FROM employee;

/* MODIFICATION TO 3NF */
/* Status table - list of all employee types and their associated discount amounts */
CREATE TABLE status (
	title	varchar(20) PRIMARY KEY, /* One of employee, supervisor, manager. */
	/* It is assumed that all employees will take use of the highest discount available to them
	i.e. an employee that is a manager and a supervisor will be listed as a manager 
	to take account of the higher 25% discount */
	discount decimal(5, 4) /* Employee 15%, supervisor 20%, manager 25% */
);
INSERT INTO status (title, discount)
VALUES
	('Manager', 0.25),
	('Supervisor', 0.2),
	('Employee', 0.15);
SELECT * FROM status;

/* Update employee table to include just title - remove discount attribute */
ALTER TABLE employee
DROP COLUMN discount;
SELECT * FROM employee;

/* Replace original manager table with depmanager table */
DROP TABLE manager CASCADE;
/* depmanager table - mapping of department to manager */
CREATE TABLE depmanager (
	depname	varchar(20),
	mssn	char(11),
	apdate	date,
	PRIMARY KEY (depname, mssn),
	FOREIGN KEY (depname) REFERENCES department,
	FOREIGN KEY (mssn) REFERENCES employee(ssn)
);
INSERT INTO depmanager (depname, mssn, apdate)
VALUES
	('beverage', '138-56-8050', '03-18-2018'),
	('snacks', '666-56-6666', '05-05-2015'),
	('hot foods', '888-91-8870', '01-01-2016'),
	('sandwich', '111-22-3333', '01-01-2016');
SELECT * FROM depmanager;

/* Create a view that shows for each employee their name, department, supervisor, and discount level and no other fields. 
Name this view "emp_discount".*/
CREATE VIEW emp_discount AS
SELECT E.name, E.depname, S.s_ssn, St.discount
	FROM employee AS E, supervisor AS S, status AS St
	WHERE E.ssn = S.ssn AND E.title = St.title;
SELECT * FROM emp_discount;

/* Use "emp_discount" to write a query which outputs for each department, 
and the average discount for all members of the department. */
SELECT depname, avg(discount) AS avgDepDiscount
	FROM emp_discount
	GROUP BY depname;
