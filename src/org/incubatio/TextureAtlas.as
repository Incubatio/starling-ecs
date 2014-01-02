package org.incubatio {

  import flash.geom.Rectangle;
  import flash.utils.Dictionary;
  import starling.textures.Texture;

  /** Starling improved clone clone of TextureAtlas */
  public class TextureAtlas {
    private var mAtlasTexture:Texture;
    private var mTextureRegions:Dictionary;
    private var mTextureFrames:Dictionary;
    
    /** helper objects */
    private static var sNames:Vector.<String> = new <String>[];
    
    /** Create a texture atlas from a texture by parsing the regions from an XML file. */
    public function TextureAtlas(texture:Texture, atlasXml:XML=null) {
      mTextureRegions = new Dictionary();
      mTextureFrames  = new Dictionary();
      mAtlasTexture   = texture;
    }
    
    /** Disposes the atlas texture. */
    public function dispose():void {
        mAtlasTexture.dispose();
    }
    
    /** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
    public function getTexture(name:String):Texture {
        var region:Rectangle = mTextureRegions[name];
        
        if (region == null) return null;
        else return Texture.fromTexture(mAtlasTexture, region, mTextureFrames[name]);
    }
    
    /** Returns all textures that start with a certain string, sorted alphabetically
     *  (especially useful for "MovieClip"). */
    public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture> {
        if (result == null) result = new <Texture>[];
        
        for each (var name:String in getNames(prefix, sNames)) 
            result.push(getTexture(name)); 

        sNames.length = 0;
        return result;
    }
    
    /** Returns all texture names that start with a certain string, sorted alphabetically. */
    public function getNames(prefix:String="", result:Vector.<String>=null):Vector.<String> {
        if (result == null) result = new <String>[];
        
        for (var name:String in mTextureRegions)
            if (name.indexOf(prefix) == 0)
                result.push(name);
        
        result.sort(Array.CASEINSENSITIVE);
        return result;
    }
    
    /** Returns the region rectangle associated with a specific name. */
    public function getRegion(name:String):Rectangle {
        return mTextureRegions[name];
    }
    
    /** Returns the frame rectangle of a specific region, or <code>null</code> if that region 
     *  has no frame. */
    public function getFrame(name:String):Rectangle {
        return mTextureFrames[name];
    }
    
    /** Adds a named region for a subtexture (described by rectangle with coordinates in 
     *  pixels) with an optional frame. */
    public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):void {
        mTextureRegions[name] = region;
        mTextureFrames[name]  = frame;
    }
    
    /** Removes a region with a certain name. */
    public function removeRegion(name:String):void {
        delete mTextureRegions[name];
        delete mTextureFrames[name];
    }
    
    /** This function is called by the constructor and will parse an XML in Starling's 
     *  default atlas file format. Override this method to create custom parsing logic
     *  (e.g. to support a different file format). */
    protected function parseAtlasXml(atlasXml:XML):void {
        var scale:Number = mAtlasTexture.scale;
        
        for each (var subTexture:XML in atlasXml.SubTexture)
        {
            var name:String        = subTexture.attribute("name");
            var x:Number           = parseFloat(subTexture.attribute("x")) / scale;
            var y:Number           = parseFloat(subTexture.attribute("y")) / scale;
            var width:Number       = parseFloat(subTexture.attribute("width")) / scale;
            var height:Number      = parseFloat(subTexture.attribute("height")) / scale;
            var frameX:Number      = parseFloat(subTexture.attribute("frameX")) / scale;
            var frameY:Number      = parseFloat(subTexture.attribute("frameY")) / scale;
            var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth")) / scale;
            var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight")) / scale;
            
            var region:Rectangle = new Rectangle(x, y, width, height);
            var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
                    new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
            
            addRegion(name, region, frame);
        }
    }
    
    /** The base texture that makes up the atlas. */
    public function get texture():Texture { return mAtlasTexture; }
    
    protected function parseAtlas(atlas:Object):void {
        var scale:Number = mAtlasTexture.scale;
        
        for each (var subTexture:Object in atlas) {
            var name:String = subTexture.name;
            var x:Number = parseFloat(subTexture.x) / scale;
            var y:Number = parseFloat(subTexture.y) / scale;
            var width:Number = parseFloat(subTexture.width) / scale;
            var height:Number = parseFloat(subTexture.height) / scale;
            var frameX:Number = parseFloat(subTexture.frameX) / scale;
            var frameY:Number = parseFloat(subTexture.frameY) / scale;
            var frameWidth:Number = parseFloat(subTexture.frameWidth) / scale;
            var frameHeight:Number = parseFloat(subTexture.frameHeight) / scale;
            
            var region:Rectangle = new Rectangle(x, y, width, height);
            var frame:Rectangle = frameWidth > 0 && frameHeight > 0 ?
              new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
            
            addRegion(name, region, frame);
        }
    }

  }
}
