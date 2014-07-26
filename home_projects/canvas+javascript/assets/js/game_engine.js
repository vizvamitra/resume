var GameEngine = function(){
  return {

    canvas: null,
    context: null,

    move_dir: new Vec2(0,0),
    dirVec: new Vec2(0,0),

    inputEngine: new InputEngine(),

    map: new TILEDMap(),

    entities: [],
    entityFactory: {},
    _entitiesToRemove: [],

    player0: null,
    //   pos: {
    //     x: 100,
    //     y: 100
    //   },

    //   walkSpeed: 5

    //   //mpPhysBody: new BodyDef()
    // },

    setup: function (canvas) {
      this.canvas = canvas;
      this.context = this.canvas.getContext('2d');

      gPhysicsEngine.create();
      this.inputEngine.setup(this.canvas);

      this.map.setup(this.canvas, 'resources/map/grass_map_37x27_64.json');
      this.player0 = new Player();
      this.player0.init(0,0,{pos: {x: 352, y: 320}});

      var wheel = this.spawnEntity('Wheel');
      wheel.init(130, 130);
    },

    update: function () {
      this.updatePlayer();
      this.updateViewRect();
      this.updateEntities();

      gPhysicsEngine.update();
    },

    draw: function(){
      context.clearRect(0,0,canvas.width, canvas.height);

      this.map.draw(this.context);

      this.entities.sort( function(a,b){return (a.zindex - b.zindex);} );
      for (var i = 0; i < this.entities.length; i++){
        var ent = this.entities[i];
        if (this.isVisible(ent) && ent.zindex >= 0)
          ent.draw(this.map.viewRect);
      }

      this.player0.draw(this.map.viewRect);
    },

    spawnEntity: function(typename){
      var ent = new (this.entityFactory[typename])();
      this.entities.push(ent);

      return ent;
    },

    removeEntity: function(entToRemove){
      var index = this.entities.indexOf(entToRemove);
      this.entities.splice(index, 1);
    },

    updatePlayer: function(){
      this.updateMoveDir();
      this.updateDirVec();

      this.player0.update(this.move_dir);
    },

    updateViewRect: function(){
      this.map.centerAt(this.player0.pos.x, this.player0.pos.y);
    },

    updateEntities: function(){
      for (var i = 0; i < this.entities.length; i++){
        var ent = this.entities[i];
        if (!ent.killed) {
          ent.update();
        } else {
          this._entitiesToRemove.push(ent);
        }
      }

      for(var i = 0; i<this._entitiesToRemove.length; i++){
        this.removeEntity(this._entitiesToRemove[i]);
      }

      this._entitiesToRemove = [];
    },

    updateMoveDir: function(){
      this.move_dir = new Vec2(0,0);

      if (this.inputEngine.actions['move-up'])
        this.move_dir.y--;
      else if (this.inputEngine.actions['move-down'])
        this.move_dir.y++;

      if (this.inputEngine.actions['move-left'])
        this.move_dir.x--;
      else if (this.inputEngine.actions['move-right'])
        this.move_dir.x++;

      if (this.move_dir.Length()){
        this.move_dir.Normalize();
        this.move_dir.Multiply(this.player0.walkSpeed);
      }
    },

    updateDirVec: function(){
      this.dirVec = new Vec2(0,0);

      if (this.inputEngine.actions['fire0'] || this.inputEngine.actions['fire1']) {
        // var scrPos = gRenderEngine.getScreenPosition(this.player0.pos);

        // this.dirVec.x = this.inputEngine.mouse.x - scrPos.x;
        // this.dirVec.y = this.inputEngine.mouse.y - scrPos.y;
      } else {

        if (this.inputEngine.actions['fire-up'])
          this.dirVec.y--;
        else if (this.inputEngine.actions['fire-down'])
          this.dirVec.y++;

        if (this.inputEngine.actions['fire-left'])
          this.dirVec.x--;
        else if (this.inputEngine.actions['fire-right'])
          this.dirVec.x++;
      }

      if (this.dirVec.Length())
        this.dirVec.Normalize();
    },

    isVisible: function(ent){
      return (ent.pos.x >= -ent.size.x + this.map.viewRect.x) &&
            (ent.pos.x <= this.map.viewRect.x + this.canvas.width) + ent.size.x &&
            (ent.pos.y >= -ent.size.y + this.map.viewRect.y) &&
            (ent.pos.y <= this.map.viewRect.y + this.canvas.height) + ent.size.y;
    }
  }
}

var gGameEngine = new GameEngine();