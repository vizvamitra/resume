var Player = function(){

  var obj = {

    pos: {x: 0, y: 0},

    size: { x: 48, y: 48 },

    frameNames: [
      'wheel_01.png',
      'wheel_02.png',
      'wheel_03.png',
      'wheel_04.png',
      'wheel_05.png',
      'wheel_06.png'
    ],
    currFrame: 0,

    walkSpeed: 10,

    init: function(x,y,settings){
      // var parent = $.proxy(this.__proto__.init, this);
      // parent(x,y,settings);

      var startPos = settings.pos;

      var entityDef = {
        id: this.id,
        type: 'dynamic',
        x: startPos.x,
        y: startPos.y,
        halfWidth: this.size.x/2,
        halfHeight: this.size.y/2
      };

      this.physBody = gPhysicsEngine.addBody(entityDef);
      this.physBody.SetLinearVelocity(new Vec2(0,0));

      this.pos = startPos;
    },

    update: function(moveDir, mapSize){
      this.updatePosition(moveDir);

      this.currSpriteName = this.frameNames[this.currFrame];
      this.currFrame = (this.currFrame + 1) % this.frameNames.length;
      //gGameEngine.removeEntity(this);
    },

    updatePosition: function(moveDir){
      if(this.physBody != null){
        this.physBody.SetLinearVelocity( moveDir );
        this.pos = gPhysicsEngine.toPixelPos( this.physBody.GetPosition() );
      }
    },
  };

  obj.__proto__ = new Entity();

  // loading spritesheet
  loadSpriteSheet(
    'resources/objects/spritesheets/wheel/wheel_64x64.png',
    'resources/objects/spritesheets/wheel/wheel_64x64.json'
  );

  return obj;
}

gGameEngine.entityFactory['Player'] = Player;