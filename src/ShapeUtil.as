package {
	import starling.textures.Texture;
  import flash.display.Shape;
  import flash.display.BitmapData;

  public class ShapeUtil {
    public static function shapeToTexture(shape:Shape, h:uint, w:uint):Texture {
      shape.graphics.endFill();
      var shapeBitmap:BitmapData = new BitmapData(h, w, true, 0);
      //var transform : Matrix = new Matrix();
      shapeBitmap.draw(shape);
      return Texture.fromBitmapData(shapeBitmap);
    }

    public static function squareTexture(h:uint, w:uint, color:uint = 0x000000, alpha:Number = 1):Texture {
      var square:Shape = new Shape(); 
      square.graphics.beginFill(color, alpha); 
      square.graphics.drawRect(0, 0, h, w); 
      return shapeToTexture(square, h, w);
    }

    public static function circleTexture(radius:uint, color:uint = 0x000000, alpha:Number = 1):Texture {
      var circle:Shape = new Shape(); 
      circle.graphics.beginFill(color, alpha); 
      circle.graphics.drawCircle(radius, radius, radius); 
      return shapeToTexture(circle, radius * 2, radius * 2);
    }
  }
}
