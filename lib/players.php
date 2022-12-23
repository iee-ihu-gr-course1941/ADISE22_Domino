<?php 

function show_users() {
	global $mysqli;
	$sql = 'select name from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function show_user($b) {
	global $mysqli;
	$sql = 'select name from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$b);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}



function set_user($b,$input) {
	//print_r($input);
	if(!isset($input['name']) || $input['name']=='') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"No name given."]);
		exit;
	}
	$name=$input['name'];
	global $mysqli;
	$sql = 'select count(*) as c from players where id=? and name is not null';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$b);
	$st->execute();
	$res = $st->get_result();
	$r = $res->fetch_all(MYSQLI_ASSOC);
	if($r[0]['c']>0) {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Player $b is already set. Please select another color."]);
		exit;
	}
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
	
	
}
?>