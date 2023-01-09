var me={token:null,id:null,name:null};
var game_status={status:null};
var tile={tile:null};
var board={};
var last_update=new Date().getTime();
var timer=null;



$(function () {
	$('#gamelogin').click(login_to_game);
	$('#playbutton').click(play_tile);
	$('#drawbutton').click(draw_tile);
	$('#exit').click(exitgame);
	//game_status_update();


});

function exitgame(){
	window.location="#index";
}


function play_tile(){
	if($('#tile').val()=="" & $('#playername').val()==""){
		alert('You have to set a tile and player name');
			return;
	}
	$.ajax({url: "domino.php/play/", 
					method: 'PUT',
					dataType: "json",
					contentType: 'application/json',
					data: JSON.stringify( {tile: $('#tile').val(),name: $('#playername')}),
					success: playresult()}
		
	);
  }


  function playresult(){
	game_status_update();
	fill_board();
  }


function login_to_game() {
	if($('#username').val()=='') {
		alert('You have to set a username');
		return;
	}
		$.ajax({url:"domino.php/players/",
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {name: $('#username').val()}),
			success: login_result,
			error: result_error});
	}

	


	function result_error(data) {
		var x = data.responseJSON;
	alert(x.errormesg);
	}

 function sharetiles(){
	$.ajax({url:"domino.php/stiles",
			method: 'PUT',
			headers:{"X-Token": me.token},
			success: get_Shared_tiles_by_player});
} 


function login_result(data) {
	me = data;
	window.location="#play.html";
	game_status_update();
	
}


function game_status_update() {
	clearTimeout(timer);
	$.ajax({url: "domino.php/status/", success: update_status,headers: {"X-Token": me.token} });
}

function get_Shared_tiles_by_player(){
	$.ajax({url:"domino.php/stiles/?",
		method: 'GET',
		headers:{"X-Token": me.token},
		success: showplayershand});
}

function draw_tile(){
	$.ajax({url:"domino.php/draw/",
	method: 'PUT',
	headers:{"X-Token": me.username},
	success: get_Shared_tiles_by_player});
}

function showplayershand(data){
	$('#tabletiles  tr td').html("");
	for(var i=0;i<7;i++) {
		var o = data[i];
		var id = '#td_'+ o;
		//var im = '<img '+'" src="images/pieces/'+o.id+'.png">';
		//$(id).html(im);
	}

}


function check_aboart(){
	$.ajax({url:"domino.php/abort/",
		method: 'GET'
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

	if( game_status.status=="started"){
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
			$('#watingplayer').hide();
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
	if(game_status.status=='aboard'){
		setTimeout(()=>{alert('The game is over')},3500)
		clearTimeout(timer);
		me=[{token:null,id:null,username:null}];
		game_status={status:null,selected_piece:null,last_change:null};
		timer=null;
		setTimeout(reset_board, 3500);
		return;
			}
	
	
	
	
	}
		
	
	
}

function fill_board() {
	$.ajax({url: "domino.php/board/", 
		success: fill_board_by_data });
}

function fill_board_by_data(data){
	$('#board').html("");
	for(var i=0;i<length;i++) {
		var o = data[i];
		var id = '#board_'+ o;
		//var im = '<img '+'" src="images/pieces/'+o.id+'.png">';
		//$(id).html(im);
	}
}

function reset_board() {
	$.ajax({url: "domino.php/board/", 
	 method: 'POST'});
	window.location.hash="index";
}

	


function update_username1(data){
	$('#player1l').text(data[0].name);
}

function opponentUsername(){
	if(me[0].id===1){
		$.ajax({url: "domino.php/players/2", success: update_username2});
	}else if(me[0].id===2){
		$.ajax({url: "domino.php/players/1", success: update_username1});
	}
}

function update_username2(data){
	$('#player2l').text(data[0].name);
}



/* function drawBoard(canvasId) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');

    // Draw the board
    ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
    ctx.fillRect(50, 50, 300, 300);
  } */





