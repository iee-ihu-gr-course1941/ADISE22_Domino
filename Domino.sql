
DROP DATABASE IF EXISTS lousi;

CREATE DATABASE lousi;


CREATE TABLE IF NOT EXISTS `tile`(
`tilename` varchar (15) NOT NULL,
`firstvalue` int NOT NULL,
`secondvalue` int NOT NULL,
primary key(tilename)

);

Insert into tile(tilename,firstvalue,secondvalue)values 
('0-0',0,0),

('0-1',0,1),
('1-1',1,1),

('0-2',0,2),
('1-2',1,2),
('2-2',2,2),

('0-3',0,3),
('1-3',1,3),
('2-3',2,3),
('3-3',3,3),

('0-4',0,4),
('1-4',1,4),
('2-4',2,4),
('3-4',3,4),
('4-4',4,4),

('0-5',0,5),
('1-5',1,5),
('2-5',2,5),
('3-5',3,5),
('4-5',4,5),
('5-5',5,5);

('0-6',0,6);
('1-6',1,6);
('2-6',2,6);
('3-6',3,6);
('4-6',4,6);
('5-6',5,6);
('6-6',6,6);


CREATE TABLE IF NOT EXISTS `players` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `handtiles` varchar(10) NOT NULL,
    `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (id),
    FOREIGN KEY (handtiles) References tile (tilename)
);

Create TABLE IF NOT EXISTS `gameStatus`(
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


CREATE TABLE IF NOT EXISTS `board` (
	`tile` varchar(10),
	`last_change`  timestamp NULL DEFAULT current_timestamp() 
);



DROP PROCEDURE IF EXISTS `sharepiles`;
DELIMITER //
CREATE PROCEDURE `sharepiles`()
BEGIN
	declare  pile int;
    declare player int;
    declare share int;
	
	    SELECT COUNT(*) INTO player_count FROM players;
        SELECT COUNT(*) INTO pile FROM piles;
        SET share = pile / player_count;
        UPDATE piles
        SET piles = share;
	
    END//
DELIMITER ;









