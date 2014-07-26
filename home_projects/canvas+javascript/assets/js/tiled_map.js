var TILEDMap = function(){

  return {
    canvas: null,

    currMapData: null,
    tileSets: [],

    // Width and height of the map in tiles
    numXTiles: 100,
    numYTiles: 100,

    // Size of each tile in pixels
    tileSize: {
      "x": 64,
      "y": 64
    },

    // Size of the entire map in pixels
    pixelSize: {
      "x": 64,
      "y": 64
    },

    viewRect: {
      x: 0,
      y: 0
    },

    imgLoadCount: 0,
    fullyLoaded: false,

    walls: {},

    setup: function(canvas, map){
      this.canvas = canvas;
      this.load(map);
    },

    load: function(map){
      xhrGet(map, $.proxy(function(data){
        this.parseMapJSON(data.response);
      }, this));
    },

    parseMapJSON: function(mapJSON){
      this.currMapData = JSON.parse(mapJSON);
      map = this.currMapData;

      this.numXTiles = map.width;
      this.numYTiles = map.height;

      this.tileSize.x = map.tilewidth;
      this.tileSize.y = map.tileheight;

      this.pixelSize.x = this.numXTiles * this.tileSize.x;
      this.pixelSize.y = this.numYTiles * this.tileSize.y;

      // Loading tilesets
      for (var i in map.tilesets){
        var tileset = map.tilesets[i];

        var img = new Image();
        img.onload = function(){
          this.imgLoadCount += 1;
          if (this.imgLoadCount === map.tilesets.length) {
            this.fullyLoaded = true;
          }
        };
        img.src = "resources/map/tilesets/"+tileset.image.replace(/^.*[\\\/]/, '');

        var ts = {

          firstgid: tileset.firstgid, 

          image: img,
          imageheight: tileset.imageheight,
          imagewidth: tileset.imagewidth,
          name: tileset.name,

          numXTiles: Math.floor(tileset.imagewidth / tileset.tilewidth),
          numYTiles: Math.floor(tileset.imageheight / tileset.tileheight)

        }

        this.tileSets.push(ts);
      }

      this.fullyLoaded = true;
      
      this.setWalls();
    },

    setWalls: function(){
      this.createWall('left', 0, this.pixelSize.y/2, 0, this.pixelSize.y/2);
      this.createWall('right', this.pixelSize.x, this.pixelSize.y/2, 0, this.pixelSize.y/2);
      this.createWall('top', this.pixelSize.x/2, 0, this.pixelSize.x/2, 0);
      this.createWall('bottom', this.pixelSize.x/2, this.pixelSize.y, this.pixelSize.x/2, 0);
    },

    createWall: function(name, x, y, hW, hH){
      var entityDef = {
        id: 'map',
        type: 'static',
        x: x,
        y: y,
        halfWidth: hW,
        halfHeight: hH
      };

      this.walls[name] = gPhysicsEngine.addBody(entityDef);
    },

    getTilePacket: function(tileIndex){
      var pkt = {
        img: null,
        px: 0,
        py: 0
      }

      var i = 0;
      for (i = this.tileSets.length; i-->0;){
        if (this.tileSets[i].firstgid <= tileIndex) break;
      }
      var ts = this.tileSets[i];

      pkt.img = ts.image;

      var localid = tileIndex - ts.firstgid;
      var tileXPos = localid % ts.numXTiles;
      var tileYPos = Math.floor(localid / ts.numXTiles);

      pkt.px = tileXPos * this.tileSize.x;
      pkt.py = tileYPos * this.tileSize.y;
      
      return pkt;
    },

    draw: function(ctx){
      if (!this.fullyLoaded) return;

      for (var layerIdx=0; layerIdx<this.currMapData.layers.length; layerIdx++){
        var layer = this.currMapData.layers[layerIdx];
        if (layer.type !== 'tilelayer') continue;

        var data = layer.data
        for(var tileIdx=0; tileIdx<data.length; tileIdx++){
          var tID = data[tileIdx];
          if (tID === 0) continue;

          var tPKT = this.getTilePacket(tID);

          var worldX = Math.floor(tileIdx % this.numXTiles) * this.tileSize.x;
          var worldY = Math.floor(tileIdx / this.numXTiles) * this.tileSize.y;

          var screenX = worldX - this.viewRect.x;
          var screenY = worldY - this.viewRect.y;

          if (this._isTileVisible(worldX, worldY)) {
            ctx.drawImage( tPKT.img, tPKT.px, tPKT.py,
                  this.tileSize.x, this.tileSize.y,
                  screenX, screenY,
                  this.tileSize.x, this.tileSize.y);
          }
        }
      }
    },

    centerAt: function(x,y){
      this.viewRect.x = Math.round(x - (this.canvas.width / 2));
      this.viewRect.y = Math.round(y - (this.canvas.height / 2));
      this.viewRect.w = this.canvas.width;
      this.viewRect.h = this.canvas.height;

      var maxOffsetX = this.pixelSize.x - this.canvas.width;
      var maxOffsetY = this.pixelSize.y - this.canvas.height;
      if (this.viewRect.x >= maxOffsetX) this.viewRect.x = maxOffsetX;
      if (this.viewRect.y >= maxOffsetY) this.viewRect.y = maxOffsetY;
      if (this.viewRect.x <= 0) this.viewRect.x = 0;
      if (this.viewRect.y <= 0) this.viewRect.y = 0;
    },

    _isTileVisible: function(worldX, worldY){
      return (
        worldX > -this.tileSize.x + this.viewRect.x &&
        worldY > -this.tileSize.y + this.viewRect.y &&
        worldX < this.canvas.width + this.viewRect.x &&
        worldY < this.canvas.height  + this.viewRect.y
      );
    }

  }
};