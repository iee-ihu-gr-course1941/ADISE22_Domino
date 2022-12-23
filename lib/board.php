<?php



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

<?>