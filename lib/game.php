<?php 
	require_once "../lib/board.php";
	require_once "../lib/players.php";
	require_once "../lib/dbconnection.php";


function play_tile($tilename,$player){
	global $mysqli;
	$sql = 'select count(*) as c from sharetile where tile_name=?';
	$st1 = $mysqli->prepare($sql);
	$st1->bind_param('s',$tilename);
	$st1->execute();
	$res2 = $st1->get_result();
	$tilehand = $res2 -> fetch_assoc();
	if ($tilehand['c']==0){
		$sql = "call play_tile(?,?)";
		$st = $mysqli->prepare($sql);
		$st->bind_param('si', $tilename, $player);
		$st->execute();
		$res = $st->get_result();
	}else{
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Tile does not exist in sharetile table"]);
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

function show_status(){
	
	global $mysqli;
	//check_abort();
	$sql = 'select * from gamestatus';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);

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


function read_status(){
	global $mysqli;
	$sql = 'select * from gamestatus';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_assoc();
	return ($status);
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
		}

        
    }
/* function check_abort() {
	global $mysqli;
	
	$sql = "update gamestatus set status='aborded',result=if(p_turn='1','2','1'), p_turn=null where p_turn is not null and last_change<(now()-INTERVAL 10 MINUTE) and status='started'";
	$st = $mysqli->prepare($sql);
	$st->execute();
	
}  */
/*it needed check again for sure*/

?>