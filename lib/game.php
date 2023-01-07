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

/*  function check_playtile ($tilename){
	global $mysqli;
	$sql='SELECT SUBSTRING_INDEX(?, '-', 1) INTO part1'
	$st=$mysqli->prepare($sql);
	$st->bind_param('s',$tilename);
	$st->execute();
	$res= $st->get_result();
	$res->fetch_assoc();
	$firstvalue=$res;

	$sql='SELECT SUBSTRING_INDEX(?, '-', -1) INTO part2'
	$st2=$mysqli->prepare($sql);
	$st2->bind_param('s',$tilename);
	$st2->execute();
	$res2= $st2->get_result();
	$res2->fetch_assoc();
	$secondvalue=$res2;

	$sql='SELECT SUBSTRING_INDEX(btile, '-', 1) FROM board WHERE bid = 1';
	$st3=$mysqli->prepare($sql);
	//$st3->bind_param('s',$tilename);
	$st3->execute();
	$res3= $st3->get_result();
	$res3->fetch_assoc();
	$oldfirstvalue=$res3;

	$sql='SELECT SUBSTRING_INDEX(btile, '-', -1) FROM board WHERE bid=1';
	$st4=$mysqli->prepare($sql);
	//$st4->bind_param('s',$tilename);
	$st4->execute();
	$res4= $st4->get_result();
	$res4->fetch_assoc();
	$oldsecondvalue=$res4;

	$sql='SELECT SUBSTRING_INDEX(btile, '-', 1) FROM board WHERE bid=2'
	$st5=$mysqli->prepare($sql);
	//$st3->bind_param('s',$tilename);
	$st5->execute();
	$res5= $st5->get_result();
	$res5->fetch_assoc();
	$oldfirstvaluesecboard=$res5;

	$sql='SELECT SUBSTRING_INDEX(btile, '-', -1) FROM board WHERE bid = 2'
	$st6=$mysqli->prepare($sql);
	//$st4->bind_param('s',$tilename);
	$st6->execute();
	$res6= $st6->get_result();
	$res6->fetch_assoc();
	$oldsecondvaluesecboard=$res6;
	if ($firstvalue==$oldfirstvalue){
		play_tile();
	} elseif($firstvalue==$oldsecondvalue){
		play_tile();
	}elseif ($firstvalue==$oldfirstvaluesecboard){
		play_tile();
	}elseif($firstvalue==$oldsecondvaluesecboard){
		play_tile();
	}elseif($secondvalue==$oldfirstvalue){
		play_tile();
	}elseif ($secondvalue==$oldsecondvalue){
		play_tile();
	}elseif($secondvalue==$oldfirstvaluesecboard){
		play_tile();
	}elseif($secondvalue==$oldsecondvaluesecboard){
		play_tile();
	}else{
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Tile does not match"]);
		
	}


} 
 */
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