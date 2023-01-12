-- --------------------------------------------------------
-- Διακομιστής:                  localhost
-- Έκδοση διακομιστή:            10.4.27-MariaDB - mariadb.org binary distribution
-- Λειτ. σύστημα διακομιστή:     Win64
-- HeidiSQL Έκδοση:              12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for lousi
CREATE DATABASE IF NOT EXISTS `lousi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `lousi`;
#reset database;
-- Dumping structure for πίνακας lousi.board
DROP TABLE IF EXISTS `board`;
CREATE TABLE IF NOT EXISTS `board` (
  `bid` enum('1','2') NOT NULL,
  `btile` varchar(10) DEFAULT NULL,
  `firstvalue` INT DEFAULT NULL,
  `secondvalue` INT DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.board: ~2 rows (approximately)
INSERT INTO `board` (`bid`) VALUES
	('1'),
	('2');

-- Dumping structure for πίνακας lousi.board_empty
DROP TABLE IF EXISTS `board_empty`;
CREATE TABLE IF NOT EXISTS `board_empty` (
  `bid` enum('1','2') NOT NULL,
  `btile` varchar(10) DEFAULT NULL,
  `firstvalue` INT DEFAULT NULL,
  `secondvalue` INT DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.board_empty: ~0 rows (approximately)
#DROP PROCEDURE cleanboard ;
-- Dumping structure for procedure lousi.cleanboard
DROP PROCEDURE IF EXISTS `cleanboard`;
DELIMITER //
CREATE PROCEDURE `cleanboard`()
BEGIN
	DROP TABLE  IF EXISTS `board`;
	CREATE TABLE board SELECT * FROM board_empty;
	 		/*set tile=null, last_change=null;*/
  			/*update `pieces` set `is_available`=1 Where `is_available`=0; it had not completed*/
  		update `gamestatus` set `status`='not active', `p_turn`=null,  `last_change` =null;
  		INSERT INTO `board` (`bid`) VALUES
			('1'),
			('2');

END//
DELIMITER ;
#CALL cleanboard();
#SELECT * FROM board;
#SELECT * FROM board_empty;


-- Dumping structure for πίνακας lousi.gamestatus
DROP TABLE IF EXISTS `gamestatus`;
CREATE TABLE IF NOT EXISTS `gamestatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('initialized','started','ended','aborted') NOT NULL DEFAULT 'initialized',
  `p_turn` enum('1','2') DEFAULT NULL,
  #`result` enum('1','2') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_GENERAL_CI;

#select firstvalue AS part1, secondvalue AS part2  from board where bid=1;
#select * from board;
-- Dumping data for table lousi.gamestatus: ~0 rows (approximately)

-- Dumping structure for πίνακας lousi.players
DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `result` varchar (11) DEFAULT NULL, 
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_GENERAL_CI;
-- Dumping data for table lousi.players: ~0 rows (approximately)


