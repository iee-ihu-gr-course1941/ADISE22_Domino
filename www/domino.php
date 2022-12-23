<?php 
require_once "../lib/dbconnection.php";
require_once "../lib/board.php";
require_once "../lib/game.php";
require_once "../lib/players.php";


$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
$request_path = trim($_SERVER['PATH_INFO'],'/');
$input = json_decode(file_get_contents('php://input'),true);
if($input==null) {
    $input=[];
}
if(isset($_SERVER['HTTP_X_TOKEN'])) {
    $input['token']=$_SERVER['HTTP_X_TOKEN'];
} else {
    $input['token']='';
}

function handle_status($method) {
    if($method=='GET') {
        show_status();
    } else {
        header('HTTP/1.1 405 Method Not Allowed');
    }
}


?>  