<?php 
	require_once "../lib/board.php";
	require_once "../lib/players.php";
	require_once "../lib/dbconnection.php";


function play_tile($tilename,$player){
	global $mysqli;
	//$sql = 'select count(*) as c from sharetile where tile_name=? and p_name=?';
	//$st1 = $mysqli->prepare($sql);
	//$st1->bind_param('ss',$tilename,$player);
	//$st1->execute();
	//$res2 = $st1->get_result();
	//$tilehand = $res2 -> fetch_assoc();
	//if ($tilehand['c']==1){
		$sql = "call play_tile(?,?)";
		$st1 = $mysqli->prepare($sql);
		$st1->bind_param('ss',$tilename,$player);
		$st1->execute();
		$res = $st1->get_result();
	//}else{
	//	header("HTTP/1.1 400 Bad Request");
		//print json_encode(['errormesg'=>"Tile does not exist in sharetile table"]);
		//}
}

function check_playtile ($tilename,$player){
	// Split the given tile into its two values
    $sql = "SELECT SUBSTRING_INDEX(?, '-', 1) AS part1, SUBSTRING_INDEX(?, '-', -1) AS part2";
    $st = $mysqli->prepare($sql);
    $st->bind_param('ss', $tilename, $tilename);
    $st->execute();
    $res = $st->get_result();
    $tile = $res->fetch_assoc();
    $firstvalue = $tile['part1'];
    $secondvalue = $tile['part2'];

// Get the tile values on the second board
	$sql = "SELECT SUBSTRING_INDEX(btile, '-', 1) AS part1, SUBSTRING_INDEX(btile, '-', -1) AS part2 FROM board WHERE bid = ?";
	$st = $mysqli->prepare($sql);
	$st->bind_param('i', 2);
	$st->execute();
	$res = $st->get_result();
	$board2tile = $res->fetch_assoc();
	$oldfirstvaluesecboard = $board2tile['part1'];
	$oldsecondvaluesecboard = $board2tile['part2'];

// Get the tile values on the second board
	$sql = "SELECT SUBSTRING_INDEX(btile, '-', 1) AS part1, SUBSTRING_INDEX(btile, '-', -1) AS part2 FROM board WHERE bid = ?";
	$st = $mysqli->prepare($sql);
	$st->bind_param('i', 2);
	$st->execute();
	$res = $st->get_result();
	$board2tile = $res->fetch_assoc();
	$oldfirstvaluesecboard = $board2tile['part1'];
	$oldsecondvaluesecboard = $board2tile['part2'];
	
	if ($firstvalue==$oldfirstvalue){
		
		play_tile($tilename,$player);
	
	} elseif($firstvalue==$oldsecondvalue){
		
		play_tile($tilename,$player);
	
	}elseif ($firstvalue==$oldfirstvaluesecboard){
		
		play_tile($tilename,$player);
	
	}elseif($firstvalue==$oldsecondvaluesecboard){
		
		play_tile($tilename,$player);
	
	}elseif($secondvalue==$oldfirstvalue){
		
		play_tile($tilename,$player);
	
	}elseif ($secondvalue==$oldsecondvalue){
		
		play_tile($tilename,$player);
	
	}elseif($secondvalue==$oldfirstvaluesecboard){
		
		play_tile($tilename,$player);
	
	}elseif($secondvalue==$oldsecondvaluesecboard){
		
		play_tile($tilename,$player);
	
	}else{
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Tile does not match"]);
		
	}


}  

function sharetiles(){
	global $mysqli;
	$sql = 'call update_sharetile';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	//print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}


function drawtile($player){
	global $mysqli;
	$sql='call draw_tile(?)'
	$st=$mysqli->prepare($sql);
	$st->bind_param('s',$player);
	$st->execute();
	$res= $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function show_status(){
	
	global $mysqli;
	//check_abort();
	$sql = 'select * from gamestatus';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
	check_abort();

}

function update_gameStatus() {
	global $mysqli;

	$sql = 'select count(*) as c from players';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_all(MYSQLI_ASSOC);
	if ($status[0]['c']==0) {
		$sql = 'insert into gamestatus(id) VALUES(1)';
		$st2 = $mysqli->prepare($sql);
		$r= $st2->execute();
		exit;
	  } elseif ($status[0]['c']==1) {
		$sql = 'insert into gamestatus(id) VALUES(1)';
		$st2 = $mysqli->prepare($sql);
		$r= $st2->execute();
		exit;
	  } else {
		$sql ="update gamestatus SET status='started', p_turn='1'";
		$st = $mysqli->prepare($sql);
		$r = $st->execute();
	  }
		
}

function checkResult($player){
	 	global $mysqli; 
		$sql='select count(DISTINCT player_name) as c from sharetile';
		$st = $mysqli->prepare($sql);
		$st->execute() ;
		$res= $st->get_result();
		if(['c']==1){
			$sql="call check_result('?')";
        	$st = $mysqli->prepare($sql);
        	$st->bind_param('s',$player);
        	$st->execute() ;

			$sql='select name from players where result="win" ';
        	$st1 = $mysqli->prepare($sql);
        	//$st1->bind_param('s',$player);
        	$st1->execute() ;
			header('Content-type: application/json');
			print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
			//return($player);
			
			reset_board();
			
		}

        
    }

/*it needed check again for sure*/

?>