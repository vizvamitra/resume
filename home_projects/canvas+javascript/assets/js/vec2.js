var Vec2 = function(x,y){
  return {
    x: x,
    y: y,

    multiply: function(scalar){
      this.x *= scalar;
      this.y *= scalar;
    },

    normalize: function(){
      var vectorLength = this.length();
      if (vectorLength){
        this.x /= vectorLength;
        this.y /= vectorLength;
      }
    },

    length: function(){
      return Math.sqrt(this.x*this.x + this.y*this.y);
    }
  }
}