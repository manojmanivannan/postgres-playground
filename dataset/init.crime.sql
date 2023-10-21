
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

COMMENT ON COLUMN crime_data.dr_no IS 'Division of Records Number: Official file number made up of a 2 digit year, area ID, and 5 digits';
COMMENT ON COLUMN crime_data.date_reported IS 'MM/DD/YYYY';
COMMENT ON COLUMN crime_data.date_occured IS 'MM/DD/YYYY';
COMMENT ON COLUMN crime_data.time_occured IS 'In 24 hour military time';
COMMENT ON COLUMN crime_data.area IS 'The LAPD has 21 Community Police Stations referred to as Geographic Areas within the department. These Geographic Areas are sequentially numbered from 1-21';
COMMENT ON COLUMN crime_data.area_name IS 'The 21 Geographic Areas or Patrol Divisions are also given a name designation that references a landmark or the surrounding community that it is responsible for. For example 77th Street Division is located at the intersection of South Broadway and 77th Street, serving neighborhoods in South Los Angeles.';
COMMENT ON COLUMN crime_data.reported_dist_no IS 'A four-digit code that represents a sub-area within a Geographic Area. All crime records reference the "RD" that it occurred in for statistical comparisons.';
COMMENT ON COLUMN crime_data.crime_code IS 'Indicates the crime committed. (Same as Crime Code 1)';
COMMENT ON COLUMN crime_data.crime_description IS 'Defines the Crime Code provided.';
COMMENT ON COLUMN crime_data.mocodes IS 'Modus Operandi: Activities associated with the suspect in commission of the crime.See attached PDF for list of MO Codes in numerical ';
COMMENT ON COLUMN crime_data.victim_age IS 'Two character numeric';
COMMENT ON COLUMN crime_data.victim_sex IS 'F-Female, M-Male, X-Unknown';
COMMENT ON COLUMN crime_data.victim_descent IS 'Descent Code: A - Other Asian B - Black C - Chinese D - Cambodian F - Filipino G - Guamanian H - Hispanic/Latin/Mexican I - American Indian/Alaskan Native J - Japanese K - Korean L - Laotian O - Other P - Pacific Islander S - Samoan U - Hawaiian V - Vietnamese W - White X - Unknown Z - Asian Indian';
COMMENT ON COLUMN crime_data.premis_code IS 'The type of structure, vehicle, or location where the crime took place.';
COMMENT ON COLUMN crime_data.premis_description IS 'Defines the Premise Code provided.';
COMMENT ON COLUMN crime_data.weapon_used_code IS 'The type of weapon used in the crime.';
COMMENT ON COLUMN crime_data.weapon_used_description IS 'Defines the Weapon Used Code provided.';
COMMENT ON COLUMN crime_data.status_code IS 'Status of the case. (IC is the default)';
COMMENT ON COLUMN crime_data.status_description IS 'Defines the Status Code provided.';
COMMENT ON COLUMN crime_data.crime_code_1 IS 'Indicates the crime committed. Crime Code 1 is the primary and most serious one. Crime Code 2, 3, and 4 are respectively less serious offenses. Lower crime class numbers are more serious.';
COMMENT ON COLUMN crime_data.crime_code_2 IS 'May contain a code for an additional crime, less serious than Crime Code 1.';
COMMENT ON COLUMN crime_data.crime_code_3 IS 'May contain a code for an additional crime, less serious than Crime Code 1.';
COMMENT ON COLUMN crime_data.crime_code_4 IS 'May contain a code for an additional crime, less serious than Crime Code 1.';
COMMENT ON COLUMN crime_data.location IS 'Street address of crime incident rounded to the nearest hundred block to maintain anonymity.';
COMMENT ON COLUMN crime_data.cross_street IS 'Cross Street of rounded Address';
COMMENT ON COLUMN crime_data.latitude IS 'Latitude';
COMMENT ON COLUMN crime_data.longitude IS 'Longitude';

copy crime_data
from '/docker-entrypoint-initdb.d/csv/crime_data.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS crime_vic_descent
(
	  id serial,
    code VARCHAR(1),
    description VARCHAR(35)
);

copy crime_vic_descent(code,description)
from '/docker-entrypoint-initdb.d/csv/crime_vic_descent.csv'
DELIMITER ','
CSV HEADER;

