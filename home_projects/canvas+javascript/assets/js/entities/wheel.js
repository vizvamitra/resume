var Wheel = function(){

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

    init: function(x,y){
      var entityDef = {
        id: this.id,
        type: 'dynamic',
        x: x,
        y: y,
        radius: this.size.x/2,
        damping: 2
      };

      this.physBody = gPhysicsEngine.addBody(entityDef);
      this.physBody.SetLinearVelocity(new Vec2(0,0));

      this.pos = {x: x, y: y};
    },

    update: function(){
      if(this.physBody != null){
        this.pos = gPhysicsEngine.toPixelPos( this.physBody.GetPosition() );
      }

      this.currSpriteName = this.frameNames[this.currFrame];
      this.currFrame = (this.currFrame + 1) % this.frameNames.length;
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

gGameEngine.entityFactory['Wheel'] = Wheel;