<?php 
require_once "../lib/game.php";
require_once "../lib/board.php";
require_once "../lib/dbconnection.php";


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
	$sql = 'select name from players where id=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$b);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function set_user($input) {
	global $mysqli;
	
    if(!isset($input['name']) || $input['name']=='') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"No username given."]);
		exit;
	}
	$username=$input['name'];
	// Check if username already exists
	$sql = 'SELECT COUNT(*) AS c FROM players WHERE name=?';
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param('s', $username);
	$stmt->execute();
	$res = $stmt->get_result();
	$row = $res->fetch_assoc();
	if($row['c'] > 0) {
    	header("HTTP/1.1 400 Bad Request");
    	print json_encode(['errormesg'=>"This username already exists."]);
    	exit;
	}

// Check if there are already 2 players
	$sql = 'SELECT COUNT(*) AS c FROM players';
	$stmt = $mysqli->prepare($sql);
	$stmt->execute();
	$res = $stmt->get_result();
	$row = $res->fetch_assoc();
	if($row['c'] >= 2) {
    	header("HTTP/1.1 400 Bad Request");
    	print json_encode(['errormesg'=>"To many players.Please come later"]);
    	exit;}
// Insert new player
	$sql = 'INSERT INTO players (name, token) VALUES (?, md5(CONCAT(?, NOW())))';
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param('ss', $username, $username);
	$stmt->execute();

	update_gameStatus();
}
function show_sharedtiles(){
	global $mysqli;
	$sql = 'select * from sharetile';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function show_players_sharedtiles($b){
	global $mysqli;
	$sql = 'select * from sharetile where player_name=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('s',$b);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
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




//check_abort();
	 
	/*$status = read_status();
	if($status['status']=='started') {
		header("HTTP/1.1 400 Bad Request");
		print json_encode(['errormesg'=>"Game is in action."]);
		exit;
	}
	if($status['status']=='aborded'||$status['status']=='ended'){
		$sql = 'call cleanboard()';
	    $mysqli->query($sql);
	} */
	
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



/*
function handle_user($method, $b,$input) {
	if($method=='GET') {
		show_user($b);
	} else if($method=='PUT') {
        set_user($b,$input);
    }
}
*/
//update_game_status();
	//$sql = 'select * from players where id=?';
	//$st = $mysqli->prepare($sql);
	//$st->bind_param('i',$id);
	//$st->execute();
	//$res = $st->get_result();
	//header('Content-type: application/json');
	//print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT); 
?>