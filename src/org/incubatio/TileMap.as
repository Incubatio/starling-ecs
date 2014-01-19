package org.incubatio {
  //Surface = require('surface')
  //Img = require('img')
  //Rect = require('rect')
  //SpriteSheet = require('spritesheet')
  //import starling.display.Image;
  import flash.geom.Rectangle;
	import starling.textures.Texture;
  import org.incubatio.SpriteSheet;

  public class TileMap {
    
    protected var _width:uint;

    protected var _height:uint;

    protected var _tileWidth:uint;

    protected var _tileHeight:uint;

    protected var _size:Array;

    protected var _tileSheet:SpriteSheet;

    protected var _collisionLayerName:String;

    protected var _layers:Object;

    
    /* @param Object data
     * @param Object options
     */
    public function TileMap(data:Object, options:Object = null) {
      options = options || {};
      this._width = data.width;
      this._height = data.height;

      this._tileWidth = data.tilewidth;
      this._tileHeight = data.tileheight;
      this._size = [this._width * this._tileWidth, this._height * this._tileHeight];
      
      if(data.tilesets) {
        this._tileSheet = new SpriteSheet();
        // by default tmx count image from 1
        this._tileSheet.setFirstgid(data.tilesets[0].firstgid);

        // Init tileset in the main tileSheet
        for each(var tileset:Object in data.tilesets) {
          // TODO: should not depend on assets, tileset.image should be an already loaded texture
          this._tileSheet.load(tileset.image, tileset.tilewidth, tileset.tileheight);
        }
      }


      // Init layers, names have to be unique
      if(data.layers) {
        // TODO: change options management 
        this._collisionLayerName = options.collisionLayerName || "collision";

        this._layers = {};
        for(var i:uint = 0; i < data.layers.length; i++) {
          this._layers[data.layers[i].name] = data.layers[i];
        }
      }
    }
      
    /* @param {interger} gid
     * @return {array} */ 
    public function gid2pos(gid:uint):Array {
      var getX:Function = function(i:uint, width:uint):uint { return (i % width == 0) ? width - 1 : (i % width) - 1; }

      var x:uint = (gid == 0) ? 0 : getX(gid + 1, this._width);
      var y:uint = Math.floor(gid / this._width);

      return [x * this._tileWidth, y * this._tileHeight];
    }

    /*
    * @param {integer} gid
    * @return {Rect}
    */
    //public function gid2rect(gid): ->
    //  return new gamecs.Rect(this.gid2pos(gid), [this._tileWidth, this._tileHeight])

    /*
    * @param uint x
    * @param uint y
    * @return uint
    */
    public function pos2gid(x:uint, y:uint):uint {
      var x:uint = Math.floor(x / this._tileWidth);
      var y:uint = Math.floor(y / this._tileHeight);
      return (y * this._width) + x; //+ 1;
    }


    /*
    * @param uint gid
    * @return Texture
    */
    public function getTile(gid:uint):Texture {
      return this._tileSheet.get(gid - this._tileSheet.getFirstgid());
    }

    /*
    * @param uint x
    * @param uint y
    * @return Boolean
    */
    public function isOutOfBounds(x:uint, y:uint):Boolean {
      return x <= 0 || x >= this._size[0] || y <= 0 || y >= this._size[1];
    }

    /*
    * For collision layer
    *
    * @param uint x
    * @param uint y
    * @return Boolean
    */
    protected function _isColliding(x:uint, y:uint, collisionLayerName:String):Boolean {
      if(!collisionLayerName) { var collisionLayerName:String = this._collisionLayerName;}
      return this.isOutOfBounds(x, y) || !!this._layers[this._collisionLayerName].data[this.pos2gid(x, y)];
    }

    /*
    * @param Rect
    * @return Boolean
    */
    // TODO: there is a bug here when sprite is bigger than tile, (collision is actually detected by matchin sprite corners to tiles)
    /*
    public function isColliding(rect):Boolean {
      return  this._isColliding(rect.left, rect.top) ||
        this._isColliding(rect.left + rect.width, rect.top) ||
        this._isColliding(rect.left, rect.top + rect.height) ||
        this._isColliding(rect.left + rect.width, rect.top + rect.height)
    }
    */

    /*
    * For Sprite layer, return each tile as object: {pos: [x, y], card: [a, b], gid: i, image: "path/to/image"}
    *
    * @return Array
    */
    public function getTiles():Array {
      var result:Array = [];
      //for i in [this._tileSheet.firstgid...(this.visibleLayers['boxes'].length - this._tileSheet.firstgid)]
      //  if(this.visibleLayers['boxes'][i])
      //    result.push(this.gid2pos(i))
      return result;
    }

    /*
    * Prepare a grid of visible images for visible Layers
    */
    public function prepareLayers():void {
      // TOTHINK: managing layer by layer level would more dynamics and less trivial than using names.
      // TODO: store int array of layer key in visibleLayers
      for(var key:String in this._layers) {
        var layer:Object = this._layers[key];
        if(layer.properties == undefined || layer.properties.visible != false) {

          // TODO: change to flash code
          //var surface = new Surface(this._size[0], this._size[1])
          var surface:Rectangle = new Rectangle(0, 0, this._size[0], this._size[1]);

          // TODO: think about the best manner to set opacity
          //this.surface.setAlpha(layer.opacity)

          //extract images from a frameset
          for(var y:uint = 0; y < this._height; y++) {
            for(var x:uint = 0; x < this._width; x++) {
              // TODO: change to flash code
              //rect = new Rect(x * this._tileWidth, y * this._tileHeight, this._tileWidth, this._tileHeight)
              var rect:Rectangle = new Rectangle(x * this._tileWidth, y * this._tileHeight, this._tileWidth, this._tileHeight);

              var gid:uint = layer.data[(y * this._width) + x]; // + 1]
              //gid = this._tileSheet.get((y * this._width) + x) // + 1]
              if(gid != 0) {
                if(gid) {
                  var texture:Texture = this.getTile(gid);
                  Texture.fromTexture(texture, rect, surface);
                    //surface.blit(image, rect);
                } else trace("bug", x, y, gid);
              }
            }
          }
          this._layers[key].image = surface;
        }
      }
    }
  }
}
