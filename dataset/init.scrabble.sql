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