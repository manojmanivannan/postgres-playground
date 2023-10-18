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
CREATE TABLE scrabble (
  id SERIAL PRIMARY KEY,
  gameid INT NOT NULL,
  tourneyid INT NOT NULL,
  tie BOOLEAN NOT NULL,
  winnerid INT NOT NULL,
  winnername VARCHAR(50) NOT NULL,
  winnerscore INT NOT NULL,
  winneroldrating INT NOT NULL,
  winnernewrating INT NOT NULL,
  winnerpos INT NOT NULL,
  loserid INT NOT NULL,
  losername VARCHAR(50) NOT NULL,
  loserscore INT NOT NULL,
  loseroldrating INT NOT NULL,
  losernewrating INT NOT NULL,
  loserpos INT NOT NULL,
  round INT NOT NULL,
  division INT NOT NULL,
  date DATE NOT NULL,
  lexicon BOOLEAN NOT NULL
);

COMMENT ON COLUMN scrabble.gameid IS 'A numerical game ID';
COMMENT ON COLUMN scrabble.tourneyid IS 'A numerical tournament ID';
COMMENT ON COLUMN scrabble.tie IS 'A binary variable indicating if the game ended in a tie';
COMMENT ON COLUMN scrabble.winnerid IS 'A numerical ID for the winning player';
COMMENT ON COLUMN scrabble.winnername IS 'The name of the winning player';
COMMENT ON COLUMN scrabble.winnerscore IS 'The score of the winning player';
COMMENT ON COLUMN scrabble.winneroldrating IS 'The winner-s rating before the game';
COMMENT ON COLUMN scrabble.winnernewrating IS 'The winner-s rating after the game';
COMMENT ON COLUMN scrabble.winnerpos IS 'The winner-s position in the tournament';
COMMENT ON COLUMN scrabble.loserid IS 'A numerical ID for the losing player';
COMMENT ON COLUMN scrabble.losername IS 'The name of the losing player';
COMMENT ON COLUMN scrabble.loserscore IS 'The score of the losing player';
COMMENT ON COLUMN scrabble.loseroldrating IS 'The loser-s rating before the game';
COMMENT ON COLUMN scrabble.losernewrating IS 'The loser-s rating after the game';
COMMENT ON COLUMN scrabble.loserpos IS 'The loser-s position in the tournament';
COMMENT ON COLUMN scrabble.round IS 'The round of the tournament in which the game took place';
COMMENT ON COLUMN scrabble.division IS 'The division of the tournament in which the game took place';
COMMENT ON COLUMN scrabble.date IS 'The date of the game';
COMMENT ON COLUMN scrabble.lexicon IS 'A binary variable indicating if the game-s lexicon was the main North American lexicon (False) or the international lexicon (True)';

copy scrabble (gameid, tourneyid, tie, winnerid, winnername, winnerscore, winneroldrating, winnernewrating, winnerpos, loserid, losername, loserscore, loseroldrating, losernewrating, loserpos, round, division, date, lexicon)
from '/docker-entrypoint-initdb.d/csv/scrabble_games.csv'
DELIMITER ','
CSV HEADER;
-- -----------------------------------------------------------------
-- Enable extensions crosstab
CREATE EXTENSION TABLEFUNC;