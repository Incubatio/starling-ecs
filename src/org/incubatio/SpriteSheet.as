package org.incubatio {
  import flash.geom.Rectangle;
  import flash.utils.Dictionary;
  import starling.textures.Texture;

  public class SpriteSheet {

    protected var _textures:Vector.<Texture>;
    protected var _firstgid:uint = 0;
    
    public function SpriteSheet() {
      this._textures = new <Texture>[];
    }

    // sheet is an instance of gamecs.image
    public function get(id:Number):Texture {
       return this._textures[id]
    }

    // sheet is a Texture that contains multiple frame
    // Note: You can use load() several times, new Textures will be stacked in the _textures Array.
    public function load(sheet:Texture, frameW:Number, frameH:Number):void {

      var imgSize:Rectangle = new Rectangle(0, 0, frameW, frameH)

      // do not tolerate partial image
      // TOTHINK: should I ?  
      var numX:Number = Math.floor(sheet.width / frameW);
      var numY:Number = Math.floor(sheet.height / frameH);

      // extract images from a frameset
      for(var y:Number = 0; y < numY; y++) {
        for(var x:Number = 0; x < numX; x++) {

          var frame:Rectangle = new Rectangle((x*frameW), (y*frameH), frameW, frameH);
          this._textures.push(Texture.fromTexture(sheet, frame, imgSize));
        }
      }
    }

    public function getFirstgid():uint {
      return this._firstgid;
    }
    public function setFirstgid(gid:uint):void {
      this._firstgid = gid;
    }
  }
}
