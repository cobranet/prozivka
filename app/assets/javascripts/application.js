// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require faye
//= require_tree .

MP = {};



MP.user_id = function (){
    return $("#maindata").data("userid");
}

MP.game_id = function(){ 
    return $('#gamedata').data("gameid");
}

MP.onmove = function(){ 
    return $('#gamedata').data("onmove");
}




MP.on_message = function(message) {
    if (message["action"] == "newspeech") {
	$('#speech').load('/games/' + MP.game_id() + '/last_five',
			  function() {
			      MP.set_on_move(message["onmove"])
			  });
	$('#action').load('/games/' + MP.game_id() + '/actions',
			  function() {
			       MP.set_speech_button();   
			     });
    }
}

MP.set_on_move = function(onmove){
    $('#gamedata').data("onmove",onmove);
}


MP.game_suscribe = function(){
  if (MP.game_id()){
      	MP.client.subscribe('/allplayers'+MP.game_id(),function(message) {
	    MP.on_message(message);
	});
  }
}

MP.set_speech_button = function() {    
    $('#nsbutton').on('click', function(){
	$.ajax({
	    type: "POST",
	    url: "/games/" + MP.game_id() + "/make_speech",
	    data: { 
		speech: $('#new_speech').val()
	    }
	});
    });
}

$().ready(function(){
    MP.client = new Faye.Client('/faye');
    MP.game_suscribe();
    MP.client.subscribe('/chat' + MP.user_id(), function(message) {
	MP.on_message(message);
    });
    MP.set_speech_button();
});
