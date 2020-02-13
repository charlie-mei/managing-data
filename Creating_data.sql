CREATE TABLE teachers (
	id bigserial, /* bigserial increments by itself */
	first_name varchar(25), /* varchar(n) specifies text with max of n characters */
	last_name varchar(50),
	school varchar(50),
	hire_date date,
	salary numeric
);