-- Dumping structure for πίνακας lousi.sharetile
DROP TABLE IF EXISTS `sharetile`;
CREATE TABLE IF NOT EXISTS `sharetile` (
  `id` int(11) NOT NULL,
  `tile_name` varchar(15) DEFAULT NULL,
  `player_name` varchar(10) DEFAULT NULL,
  #`firstvalue` INT DEFAULT NULL,
  #`secondvalue` INT DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=UTF8_GENERAL_CI;
#DROP TABLE sharetile;
-- Dumping data for table lousi.sharetile: ~0 rows (approximately)

-- Dumping structure for πίνακας lousi.tile
DROP TABLE IF EXISTS `tile`;
CREATE TABLE IF NOT EXISTS `tile` (
  `tilename` varchar(15) NOT NULL,
  `firstvalue` int(11) NOT NULL,
  `secondvalue` int(11) NOT NULL,
  PRIMARY KEY (`tilename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.tile: ~28 rows (approximately)
INSERT INTO `tile` (`tilename`, `firstvalue`, `secondvalue`) VALUES
	('0-0', 0, 0),
	('0-1', 0, 1),
	('0-2', 0, 2),
	('0-3', 0, 3),
	('0-4', 0, 4),
	('0-5', 0, 5),
	('0-6', 0, 6),
	('1-1', 1, 1),
	('1-2', 1, 2),
	('1-3', 1, 3),
	('1-4', 1, 4),
	('1-5', 1, 5),
	('1-6', 1, 6),
	('2-2', 2, 2),
	('2-3', 2, 3),
	('2-4', 2, 4),
	('2-5', 2, 5),
	('2-6', 2, 6),
	('3-3', 3, 3),
	('3-4', 3, 4),
	('3-5', 3, 5),
	('3-6', 3, 6),
	('4-4', 4, 4),
	('4-5', 4, 5),
	('4-6', 4, 6),
	('5-5', 5, 5),
	('5-6', 5, 6),
	('6-6', 6, 6);

-- Dumping structure for procedure lousi.tile_shuffle
DROP PROCEDURE IF EXISTS `tile_shuffle`;
DELIMITER //
CREATE PROCEDURE `tile_shuffle`()
BEGIN
	DROP TABLE IF EXISTS `clonetile`;
		CREATE TABLE clonetile AS
		SELECT * FROM tile			
		ORDER BY RAND();				
	END//
DELIMITER ;

-- Dumping structure for procedure lousi.update_sharetile
DROP PROCEDURE IF EXISTS `update_sharetile`;
DELIMITER //
CREATE PROCEDURE `update_sharetile`()
BEGIN
 	DECLARE counter INT;
  	SET counter=0;
  	
	CALL tile_shuffle();
  
  	while (counter<28) DO
  		#Βαζουμε id οτι ειναι και το counter πχ.αν counter=1 insert 1 
  		INSERT INTO sharetile(id) VALUES
  		(counter);
  		# kanoyme update to share tile diladi theloyme na paroyme ton pinaka clone tile pou exoume ta tiles se random metrisi kai oxi me tin siria opote
  		UPDATE sharetile
  		SET tile_name = (SELECT tilename FROM clonetile ORDER BY RAND() LIMIT 1)	    
  		WHERE tile_name IS NULL;
  		/*kanoume se sto tile_name to orisma pou pernoyme apo to query 
		  select tilename apo to tilename randomny ena ena opou to to tile_name apo ton pinaka sharetile=null*/
		  
  		DELETE FROM clonetile  WHERE tilename  IN (SELECT c.tilename FROM clonetile c INNER JOIN sharetile s WHERE c.tilename=s.tile_name);
  			/* 
			  Diagrafoyme apo to clonetile opou onoma einai idio me to onoma tile_name apo ton pinaka sharetile etsi wste na min exoume diplo egrafes
			  */

		#Stin sinexeia vazoyme tuxea onomata apo ton pinaka players ston pinaka share tile tuxea kai isa etsi wste na exoume ta tiles tou kathe pexti
  		UPDATE sharetile t
		SET t.player_name = (
  		SELECT p.name
  			FROM (
    				SELECT name, ROW_NUMBER() OVER (ORDER BY name) as row_num
    					FROM players
  				)p
  			WHERE p.row_num % (SELECT COUNT(*) FROM players) = t.id % (SELECT COUNT(*) FROM players)
		)LIMIT 14; 
		SET counter = counter + 1;
  	END WHILE;
    /*
	UPDATE sharetile
  	SET player_name = (SELECT name FROM players ORDER BY RAND() LIMIT 1) DIV 
  	WHERE player_name IS NULL;*/
 
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS `check_result`;
DELIMITER //
CREATE PROCEDURE `check_result` ()
BEGIN
	DECLARE res VARCHAR(10);
    
	 UPDATE players
    SET result = 'win'
    WHERE NAME NOT IN  (SELECT DISTINCT (player_name) FROM sharetile WHERE player_name IS not null);
    
    SELECT result INTO res  FROM players WHERE result='win';
    
    IF res='win' Then
    	UPDATE gamestatus
    		SET status='ended';
    END if;
END //
DELIMITER ;
#SELECT * FROM players;
#call check_result;
#select * from gamestatus;
#CALL check_result();

DROP PROCEDURE IF EXISTS `check_aboard`;
DELIMITER //
CREATE PROCEDURE `check_aboard` ()
BEGIN
	DECLARE cnt INT;
   SELECT COUNT(*) INTO cnt FROM board
     WHERE  btile is not null and last_change<(now()-INTERVAL 10 MINUTE);
IF cnt=1 then 
	update gamestatus 
	set status='aborded',
	p_turn=NULL;
	END if;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `draw_tile`;
DELIMITER //
CREATE PROCEDURE `draw_tile` (IN player_name VARCHAR(10))
BEGIN
    UPDATE sharetile t
    SET t.player_name = player_name
    WHERE t.player_name IS NULL Order by Rand() LIMIT 1; 
END //
DELIMITER ;


#CALL play_tile('1-1','aggelos2');
#call draw_tile('aggelos');
#select * from board;
#select * from sharetile;
#select * from gamestatus;
#select count(*) from sharetile where player_name is not null;
#select * from players;
#select count(*) from sharetile where player_name is not null;
#SELECT COUNT(*) FROM board WHERE btile IS NULL;

DROP PROCEDURE IF EXISTS `check_play`;
DELIMITER //
CREATE PROCEDURE check_play(IN ptile_name VARCHAR(15), IN p_name VARCHAR(15))
BEGIN
	DECLARE partt1 INT; DECLARE partt2 INT;
	DECLARE part1b1 INT; DECLARE part2b1 INT; DECLARE part1b2 INT; DECLARE part2b2 INT;
	DECLARE n INT;

	SELECT COUNT(*) INTO n  FROM board WHERE btile IS NULL;
	
	#part1b1=(SELECT firstvalue FROM board WHERE bid=1);
	#part2b1=(SELECT secondvalue FROM board WHERE bid=1);
	#part1b2=(SELECT firstvalue FROM board WHERE bid=2);
	#part2b2=(SELECT secondvalue FROM board WHERE bid=2);
	
	SELECT firstvalue INTO part1b1 FROM board WHERE bid=1; SELECT secondvalue INTO part2b1 FROM board WHERE bid=1;
	SELECT firstvalue INTO part1b2 FROM board WHERE bid=2; Select secondvalue INTO part2b2 FROM board WHERE bid=2;

	SELECT SUBSTRING_INDEX(ptile_name, '-', 1) INTO partt1; Select SUBSTRING_INDEX(ptile_name, '-', -1) INTO partt2;
	
	IF n!=0 THEN
  	
  		CALL first_move(ptile_name);
  		DELETE FROM sharetile WHERE tile_name=ptile_name;
		CALL update_turn(p_name);
	ELSE 
		IF partt1 = part1b1 THEN
    UPDATE board
    SET
      btile=ptile_name,
      secondvalue=NULL,
      firstvalue=partt2
    WHERE firstvalue=partt1;
	  			DELETE FROM sharetile WHERE tile_name=ptile_name;
	  			CALL update_turn(p_name);
	ELSE if partt1 = part2b2 then
		UPDATE board
	  	SET
		  	btile=ptile_name,
		  	firstvalue=NULL,
			secondvalue=partt2
	  	WHERE secondvalue=partt1;
	  	
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	CALL update_turn(p_name);
	
	ELSE if  partt2 = part1b1 then
		UPDATE board
	  	SET
		  	btile=ptile_name,
		  	secondvalue=NULL,
		  	firstvalue=partt1
	  	WHERE firstvalue=partt2;
	  	
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	CALL update_turn(p_name);
			
	ELSE if partt2 = part2b2 then
		UPDATE board
	  	SET
		  	btile=ptile_name,
		  	firstvalue=NULL,
		  	secondvalue=partt1
	  	WHERE secondvalue=partt2;
	  	
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	CALL update_turn(p_name);
	ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You cannot place this tile here';
  
  	END IF;
  		END IF;
  		END if;
  			END IF;
  					END IF;
END//
DELIMITER ;






DROP PROCEDURE IF EXISTS `update_turn`;
DELIMITER //
CREATE PROCEDURE `update_turn` (IN p_name VARCHAR(15))
BEGIN
	DECLARE p_id INT;
	SELECT id INTO p_ID from players where name=p_name;
UPDATE gamestatus
	  				SET  p_turn=if(p_id='1','2','1'),
	  				status='started'
	  			WHERE id=1;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS `play_tile`;
DELIMITER //
CREATE PROCEDURE `play_tile` (IN ptile_name VARCHAR(15), IN p_name VARCHAR(15))
BEGIN
  DECLARE cnt INT;
  DECLARE p_id INT;
  
  SELECT id  INTO p_ID from players where name=p_name;
	SELECT COUNT(*) INTO cnt FROM sharetile WHERE tile_name=ptile_name and p_name=player_name;
	IF cnt = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You Dont have this tile.';
	ELSE 
	
		CALL check_play(ptile_name,p_name);
	  	
	  	
  	END IF;
  	
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS `first_move`;
DELIMITER //
CREATE PROCEDURE `first_move` (IN ptile_name VARCHAR(15))
	BEGIN
		DECLARE partt1 INT; DECLARE partt2 INT;
	DECLARE part1b1 INT; DECLARE part2b1 INT; DECLARE part1b2 INT; DECLARE part2b2 INT;
	DECLARE n INT;

	SELECT COUNT(*) INTO n   FROM board WHERE btile IS NULL;
	
	SELECT firstvalue INTO part1b1 FROM board WHERE bid=1; SELECT secondvalue INTO part2b1 FROM board WHERE bid=1;
	SELECT firstvalue INTO part1b2 FROM board WHERE bid=2; Select secondvalue INTO part2b2 FROM board WHERE bid=2;

	SELECT SUBSTRING_INDEX(ptile_name, '-', 1) INTO partt1; Select SUBSTRING_INDEX(ptile_name, '-', -1) INTO partt2;
	
	if n=2 then
  		UPDATE board
  			SET
    		btile=ptile_name,
    		firstvalue=partt1,
    		secondvalue=partt2
  			WHERE bid=1;

	ELSE IF n=1 THEN
		 IF partt1=part1b1 then
  		UPDATE board
  			SET
    		btile=ptile_name,
    		firstvalue=partt1,
    		secondvalue=partt2
  		WHERE bid=2;
		
	
    	
		 ELSE 
		 	if partt2=part1b1 then
  				UPDATE board
  				SET
    				btile=ptile_name,
    				firstvalue=partt1,
    				secondvalue=partt2
  				WHERE bid=2;
		
	
  		
		  ELSE 
		   IF partt1=part2b1 then
		   	UPDATE board
  				SET
    				btile=ptile_name,
    				firstvalue=partt1,
    				secondvalue=partt2
  			
			  WHERE bid=2;
		 
		  
		
		ELSE  
			IF partt2=part2b1 then
		   	UPDATE board
  				SET
    				btile=ptile_name,
    				firstvalue=partt1,
    				secondvalue=partt2
  				WHERE bid=2;
		 
		 	   
  		
		  Else
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You cannot fist move';
  	END IF;
  	END if; 
	  END if;
	  END if;
	  END if;
	  END if;
  	
END //
DELIMITER ;








/*select count(*) from players where id=1 and name is not NULL;
INSERT INTO `players` (`last_action`) VALUES
	( '2023-1-5 17:16:54');
 INSERT INTO gamestatus(id) VALUES(1);
SELECT * FROM players;
SELECT COUNT(*) FROM `players`;
INSERT INTO  `players` (`name`,`token`)VALUES  ('villa',md5(CONCAT( 'villa', NOW())));*/
/*
select * from gamestatus;
INSERT INTO players(name) values ('vasilis2');
playersUPDATE players set token=md5(CONCAT('vasilis', NOW()))
where name=vasilis;
select * from players;

select * from players;
*/



-- Dumping structure for procedure lousi.play_tile

/*DROP PROCEDURE IF EXISTS `play_tile`;
DELIMITER //
CREATE PROCEDURE `play_tile` (IN ptile_name VARCHAR(15), IN p_name VARCHAR(15))
BEGIN
  DECLARE cnt INT;
  DECLARE p_id INT;
  SELECT id  INTO p_ID from players where name=p_name;
	SELECT COUNT(*) INTO cnt FROM sharetile WHERE tile_name=ptile_name and p_name=player_name;
	IF cnt = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You Dont have this tile.';
	ELSE 
		UPDATE board
	  	SET
		  btile=ptile_name
		  #last_change = NOW()
	  	WHERE bid=p_id;
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	UPDATE gamestatus
	  	SET  p_turn=if(p_id='1','2','1'),
	  		status='started'
	  	WHERE id=1;
	  	
	  	#if i want to play more tha 2 players 
	  	#UPDATE gamestatus
		#SET p_turn =
  			#CASE p_id
    			#WHEN 1 THEN '2'
    			#WHEN 2 THEN '3'
    			#WHEN 3 THEN '4'
    			#ELSE '1'
  			#END,
  		#status='started'
		#WHERE id=1;
	  	
	  	
	  	
  	END IF;
  	
END //
DELIMITER ; */



/*

DROP PROCEDURE IF EXISTS `play_tile`;
DELIMITER //
CREATE PROCEDURE `play_tile` (IN ptile_name VARCHAR(15), IN p_name VARCHAR(15))
BEGIN
  DECLARE cnt INT;
  DECLARE p_id INT;
  SELECT id  INTO p_ID from players where name=p_name;
	SELECT COUNT(*) INTO cnt FROM sharetile WHERE tile_name=ptile_name and p_name=player_name;
	IF cnt = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tile does not exist in sharetile table';
	ELSE 
		UPDATE board
	  	SET
		  btile=ptile_name
		  #last_change = NOW()
	  	WHERE bid=p_id;
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	UPDATE gamestatus
	  	SET  p_turn=if(p_id='1','2','1'),
	  		status='started'
	  	WHERE id=1;
  	END IF;
  	
END //
DELIMITER ;

SELECT SUBSTRING_INDEX(btile, '-', -1)
FROM board
WHERE bid = 2;

*/
#update game_status set p_turn=if(p_color='W','B','W');
/*#CALL play_tile('3-5', 'aggelos');
	select * from sharetile;
select * from players;
	select * from board;
	update board set btile='1-3' where bid='2'
	select * from players;
	select * from gamestatus;
	call cleanboard();
	INSERT INTO `gamestatus`(`id`) VALUES ('1');  
	select * from sharetile;
	select count(*) as c from sharetile where tile_name='0-1'
	SELECT * FROM sharetile WHERE tile_name LIKE '%1%';
	SELECT * FROM board WHERE bid IN (1, 2) AND btile IS NULL;
	SELECT SUBSTRING_INDEX('2-1-1', '-', 1) as part1,
       SUBSTRING_INDEX('2-1-1', '-', -1) as part2;
*/


	
	#CALL check_aboard();
	
	

/*
	SELECT Count(*) FROM sharetile;
	select * from gamestatus;
	CALL check_result('aggelos');
	select * from board;
	call tile_shuffle();
	select Count(*) from sharetile where player_name is not null;
	call update_sharetile();
	call draw_tile('agrgkkkelj');
	call update_sharetile;
	CALL play_tile('2-6', 'agrgkkkelj');
	select count(DISTINCT player_name) from sharetile;
	an ayto einai 1 tote  update players set result=1 where  name is not exist on table sharetile;
	create procudeure 
	UPDATE players
	SET result = 'win'
	WHERE name NOT IN (SELECT player_name FROM sharetile);
	select count(*) from sharetile where player_name='dasasas' is null;
	
	
	select * from tile;
	Delete from sharetile where player_name='aggelos';
	select * from sharetile;
	select * from players;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	DROP PROCEDURE IF EXISTS `check_play`;
DELIMITER //
CREATE PROCEDURE check_play(IN ptile_name VARCHAR(15), IN p_name VARCHAR(15))
BEGIN
	DECLARE partt1 INT; DECLARE partt2 INT;
	DECLARE part1b1 INT; DECLARE part2b1 INT; DECLARE part1b2 INT; DECLARE part2b2 INT;
	DECLARE n INT;

	SELECT COUNT(*) INTO n FROM board WHERE btile IS NULL;
	
	#part1b1=(SELECT firstvalue FROM board WHERE bid=1);
	#part2b1=(SELECT secondvalue FROM board WHERE bid=1);
	#part1b2=(SELECT firstvalue FROM board WHERE bid=2);
	#part2b2=(SELECT secondvalue FROM board WHERE bid=2);
	
	SELECT firstvalue As part1b1 FROM board WHERE bid=1; SELECT secondvalue as part2b1 FROM board WHERE bid=1;
	SELECT firstvalue as part1b2 FROM board WHERE bid=2; Select secondvalue as part2b2 FROM board WHERE bid=2;

	SELECT SUBSTRING_INDEX(ptile_name, '-', 1) INTO partt1; Select SUBSTRING_INDEX(ptile_name, '-', -1) INTO partt2;
	IF n=2 THEN
  		UPDATE board
  			SET
    		btile=ptile_name,
    		firstvalue=partt1,
    		secondvalue=partt2
  			WHERE bid=1;
  
  DELETE FROM sharetile WHERE tile_name=ptile_name;
	CALL update_turn(p_name);
	
	ELSEIF n=1 THEN
		if partt1=part1b1 then
  		UPDATE board
  			SET
    		btile=ptile_name,
    		firstvalue=partt1,
    		secondvalue=partt2
  		WHERE bid=2;
  
  DELETE FROM sharetile WHERE tile_name=ptile_name;
  CALL update_turn(p_name);
	
	ELSE IF partt1 = part1b1 THEN
    UPDATE board
    SET
      btile=ptile_name,
      secondvalue=NULL,
      firstvalue=partt2
    WHERE firstvalue=partt2;
	  			DELETE FROM sharetile WHERE tile_name=ptile_name;
	  			CALL update_turn(p_name);
	ELSE if partt1 = part2b2 then
		UPDATE board
	  	SET
		  	btile=ptile_name,
		  	firstvalue=NULL,
			secondvalue=partt2
	  	WHERE secondvalue=partt2;
	  	
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	CALL update_turn(p_name);
	
	ELSE if  partt2 = part1b1 then
		UPDATE board
	  	SET
		  	btile=ptile_name,
		  	secondvalue=NULL,
		  	firstvalue=partt1
	  	WHERE firstvalue=partt1;
	  	
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	CALL update_turn(p_name);
			
	ELSE if partt2 = part2b2 then
		UPDATE board
	  	SET
		  	btile=ptile_name,
		  	firstvaule=NULL,
		  	secondvalue=partt1
	  	WHERE firstvalue=partt1;
	  	
	  	DELETE FROM sharetile WHERE tile_name=ptile_name;
	  	CALL update_turn(p_name);
	ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You cannot place this tile here';
  
  	END IF;
  		END IF;
  			END IF;
  				END IF;
  					END IF;
END//
DELIMITER ;
	
	
	
	
	
	
	
	
*/






/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
