use gsddb;

create table employees (
	emp_id int auto_increment not null,
    first_name varchar(50),
    last_name varchar(50),
	hire_date date not null,
    salary int not null,
    primary key(emp_id));
   
insert into employees values ('1', 'Jugastru', 'Diana','2023-05-04','3000'),
							 ('2', 'Popa','Adelina','2019-04-22','8000'),
							 ('3', 'Popescu','Tudor','2022-01-17','4500'),
							 ('4', 'Apetrei', 'Dan','2013-05-01','5000');
select * from employees;

 create table personal_data (
	emp_id int auto_increment not null,
	birth_date DATE not null, 
	email_address varchar(100) not null,
    phone varchar(25) not null,
    address varchar(50) not null,
    marital_status ENUM ('Single','Married','Divorced','Other'),
    age varchar(50) not null,
   FOREIGN KEY(emp_id) references employees(emp_id) ON DELETE CASCADE);
   
insert into personal_data values ('1', '1996-04-22','diana.jugastru@gsdgroup.net','0747287872','Str.Lunga 70B, Sibiu','Single','27'),
								 ('2', '1990-09-14','adelina.popa@gsdgroup.net','0747254879','Str.Avrig 20,Sibiu','Married','33'),
                                 ('3', '1985-11-11','tudor.popescu@gsdgroup.net','0747236989','Str.O.Goga 22,Sibiu','Divorced','38'),
                                 ('4', '1980-06-06','dan.apetrei@gsdgroup.net','0777524547','Str.Ion Ratiu 40C,Selimbar','Other','43');
select * from personal_data;

create table job_title (
	emp_id int auto_increment not null,
    position varchar(100) not null,
    job_description varchar(150) not null,
    FOREIGN KEY (emp_id) references employees(emp_id) ON DELETE CASCADE);

insert into job_title values ('1','Software Engineer','Develop and maintain software applications,code reviews and collaborate with dev team'),
							 ('2','Project Manager', 'Plan and manage software development'),
                             ('3', 'Frontend Developer','Implement user interfaces'),
                             ('4', 'Designer', 'Design user inkterfaces');	
select * from job_title;

create table previous_company (
	emp_id int auto_increment not null,
    lastCompanyName varchar(50) not null,
    lastCompanyAddress varchar(100) not null,
    lastCompanyPhone varchar(25) not null,
    start_date date not null,
    end_date date not null ,
    FOREIGN KEY (emp_id) references employees(emp_id) ON DELETE CASCADE);

insert into previous_company values('1', 'Autobyte Solutions','Str.Mare','0747124578','2000-02-02','2022-04-04'),
								   ('2', 'Radient Spark', 'Str.Mica 30','0747587874','2004-04-05','2018-01-01'),
                                   ('3', 'Titan Tech','Str.Nomad 21a','0747232323','2019-02-03','2020-02-03'),
                                   ('4', 'Greenstone','Str. Rusciorului 19a', '0747287874','2000-05-01','2012-05-01');
select * from previous_company;
drop procedure if exists employeeName;
USE gsddb;
DELIMITER $$

CREATE PROCEDURE employeeName(IN employee_name VARCHAR(100))
BEGIN
    DECLARE employee_id INT;
    DECLARE last_company_name VARCHAR(50);

    SELECT emp_id INTO employee_id FROM employees WHERE first_name = employee_name OR last_name = employee_name;
	SELECT lastCompanyName INTO last_company_name FROM previous_company
    
    WHERE emp_id = employee_id
    
    ORDER BY end_date DESC
    LIMIT 1;

    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name, last_company_name,
        pd.address
       
    FROM
        employees e
    LEFT JOIN personal_data pd ON e.emp_id = pd.emp_id
    WHERE (e.first_name = employee_name OR e.last_name = employee_name)
    AND pd.emp_id = employee_id;
END$$

DELIMITER ;

CALL employeeName('Jugastru');
