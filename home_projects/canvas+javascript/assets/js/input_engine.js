var InputEngine = function(){

  return {
    _canvas: null,

    // mapping keycodes to action names
    bindings: {},

    // mapping action names to boolean switches
    actions: {},

    mouse: {
      x: 0,
      y: 0
    },

    setup: function(canvas){
      this._canvas = canvas;

      this.bind(87, 'move-up'); // w
      this.bind(65, 'move-left'); // a
      this.bind(83, 'move-down'); // s
      this.bind(68, 'move-right'); // d

      this.bind(38, 'fire-up'); // up
      this.bind(37, 'fire-left'); // left
      this.bind(40, 'fire-down'); // down
      this.bind(39, 'fire-right'); // right

      this._canvas.addEventListener('mousemove', $.proxy(this.onMouseMove, this));
      this._canvas.addEventListener('click', $.proxy(this.onClick, this));
      this._canvas.addEventListener('contextmenu', $.proxy(this.onClick, this));

      window.addEventListener('keydown', $.proxy(this.onKeyDown, this));
      window.addEventListener('keyup', $.proxy(this.onKeyUp, this));
    },

    onMouseMove: function(event){
      event.preventDefault(); // prevent text-selection cursor

      this.mouse.x = event.clientX;
      this.mouse.y = event.clientY;
    },

    onClick: function(event){
      event.preventDefault(); // prevent context menu

      console.log("click, button: " + event.which + ", x: " + event.clientX + ", y: " + event.clientY);
      return false;
    },

    onKeyDown: function(event){
      this._setAction(event.keyCode, true);
      console.log("keydown, ID: " + event.keyCode);
    },

    onKeyUp: function(event){
      this._setAction(event.keyCode, false);      
      console.log("keyup, ID: " + event.keyCode);
    },

    bind: function(key, action){
      this.bindings[key] = action;
    },

    update: function(){
      
    },

    _setAction: function(code, value) {
      var action = this.bindings[code];
      if (action)
        this.actions[action] = value;
    }
  }

}