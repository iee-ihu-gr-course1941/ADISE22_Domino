

DROP TABLE IF EXISTS `lousi`;
CREATE DATABASE lousi;



DROP TABLE IF EXISTS `tile`;
CREATE TABLE tile(
`tilename` varchar (15) NOT NULL,
`firstvalue` int NOT NULL,
`secondvalue` int NOT NULL,
primary key(tilename)

);


DROP TABLE IF EXISTS `players`;
CREATE TABLE players (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    /*`handtiles` varchar(10) ,*/
    `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (id)
   /* FOREIGN KEY (handtiles) References tile (tilename)*/
);

DROP TABLE IF EXISTS `gameStatus`;
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
    /*`last_change` timestamp DEFAULT NOW(),*/
    `last_change`  timestamp NULL DEFAULT current_timestamp() 
    ON UPDATE current_timestamp(),
    
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS `board`;
CREATE TABLE board (
	`tile` varchar(10),
	`last_change`  timestamp NULL DEFAULT current_timestamp(), 
    primary key(tile,last_change)
);


/*
We create a procedure to share piles to each player
*/

DROP PROCEDURE IF EXISTS `sharepiles`;
DELIMITER //
CREATE PROCEDURE `sharepiles`()
BEGIN
	declare  pile int;
    declare player int;
    declare share int;
	
	    SELECT COUNT(*) INTO player FROM players;
        SELECT COUNT(*) INTO pile FROM piles;
        SET share = pile / player;
        UPDATE piles
        SET piles = share;
	
    END//
DELIMITER ;







