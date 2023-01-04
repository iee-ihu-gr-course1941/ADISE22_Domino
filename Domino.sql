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

-- Dumping structure for πίνακας lousi.board
CREATE TABLE IF NOT EXISTS `board` (
  `bid` enum('1','2') NOT NULL,
  `btile` varchar(10) DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.board: ~2 rows (approximately)
INSERT INTO `board` (`bid`, `btile`, `last_change`) VALUES
	('1', NULL, '2023-01-04 19:29:07'),
	('2', NULL, '2023-01-04 19:29:07');

-- Dumping structure for πίνακας lousi.board_empty
CREATE TABLE IF NOT EXISTS `board_empty` (
  `bid` enum('1','2') NOT NULL,
  `btile` varchar(10) DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.board_empty: ~0 rows (approximately)

-- Dumping structure for procedure lousi.cleanboard
DELIMITER //
CREATE PROCEDURE `cleanboard`()
BEGIN
	DROP TABLE  IF EXISTS `board`;
	CREATE TABLE board SELECT * FROM board_empty;
	 		/*set tile=null, last_change=null;*/
  			/*update `pieces` set `is_available`=1 Where `is_available`=0; it had not completed*/
  		update `gamestatus` set `status`='not active', `p_turn`=null, `result`=null,  `last_change` =null;
END//
DELIMITER ;

-- Dumping structure for πίνακας lousi.gamestatus
CREATE TABLE IF NOT EXISTS `gamestatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('initialized','started','ended','aborted') NOT NULL DEFAULT 'initialized',
  `p_turn` enum('1','2') DEFAULT NULL,
  `result` enum('1','2') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.gamestatus: ~0 rows (approximately)

-- Dumping structure for πίνακας lousi.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `last_action` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.players: ~0 rows (approximately)


/*

INSERT INTO players(name) values ('vasilis');

select * from players;
*/



-- Dumping structure for procedure lousi.play_tile
DELIMITER //
CREATE PROCEDURE `play_tile`(IN p_id ENUM ('1','2'), IN tile_name VARCHAR(15))
BEGIN
  	UPDATE board
  	SET
	  btile=tile_name,
	  last_change = NOW()
  	where bid=p_id;
  	
  	UPDATE gamestatus
  	SET  p_turn=p_id,
  		status='started'
  	WHERE id=1;
  		 
END//
DELIMITER ;

-- Dumping structure for πίνακας lousi.sharetile
CREATE TABLE IF NOT EXISTS `sharetile` (
  `id` int(11) NOT NULL,
  `tile_name` varchar(15) DEFAULT NULL,
  `player_name` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table lousi.sharetile: ~0 rows (approximately)

-- Dumping structure for πίνακας lousi.tile
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
DELIMITER //
CREATE PROCEDURE `update_sharetile`()
BEGIN
 	DECLARE counter INT;
  	SET counter=0;
  	
	CALL tile_shuffle();
  
  	while (counter<28) DO
  
  		INSERT INTO sharetile(id) VALUES
  		(counter);
  
  		UPDATE sharetile
  		SET tile_name = (SELECT tilename FROM clonetile ORDER BY RAND() LIMIT 1)
  		WHERE tile_name IS NULL;
  		DELETE FROM clonetile  WHERE tilename  IN (SELECT c.tilename FROM clonetile c INNER JOIN sharetile s WHERE c.tilename=s.tile_name);
  

  		UPDATE sharetile t
		SET t.player_name = (
  		SELECT p.name
  			FROM (
    				SELECT name, ROW_NUMBER() OVER (ORDER BY name) as row_num
    					FROM players
  				)p
  			WHERE p.row_num % (SELECT COUNT(*) FROM players) = t.id % (SELECT COUNT(*) FROM players)
		);
		SET counter = counter + 1;
  	END WHILE;
    /*
	UPDATE sharetile
  	SET player_name = (SELECT name FROM players ORDER BY RAND() LIMIT 1) DIV 
  	WHERE player_name IS NULL;*/
 
END//
DELIMITER ;




/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
