CREATE TABLE inflation_data (
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

CREATE TABLE IF not EXISTS crime_data
(
  dr_no int,
  date_reported timestamp,
  date_occured timestamp,
  time_occured time,
  area int,
  area_name varchar(30),
  reported_dist_no int,
  part_1_2 int,
  crime_code int,
  crime_description varchar(70),
  mocodes varchar(60),
  victim_age int,
  victim_sex varchar(1),
  victim_descent varchar(1),
  premis_code int,
  premis_description varchar(60),
  weapon_used_code int,
  weapon_used_description varchar(50),
  status_code varchar(2),
  status_description varchar(20),
  crime_code_1 int,
  crime_code_2 int,
  crime_code_3 int,
  crime_code_4 int,
  location varchar(60),
  cross_street varchar(50),
  latitude numeric(11,8),
  longitude numeric(11,8)
);

copy crime_data
from '/docker-entrypoint-initdb.d/csv/crime_data.csv'
DELIMITER ','
CSV HEADER;

-- -----------------------------------------------------------------------
