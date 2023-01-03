<?php 
require_once "../lib/game.php";
require_once "../lib/board.php";

function show_users() {
	global $mysqli;
	$sql = 'select name,id from players';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function show_user($b) {
	global $mysqli;
	$sql = 'select name,id from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$b);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function set_user($b,$input) {
	//print_r($input);
	$id=0;
	global $mysqli;
	if(!isset($input['name']) || $input['name']=='') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"No name given."]);
		exit;
	}
	check_abort(); //from game.php

	$status = read_status(); //from board.php
	if($status['status']=='started') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Game is in action."]);
		exit;
	}

	if($status['status']=='aborded'||$status['status']=='ended'){
		$sql = 'call clean_board()';
	    $mysqli->query($sql);
	}

	
	$name=$input['name'];
	$sql = 'select count(*) as c from players where name=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$name);
	$st->execute();
	$res = $st->get_result();
	$r = $res->fetch_all(MYSQLI_ASSOC);


	if($r[0]['c']>0) {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Player $name is already taken."]);
		exit;
	}
	

	$sql = 'select count(*) as c from players where id=1 and name is not null';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$r = $res->fetch_all(MYSQLI_ASSOC);

	if($r[0]['c']>0) {
      //  $id='2';
        $sql = 'update players set name=?, token=md5(CONCAT( ?, NOW()))  where id=?';
	    $st2 = $mysqli->prepare($sql);
	    $st2->bind_param('ssi',$name,$name,$id);
	    $st2->execute();
	}else{
       // $id='1';
        $sql = 'update players set username=?, token=md5(CONCAT( ?, NOW()))  where id=?';
	    $st2 = $mysqli->prepare($sql);
	    $st2->bind_param('ssi',$name,$name,$id);
	    $st2->execute();
    }
	
	update_game_status(); // from game.php
	$sql = 'select * from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('i',$id);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
	
	/*
	$sql = 'update players set name=?, token=md5(CONCAT( ?, NOW()))  where id=?';
	$st2 = $mysqli->prepare($sql);
	$st2->bind_param('sss',$name,$name,$b);
	$st2->execute();
	update_game_status();
	$sql = 'select * from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$b);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
	*/ 
}

function current_player($token) {
	
	global $mysqli;
	if($token==null) {return(null);}
	$sql = 'select * from players where token=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$token);
	$st->execute();
	$res = $st->get_result();
	if($row=$res->fetch_assoc()) {
		return($row['id']);
	}
	return(null);
}


//Σχεδον τελος με τους Players just checking 

/*
function handle_user($method, $b,$input) {
	if($method=='GET') {
		show_user($b);
	} else if($method=='PUT') {
        set_user($b,$input);
    }
}
*/
?>