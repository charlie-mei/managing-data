CREATE TABLE department (
	did		char(2) UNIQUE, /* An ID number for each department */
	depname		varchar(20) PRIMARY KEY /* Unique department */
);

CREATE TABLE employee (
	ssn	char(11) PRIMARY KEY,
	name	varchar(20) NOT NULL,
	salary	numeric(8, 2),
	sdate	date /* Employee hire date */,
	depname	varchar(20),
	FOREIGN KEY (depname) REFERENCES department
);

CREATE TABLE manager (
	m_ssn	char(11) PRIMARY KEY, /* Manager SSN */
	apdate	date, /* Date of manager appointment to department */
	FOREIGN KEY (m_ssn) REFERENCES employee(ssn)
);

CREATE TABLE supervisor (
	ssn	char(11) NOT NULL PRIMARY KEY,
	s_ssn	char(11) NOT NULL,
	FOREIGN KEY (ssn) REFERENCES employee,
	FOREIGN KEY (s_ssn) REFERENCES employee(ssn)
);

INSERT INTO department (did, depname)
VALUES
	('D1', 'hot foods'),
	('D2', 'sandwich'),
	('D3', 'snacks'),
	('D4', 'beverage');
SELECT * FROM department;
	
INSERT INTO employee (ssn, name, salary, sdate, depname)
VALUES
	('134-56-8877', 'Jim Jones', 28000, '01-26-2015', 'hot foods'),
	('138-56-8050', 'Rita Bita', 32000, '02-15-2017', 'beverage'),
	('334-55-8877', 'Holly Dew', 29000, '01-15-2016', 'sandwich'),
	('666-56-6666', 'Pablo Escobar', 48000, '01-26-2014', 'snacks'),
	('888-91-8870', 'Al Capone', 40000, '01-26-2015', 'hot foods'),
	('111-22-3333', 'Bonnie Clyde', 42000, '04-07-2015', 'sandwich');
SELECT * FROM employee;
	
INSERT INTO manager (m_ssn, apdate)
VALUES
	('138-56-8050', '03-18-2018'),
	('666-56-6666', '05-05-2015'),
	('888-91-8870', '01-01-2016'),
	('111-22-3333', '01-01-2016');
SELECT * FROM manager;

INSERT INTO supervisor (ssn, s_ssn)
VALUES
	('134-56-8877', '138-56-8050'),
	('138-56-8050', '334-55-8877'),
	('334-55-8877', '666-56-6666'),
	('666-56-6666', '138-56-8050'),
	('888-91-8870', '666-56-6666'),
	('111-22-3333', '888-91-8870');
SELECT * FROM supervisor;