var Vec2 = Box2D.Common.Math.b2Vec2;
var BodyDef = Box2D.Dynamics.b2BodyDef;
var Body = Box2D.Dynamics.b2Body;
var FixtureDef = Box2D.Dynamics.b2FixtureDef;
var Fixture = Box2D.Dynamics.b2Fixture;
var World = Box2D.Dynamics.b2World;
var MassData = Box2D.Collision.Shapes.b2MassData;
var PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;
var CircleShape = Box2D.Collision.Shapes.b2CircleShape;
var DebugDraw = Box2D.Dynamics.b2DebugDraw;
var RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef;

var PhysicsEngine = function(){
  return {
    world: null,

    FRAMERATE: 1.0 / 30.0,
    PIXELS_PER_METER: 50,
  
    create: function(){
      this.world = new World(
        new Vec2(0, 0), // gravity vector
        false           // allow objects to sleep
      );
    },

    update: function(){
      var start = Date.now;

      this.world.Step(
        this.FRAMERATE, // framerate
        10,  // velocity iterations
        10   // position iterations
      );

      this.world.ClearForces();

      return (Date.now() - start);
    },

    registerBody: function(bodyDef){
      var body = this.world.CreateBody(bodyDef);
      return body;
    },

    addBody: function(entityDef){
      var bodyDef = new BodyDef();
      var id = entityDef.id;

      if(entityDef.type == 'static')
        bodyDef.type = Body.b2_staticBody;
      else
        bodyDef.type = Body.b2_dynamicBody;

      if (entityDef.damping) {
        bodyDef.linearDamping = entityDef.damping;
        bodyDef.angularDamping = entityDef.damping;
      }
 
      bodyDef.position.x = entityDef.x / this.PIXELS_PER_METER;
      bodyDef.position.y = entityDef.y / this.PIXELS_PER_METER;

      var body = this.registerBody(bodyDef);

      var fixtureDef = new FixtureDef();
      // if(entityDef.useBouncyFixture) {
      // fixtureDef.density = 1.0;
      // fixtureDef.friction = 1.0;
      // fixtureDef.restitution = 0.4;
      // }

      if (entityDef.radius){
        fixtureDef.shape = new CircleShape();
        fixtureDef.shape.m_radius = entityDef.radius / this.PIXELS_PER_METER;
      } else {
        fixtureDef.shape = new PolygonShape();
        entityDef.halfWidth /= this.PIXELS_PER_METER;
        entityDef.halfHeight /= this.PIXELS_PER_METER;
        fixtureDef.shape.SetAsBox( entityDef.halfWidth,  entityDef.halfHeight );
      }      

      body.CreateFixture(fixtureDef);
      return body;
    },

    removeBody: function (obj) {
      this.world.DestroyBody(obj);
    },

    toPixelPos: function(pos){
      return {
        x: Math.round(pos.x * this.PIXELS_PER_METER),
        y: Math.round(pos.y * this.PIXELS_PER_METER)
      };
    },

    toMeterPos: function(pos){
      return {
        x: pos.x / this.PIXELS_PER_METER,
        y: pos.y / this.PIXELS_PER_METER
      };
    }
  }
}

var gPhysicsEngine = new PhysicsEngine();