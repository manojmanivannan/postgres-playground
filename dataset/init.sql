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
  dr_no varchar(20),
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
  premis_description varchar(80),
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

CREATE TABLE IF NOT EXISTS olympics_history
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

copy olympics_history
from '/docker-entrypoint-initdb.d/csv/athlete_events.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS olympics_history_noc_regions
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

copy olympics_history_noc_regions
from '/docker-entrypoint-initdb.d/csv/noc_regions.csv'
DELIMITER ','
CSV HEADER;
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS science_federal
(
    id                   SERIAL PRIMARY KEY,
    cmte_nm              VARCHAR(100),
    cmte_id              VARCHAR(100),
    cmte_tp              VARCHAR(100),
    cmte_pty             VARCHAR(100),
    cand_name            VARCHAR(100),
    cand_pty_affiliation VARCHAR(100),
    cand_office_st       VARCHAR(100),
    cand_office          VARCHAR(100),
    cand_office_district INT,
    cand_status          VARCHAR(100),
    rpt_tp               VARCHAR(100),
    transaction_pgi      VARCHAR(100),
    transaction_tp       VARCHAR(100),
    entity_tp            VARCHAR(100),
    cleaned_name         VARCHAR(100),
    city                 VARCHAR(100),
    state                VARCHAR(100),
    zip_code             VARCHAR(10),
    employer             VARCHAR(100),
    cleaned_occupation   VARCHAR(100),
    classification       VARCHAR(100),
    transaction_dt       INT,
    cycle                VARCHAR(100),
    transaction_amt      INT,
    dollars              NUMERIC(9,2),
    other_id             VARCHAR(100),
    tran_id              VARCHAR(100),
    file_num             INT,
    memo_cd              VARCHAR(100),
    memo_text            VARCHAR(100),
    sub_id               VARCHAR(100)
);

COMMENT ON COLUMN science_federal.cmte_nm IS 'Committee name';
COMMENT ON COLUMN science_federal.cmte_id IS 'Committee identification, assigned';
COMMENT ON COLUMN science_federal.cmte_tp IS 'Committee type. List of committee type codes';
COMMENT ON COLUMN science_federal.cmte_pty IS 'Committee party. List of party codes';
COMMENT ON COLUMN science_federal.cand_name IS 'Candidate name';
COMMENT ON COLUMN science_federal.cand_pty_affiliation IS 'Political party affiliation reported by the candidate';
COMMENT ON COLUMN science_federal.cand_office_st IS 'Candidate state';
COMMENT ON COLUMN science_federal.cand_office IS 'Candidate office. H = House, P = President, S = Senate';
COMMENT ON COLUMN science_federal.cand_office_district IS 'Candidate district';
COMMENT ON COLUMN science_federal.cand_status IS 'Candidate status. C = Statutory candidate, F = Statutory candidate for future election, N = Not yet a statutory candidate, P = Statutory candidate in prior cycle';
COMMENT ON COLUMN science_federal.rpt_tp IS 'Report type. Report type codes';
COMMENT ON COLUMN science_federal.transaction_pgi IS 'The code for which the contribution was made. EYYYY (election plus election year). P = Primary, G = General, O = Other, C = Convention, R = Runoff, S = Special, E = Recount';
COMMENT ON COLUMN science_federal.transaction_tp IS 'Transaction type. Type codes';
COMMENT ON COLUMN science_federal.entity_tp IS 'Entity type. Only valid for electronic filings received after April 2002. CAN = Candidate, CCM = Candidate Committee, COM = Committee, IND = Individual (a person), ORG = Organization (not a committee and not a person), PAC = Political Action Committee, PTY = Party Organization';
COMMENT ON COLUMN science_federal.cleaned_name IS 'Contributor/lender/transfer name';
COMMENT ON COLUMN science_federal.city IS 'City/town';
COMMENT ON COLUMN science_federal.state IS 'State';
COMMENT ON COLUMN science_federal.zip_code IS 'Zip code';
COMMENT ON COLUMN science_federal.employer IS 'Employer';
COMMENT ON COLUMN science_federal.cleaned_occupation IS 'Occupation';
COMMENT ON COLUMN science_federal.classification IS 'Classification of occupation';
COMMENT ON COLUMN science_federal.transaction_dt IS 'Transaction date (MMDDYYYY)';
COMMENT ON COLUMN science_federal.cycle IS 'Election cycle';
COMMENT ON COLUMN science_federal.transaction_amt IS 'Transaction amount';
COMMENT ON COLUMN science_federal.dollars IS 'Transaction amount adjusted for inflation';
COMMENT ON COLUMN science_federal.other_id IS 'Other identification number. For contributions from individuals this column is null. For contributions from candidates or other committees this column will contain that contributor"s FEC ID.';
COMMENT ON COLUMN science_federal.tran_id IS 'Transaction ID';
COMMENT ON COLUMN science_federal.file_num IS 'A unique identifier associated with each itemization or transaction appearing in an FEC electronic file. Only valid for electronic filings.';
COMMENT ON COLUMN science_federal.memo_cd IS '"X" indicates that the amount is not to be included in the itemization total.';
COMMENT ON COLUMN science_federal.memo_text IS 'A description of the activity.';
COMMENT ON COLUMN science_federal.sub_id IS 'FEC record number';

copy science_federal (cmte_nm, cmte_id, cmte_tp, cmte_pty, cand_name, cand_pty_affiliation, cand_office_st, cand_office, cand_office_district, cand_status, rpt_tp, transaction_pgi, transaction_tp, entity_tp, cleaned_name, city, state, zip_code, employer, cleaned_occupation, classification, transaction_dt, cycle, transaction_amt, dollars, other_id, tran_id, file_num, memo_cd, memo_text, sub_id)
from '/docker-entrypoint-initdb.d/csv/science_federal_giving.csv'
DELIMITER ','
QUOTE '"'
CSV HEADER;



-- -----------------------------------------------------------------
-- Enable extensions crosstab
CREATE EXTENSION TABLEFUNC;