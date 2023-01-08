<?php
require_once "../lib/game.php";
require_once "../lib/players.php";
require_once "../lib/dbconnection.php";

/*its not completed for susre*/

function reset_board() {
	global $mysqli;
	$sql = 'call cleanboard()';
	$mysqli->query($sql);
}

function show_board(){
	global $mysqli;
	$sql = 'select * from board';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}



function check_abort() {
	global $mysqli;
	$sql = "CALL check_aboard()";
	$st = $mysqli->prepare($sql);
	$st->execute();
	
}  






/*
function show_tiles($x,$y) {
	global $mysqli;
	
	$sql = 'select * from tile where firstvalue=? and secondvalue=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('tile',$x,$y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}
*/
/*
function fill_board($x,$y){
	global $mysqli;

	$sql='call play_tile('?','?')';
	$st= $mysqli->prepare($sq1);
	$st->bind_paradam($x,$y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);


}

function read_status()
{
	global $mysqli;
	$sql = 'select * from gameStatus';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_assoc();
	return ($status);
}
*/


?>


