-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

create database tournament;

\c tournament;

create table players(
	name text,
	id serial primary key
);

create table matches(
	player_one integer references players (id),
	player_two integer references players (id),
	winner integer references players (id)
);

-- Returns a list of the players and their win records, sorted by wins.

-- The first entry in the list should be the player in first place, or a player
-- tied for first place if there is currently a tie.

-- Returns:
--   A list of tuples, each of which contains (id, name, wins, matches):
--     id: the player's unique id (assigned by the database)
--     name: the player's full name (as registered)
--     wins: the number of matches the player has won
--     matches: the number of matches the player has played

-- count the wins a player has
create view player_wins
	as select players.id, count(matches.winner) as wins
	from players left join matches
		on (players.id = matches.winner)
	group by players.id;

create view player_matches
	as select players.id, count(matches.player_one) as matches
	from players left join matches
		on (players.id = matches.player_one or players.id = matches.player_two)
	group by players.id;


create view player_standings
	as select players.id, players.name, wins, matches
	from players, player_wins, player_matches
	where players.id = player_matches.id and players.id = player_wins.id
	order by player_wins.wins desc;

