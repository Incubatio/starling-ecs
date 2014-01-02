package {
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import org.incubatio.TextureAtlas;
	import org.incubatio.SpriteSheet;

	public class Assets {
		protected static var _textures:Dictionary = new Dictionary();
		protected static var _spriteSheets:Dictionary = new Dictionary();
		protected static var _textureAtlases:Dictionary = new Dictionary();

		[Embed(source="../public/images/tennis_ball.png")]
		public static const tennis_ball:Class;


		[Embed(source="../public/images/frameset/firefox.png")]
		public static const firefox:Class;

		/** @param String name
		  * @return starling.Texture
		  */
		public static function getTexture(name:String):Texture {
			if (Assets._textures[name] == null) {
				var bitmap:Bitmap = new Assets[name]();
				Assets._textures[name] = Texture.fromBitmap(bitmap);
			}
			
			return Assets._textures[name];
		}

    /** We simply use Texture atlas to extract Texture, animation are managed with org.Incubatio.Spritesheet + org.incubatio.Animation
      *
      * I don't like TextureAltlas:
      * - it depends on parseXml when it could simply have a default parseObject,
      * - for animations, it is combined by default with juggler which "hides" animation management
      * - and also lacks of spritesheets tweaking options
      *
      * TODO: could be nice to access every texture from getTexture method wether it's loaded from a simple image 
      *   or an imageset with a configuration file
      *
      * @param String name
      * @return starling.TextureAtlas
      */
    public static function getTextureAtlas(name:String, data:Object):TextureAtlas {
      if (Assets._textureAtlases[name] == null) {
        var texture:Texture = Assets.getTexture(name)
        Assets._textureAtlases[name] = new TextureAtlas(texture);

        // var xml:XML = XML(new AtlasXml());
        // Assets._textureAtlases[name].parseXml(xml);
        Assets._textureAtlases[name].parse(data);

      }
      return Assets._textureAtlases[name];
    }

    public static function getSpriteSheet(name:String, size:Array):SpriteSheet {
      if (Assets._spriteSheets[name] == null) {
        Assets._spriteSheets[name] =  new SpriteSheet();
        Assets._spriteSheets[name].load(Assets.getTexture(name), size[0], size[1]);
      }
      return Assets._spriteSheets[name];
    }
	}
}
