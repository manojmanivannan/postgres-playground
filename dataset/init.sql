CREATE TABLE if not exists inflation_data (
    RegionalMember TEXT,
    Year INT,
    Inflation DECIMAL,
    Unit_of_Measurement TEXT,
    Subregion TEXT,
    Country_Code TEXT,
    PRIMARY KEY (RegionalMember,Year)
);

COPY inflation_data
FROM '/docker-entrypoint-initdb.d/csv/inflation.csv'
DELIMITER ','
CSV HEADER;

-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

COPY employee
FROM '/docker-entrypoint-initdb.d/csv/employee.csv'
DELIMITER ','
CSV HEADER;

-- -----------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

COPY doctors
from '/docker-entrypoint-initdb.d/csv/doctors.csv'
DELIMITER ','
CSV HEADER;

-- -----------------------------------------------------------------------

CREATE TABLE IF not EXISTS login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

COPY login_details
from '/docker-entrypoint-initdb.d/csv/login_details.csv'
DELIMITER ','
CSV HEADER;

-- -----------------------------------------------------------------------

CREATE TABLE IF not EXISTS patient_logs
(
  account_id int,
  date date,
  patient_id int
);

copy patient_logs
from '/docker-entrypoint-initdb.d/csv/patient_logs.csv'
DELIMITER ','
CSV HEADER;

-- -----------------------------------------------------------------------


