<?php 
	require_once "../lib/board.php";
	require_once "../lib/players.php";
	require_once "../lib/dbconnection.php";


function play_tile($tilename,$player){
	global $mysqli;
	$sql = "CALL play_tile('$tilename','$player')";
	$st = $mysqli->prepare($sql);
	$st->execute();
	$st->bind_param('si',$tilename,$player);
	$res = $st->get_result();
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

/* function check_abort() {
	global $mysqli;
	
	$sql = "update gamestatus set status='aborded',result=if(p_turn='1','2','1'), p_turn=null where p_turn is not null and last_change<(now()-INTERVAL 10 MINUTE) and status='started'";
	$st = $mysqli->prepare($sql);
	$st->execute();
	
}  */

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

function setResult($id){
        /* global $mysqli;
        
        $p_turn=null;       
        $sql='update gameStatus set status="ended", result=?, p_turn=?';
        $st = $mysqli->prepare($sql);
        $st->bind_param('ss',$id,$p_turn);
        $st->execute() */;
    }

/*it needed check again for sure*/

?>