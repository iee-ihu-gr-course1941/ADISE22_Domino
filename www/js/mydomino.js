var me={token:null,id:null,username:null,lastactino:null};
var game_status={};
var board={};
var last_update=new Date().getTime();
var timer=null;



$(function(){
	$('#gamelogin').click(login_to_game);
});


function login_to_game() {
	if($('#name').val()=='') {
		alert('You have to set a username');
		return;
	}
//	var p_color = $('#pcolor').val();
//	draw_empty_board(p_color);
//	sharetiles();
	
	$.ajax({url: "domino.php/players/", 
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {username: $('#name').val()}),
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
	window.HTMLTableCaptionElement.
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


function playtile(){
	//if
}






