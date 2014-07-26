var Entity = function(){
  return {
    _id: Math.random().toString(36).substring(7),
    pos: {x: 0, y: 0},
    size: {x: 0, y: 0},
    killed: false,
    zindex: 0,

    physBody: null,

    currSpriteName: null,

    draw: function(viewRect){
      if(this.currSpriteName){
        drawSprite(this.currSpriteName,
              Math.round(this.pos.x) - viewRect.x,
              Math.round(this.pos.y) - viewRect.y
        );
      }
    },
    
    init: function(){},
    update: function(){}
  };
}