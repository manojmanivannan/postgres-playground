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