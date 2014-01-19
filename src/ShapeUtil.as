package {
	import starling.textures.Texture;
  import flash.display.Shape;
  import flash.display.BitmapData;

  public class ShapeUtil {
    public static function shapeToTexture(shape:Shape, h:uint, w:uint):Texture {
      var shapeBitmap:BitmapData = new BitmapData(h, w, true, 0);
      //var transform : Matrix = new Matrix();
      shapeBitmap.draw(shape);
      return Texture.fromBitmapData(shapeBitmap);
    }

    public static function squareTexture(h:uint, w:uint, color:uint = 0x000000, alpha:Number = 1):Texture {
      var square:Shape = new Shape(); 
      square.graphics.beginFill(color, alpha); 
      square.graphics.drawRect(0, 0, h, w); 
      //shape.graphics.endFill();
      return shapeToTexture(square, h, w);
    }

    public static function rectTexture(h:uint, w:uint, color:uint = 0x000000, alpha:Number = 1, filled:Boolean = false):Texture {
      var rect:Shape = new Shape(); 
      //rect.graphics.beginFill(color, alpha); 
      if(filled) {
        rect.graphics.beginFill(color, alpha); 
        rect.graphics.drawRect(0, 0, h, w); 
        rect.graphics.endFill();
      } else {
        rect.graphics.lineStyle(2, color);
        rect.graphics.drawRect(0, 0, h, w);
      }
      return shapeToTexture(rect, h, w);
    }

    public static function circleTexture(radius:uint, color:uint = 0x000000, alpha:Number = 1, filled:Boolean = false):Texture {
      var circle:Shape = new Shape(); 
      if(filled) {
        circle.graphics.beginFill(color, alpha); 
        circle.graphics.drawCircle(radius, radius, radius); 
        circle.graphics.endFill();
      } else {
        circle.graphics.lineStyle(2, color);
        circle.graphics.drawCircle(radius, radius, radius); 
      }
      return shapeToTexture(circle, radius * 2, radius * 2);
    }
  }
}
