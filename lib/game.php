<?php 
	require_once "../lib/board.php";
	require_once "../lib/players.php";
	require_once "../lib/dbconnection.php";


function play_tile($tilename,$player){
	global $mysqli;
	$sql ="CALL play_tile(?,?)";
	$st = $mysqli->prepare($sql);
	$st->bind_param('ss',$tilename,$player);
	$st->execute();
	$res = $st->get_result();  
	checkResult();

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


function drawtile($b){
/* 
	if(!isset($input['name']) || $input['name']=='') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"no name given"]);
		exit;
	}
	$username=$input['name']; */
	$username=$b;
	global $mysqli;
	$sql='call draw_tile(?)';
	$st=$mysqli->prepare($sql);
	$st->bind_param('s',$username);
	$st->execute();
	$res= $st->get_result();
	//header('Content-type: application/json');
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

function checkResult(){
	 	global $mysqli; 
		$sql='select count(DISTINCT player_name) as c from sharetile';
		$st = $mysqli->prepare($sql);
		$st->execute() ;
		$res= $st->get_result();
		if(['c']==1){
			$sql="call check_result('')";
        	$st = $mysqli->prepare($sql);
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