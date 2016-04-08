-- Table definitions for the tournament project. 
-- 
-- Put your SQL 'create table' statements in this file; also 'create view' 
-- statements if you choose to use it. 
-- 
-- You can write comments in this file by starting them with two dashes, like 
-- these lines here. 

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players(
	NAME TEXT, 
	id SERIAL PRIMARY KEY
);

CREATE TABLE matches (
	player_one INTEGER REFERENCES players (id), 
	player_two INTEGER REFERENCES players (id), 
	winner INTEGER REFERENCES players (id) PRIMARY KEY
); 


CREATE VIEW player_wins 
	AS SELECT players.id, Count(matches.winner) AS wins 
	FROM players LEFT JOIN matches 
		ON(players.id = matches.winner) 
		GROUP BY  players.id;

CREATE VIEW player_matches
	AS SELECT players.id, Count(matches.player_one) AS matches 
	FROM players LEFT JOIN matches 
		ON(players.id = matches.player_one OR players.id = matches.player_two) 
	GROUP BY players.id;

CREATE VIEW player_standings 
	AS SELECT players.id, players.NAME, wins, matches 
	FROM players, player_wins, player_matches 
	WHERE players.id = player_matches.id AND players.id = player_wins.id 
	ORDER BY player_wins.wins DESC;