


CREATE DATABASE lousi;

CREATE TABLE players (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `handtiles` varchar(10) NOT NULL,
    `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (handtiles) References tile (tilename)
);

CREATE TABLE tile(
`tilename` varchar (10) NOT NULL,
`firstvalue` int NOT NULL,
`secondvalue` int NOT NULL,
primary key(tilename)

);

Create table  gameStatus(
`id` int NOT NULL AUTO_INCREMENT,
    `session_id` int NOT NULL,
    `status` enum(
        'initialized',
        'started',
        'ended',
        'aborted'
    ) NOT NULL DEFAULT 'initialized',
    `p_turn` int NOT NULL DEFAULT 1,
    `n_players` int NOT NULL,
    `winner` enum('0', '1', '2', '3', '4') NOT NULL,
    `loser` enum('0', '1', '2', '3', '4') NOT NULL,
    `first_round` BOOLEAN NOT NULL DEFAULT TRUE,
    `last_change` timestamp DEFAULT NOW(),
    `last_change`  timestamp NULL DEFAULT current_timestamp() 
    ON UPDATE current_timestamp(),
    
    PRIMARY KEY (id)
);


CREATE TABLE board (
	`tile` varchar(10),
	`last_change`  timestamp NULL DEFAULT current_timestamp() 
);






