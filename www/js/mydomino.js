var me={token:null,id:null,username:null};
var game_status={status:null};
var board={};
var last_update=new Date().getTime();
var timer=null;



$(function(){

	drawBoard('board1');
	drawBoard('board2');
	//$('#gamelogin').click(login_to_game);
	$('#gamelogin').click( login_to_game);
	$('#playbutton').click(play_tile);
	
});




function drawBoard(canvasId) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');

    // Draw the board
    ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
    ctx.fillRect(50, 50, 300, 300);
  }

  function play_tile(tilename,playername){
	if($('#tile').val()=="" & $('#playername').val()==""){
		alert('You have to set a tile and player name');
			return;
	}
	$.ajax({url: "domino.php/play", 
					method: 'PUT',
					dataType: "json".stringify({tilename,playername}),
					contentType: 'application/json',
					data: JSON.stringify( {tile: $('#tile').val(),playername: $('#playername')}),
					success: game_status_update}
		
	);
  }


function login_to_game() {
	if($('#name').val()=='') {
		alert('You have to set a username');
		return;
	}
	
	$.ajax({url: "domino.php/players", 
			method: 'PUT',
			dataType: "json",
			contentType: 'application/json',
			data: JSON.stringify( {name: $('#name').val()}),
			success: login_result,
			error: result_error});
}

function result_error() {
	var x = data.responseJSON;
	alert(x.errormesg);
}

 function sharetiles(){
	$.ajax({url:"domino.php/stiles",
			method: 'PUT',
			headers:{"X-Token": me.token},
			success: gaet_Shared_tiles_by_player});
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
	$.ajax({url: "domino.php/status/", success: update_status,headers: {"X-Token": data.token} });
}

function gaet_Shared_tiles_by_player(){
	$.ajax({url:"domino.php/stiles/?",
		method: 'GET',
		headers:{"X-Token": me.token},
		success: showplayershand});
}

function showplayershand(data){
	$('#tabletiles  tr td').html("");
	for(var i=0;i<data.length;i++) {
		var o = data[i];
		var id = '#td_'+ o;
		//var im = '<img '+'" src="images/pieces/'+o.id+'.png">';
		//$(id).html(im);
	}

}


function check_aboart(){
	$.ajax({url:"domino.php/stiles/?",
		method: 'GET',
		headers:{"X-Token": me.token}
		//,success: update_status//
	});
}



function update_status(data){
	game_status=data[0];
	if((game_status.status=="initialized"||game_status.status==="started")){
		if(me[0].id==1){
			update_username1(me);
		}else if(me[0].id==2){
			update_username2(me);
		}
	}

	if( game_status.status==="started"){
		$('#player1wait').hide();
		$('#player2wait').hide();
		opponentUsername();
		sharetiles();
		check_aboart();
		if(game_status.p_turn==me.id && me.id!==null ){
			$('#play_div').show(1000);
			setTimeout(function(){game_status_update();}, 15000);
		}else{
			$('#play_div').hide(1000);
			setTimeout(function(){game_status_update();}, 15000);
		}
	
		if(game_status.stauts==ended && me.result=='win'){
			$('#player1wait').hide();
			$('#player2wait').hide();
			if(game_status.result=='win'){
				$('#player1-message').text("The winner is " + me.name[0]);
				$('#player2-message').text("The winner is " + me.name[0]);
			}
			setTimeout(()=>{alert('The game is over')},3500)
			clearTimeout(timer);
			me=[{token:null,id:null,username:null}];
			game_status={status:null,selected_piece:null,last_change:null};
			timer=null;
			setTimeout(reset_board, 35000);
			return;
				}
	
	
	
	
	}
		
	
	
}

function fill_board() {
	$.ajax({url: "domino.php/board/", 
		success: fill_board_by_data });
}

function fill_board_by_data(){
	for(var i=0; i<data.length; i++){

	}
}

function reset_board() {
	$.ajax({url: "domino.php/board/", 
	 method: 'POST'});
	window.location.hash="index";
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








