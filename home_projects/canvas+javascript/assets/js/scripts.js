$(document).ready(function(){
  setup();
  $('#info').fadeIn();
});

$(window).resize(function(){
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
});

// VARIABLES
var canvas = null;
var context = null;
var framerate = 1000/30;
var current_frame = 0;

// INITIALIZATION
var setup = function(){
  canvas = document.getElementById('canvas');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  context = canvas.getContext('2d');

  gGameEngine.setup(canvas);

  setInterval(function(){
    gGameEngine.update();
    gGameEngine.draw();
  }, framerate); 
};