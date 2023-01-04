var me={token:null,id:null,username:null};
var game_status={};
//var board={};
var last_update=new Date().getTime();
var timer=null;



$(function(){

	drawBoard('board1');
	drawBoard('board2');
	//$('#gamelogin').click(login_to_game);
	$('#gamelogin').click( login_to_game);
	
});




function drawBoard(canvasId) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');

    // Draw the board
    ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
    ctx.fillRect(50, 50, 300, 300);
  }


function login_to_game() {
	if($('#name').val()=='') {
		alert('You have to set a username');
		return;
	}
	
	$.ajax({url: "api.php/players", 
			method: 'PUT',
			dataType: "json",
			contentType: 'application/json',
			data: JSON.stringify( {name: $('#name').val()}),
			success: login_result,
			error: login_error});
}

function filltiles(){
	$.ajax({url:"domino.php/tile",
			headers:{"X-Token": me.token},
			success: fill_tiles});
}


function showOpponentTiles(){

}

function login_result(data) {
	me = data;
	window.location.hash="play";
	game_status_update();
}

function login_error(data,y,z,c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}

function game_status_update() {
	
	clearTimeout(timer);
	$.ajax({url: "domino.php/status/", success: update_status,headers: {"X-Token": me.token} });
}

function update_username1(data){
	$('#player1').text(data[0].name);
}

function opponentUsername(){
	if(me[0].id===1){
		$.ajax({url: "domino.php/players/2", success: update_username2});
	}else if(me[0].id===2){
		$.ajax({url: "domino.php/players/1", success: update_username1});
	}
}

function update_username2(data){
	$('#player2').text(data[0].name);
}








