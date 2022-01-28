CREATE TABLE suppliers (
	sid integer,
	sname varchar(20),
	address varchar(100)
);

CREATE TABLE parts (
	pid integer,
	pname varchar(20),
	color varchar(20)
);

CREATE TABLE cat (
	sid integer,
	pid integer,
	cost numeric(10, 10)
);