var gSpriteSheets = {};

var SpriteSheet = function(){

  return {

    img: null,
    url: "",
    sprites: new Array(),
    infoLoaded: false,

    loadEvent: {
      type: "spritesheetLoad",
      spritesheet: null,
      bubbles: false,
      cancelable: true
    },

    init: function () {},

    load: function (imgName) {
      this.url = imgName;
          
      var img = new Image();
      img.src = imgName;
      this.img = img;

      gSpriteSheets[imgName] = this;
    },

    defSprite: function(name, x, y, w, h, cx, cy){
      var sprite = {
        id: name,
        x: x,
        y: y,
        w: w,
        h: h,
        cx: cx,
        cy: cy
      };

      this.sprites.push(sprite);
    },

    getStats: function(name){
      for (var i=0; i<this.sprites.length; i++){
        if (this.sprites[i].id === name) return this.sprites[i];
      }
      return null;
    },

    parseSpritesJSON: function(atlasJSON){
      var parsed = JSON.parse(atlasJSON);
            
      for(key in parsed.frames){
        var sprite = parsed.frames[key];

        // Define center of the sprite
        cx = -sprite.frame.w * 0.5;
        cy = -sprite.frame.h * 0.5;

        // Deal with trimmed sprites
        if (sprite.trimmed){
          cx = sprite.spriteSourceSize.x - sprite.sourceSize.w*0.5;
          cy = sprite.spriteSourceSize.y - sprite.sourceSize.h*0.5;
        }

        // Define the sprite for this sheet
        this.defSprite(
          key,
          sprite.frame.x,
          sprite.frame.y,
          sprite.frame.w,
          sprite.frame.h,
          cx,
          cy
        );
      }

      this.onLoad();
    },

    frames: function(){
      return this.sprites.map(function(sprite){
        return sprite.id;
      });
    },

    onLoad: function(){
      this.loadEvent.spritesheet = this;
      $(this).trigger(this.loadEvent);
      this.infoLoaded = true;
    }
    
  }

};

function loadSpriteSheet(image_uri, data_uri, callback){
  if (gSpriteSheets[image_uri]){ // spritesheet already created
    var spritesheet = gSpriteSheets[image_uri];

    if (callback){
      $(spritesheet).on("spritesheetLoad", callback);
      if(spritesheet.infoLoaded)
        $(spritesheet).trigger(spritesheet.loadEvent);
    }
  } else {
    var spritesheet = new SpriteSheet();

    if (callback)
      $(spritesheet).on("spritesheetLoad", callback);

    spritesheet.load(image_uri);
    xhrGet(data_uri, function(xhr){
      spritesheet.parseSpritesJSON(xhr.responseText);
    });
  }

  return spritesheet;
}

function drawSprite(spritename, posX, posY) {
  for (sheetName in gSpriteSheets){
    var sheet = gSpriteSheets[sheetName];
    var sprite = sheet.getStats(spritename);
    if(sprite == null) continue;

    __drawSpriteInternal(sprite, sheet, posX, posY);

    return;
  }
}

function __drawSpriteInternal(spt, sheet, posX, posY) {
  if (spt == null || sheet == null) return;

  var hlf = {
    x: spt.cx,
    y: spt.cy
  };

  context.drawImage(sheet.img,
                  spt.x, spt.y, spt.w, spt.h,
                  posX+hlf.x, posY+hlf.y,
                  spt.w, spt.h);
}