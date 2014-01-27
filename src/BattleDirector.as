package {
  import flash.ui.Keyboard;
  import starling.events.Touch;
  import starling.events.TouchPhase;

  import org.incubatio.Entity;
  import org.incubatio.Systems;
	import org.incubatio.TileMap;
	import org.incubatio.ADirector;

	import starling.display.Image;
	import starling.textures.Texture;
  import starling.display.Sprite;



  public class BattleDirector extends ADirector {

    protected var _tileMap:TileMap;
    protected var _tiles:Array = new Array();
    protected var _selectedTile:Image;

    protected var _player:Entity;


    public function BattleDirector(options:Object = null) {
      this._options = options;

      this.systems = options.config.systems;

      // Create Entities
      this.entities = this.initEntitiesFromConfig(options.config);
      for each(entity in this.entities) {
        if(this._player == null && entity.name == "Player") { this._player = entity; }
      }

      this.groups.sprites = this.entities;

      // add entities events
      for each(var entity:Entity in this.entities) {
        if(entity.name == "Ball") {
          entity.on("collision", function():void {
            var component:* = entity.getComponent("Mobile");
            if(component.hasCollidedX) component.dirX = -component.dirX;
            if(component.hasCollidedY) component.dirY = -component.dirY;
          });
        }
      }

      // Add TileMap
      var tileHorrizontalNum:uint = 12;
      var tileVerticalNum:uint = 10;
      var tileWidth:uint  = Math.floor(options.config.screen.size[0] / tileHorrizontalNum);
      var tileHeight:uint = Math.floor(options.config.screen.size[1] / tileVerticalNum);

      this._tileMap = new TileMap({
        width: tileHorrizontalNum,
        height: tileVerticalNum,
        tilewidth: tileWidth,
        tileheight: tileHeight
        });

      this._selectedTile = new Image(ShapeUtil.rectTexture(tileWidth, tileHeight, 0x00FF00, 0.1, true));

      // For each tile draw a not filled rectangle
      var rectTexture:Texture = ShapeUtil.rectTexture(tileWidth, tileHeight);
      for(var i:uint = 0; i < tileVerticalNum; i++) {
        for(var j:uint = 0; j < tileHorrizontalNum; j++) {
          var buffImg:Image = new Image(rectTexture);
          buffImg.x = j * tileWidth; 
          buffImg.y = i * tileHeight;
          this._tiles.push(buffImg);
        }
      }
    }


    override public function draw(game:Sprite):void {
      for each(var group:Array in this.groups) {
        for each(var entity:Entity in group) {
          var component2:Object = entity.getComponent("Visible");
          if(component2) { game.addChild(component2.image); }
        }
      }
      game.addChild(this._selectedTile);
      for each(var tile:Image in this._tiles) { game.addChild(tile) };

      // Add world collision
      Systems.get("Collision").spriteCollide = function(e:Entity):Array {
        var size:Array = Systems.getResource("screenSize");
        var component:Object = entity.getComponent("Visible");
        return (entity.x > size[0] - component.image.width || entity.y > size[1] - component.image.height  || entity.x < 0 || entity.y < 0) ? new Array(new Entity(new Array(0,0), {})) : this.defaultSpriteCollide(e);
      }
    }


    override public function clear(game:Sprite):void {
      for each(var group:Array in this.groups) {
        for each(var entity:Entity in group) {
          var component2:Object = entity.getComponent("Visible");
          if(component2) game.removeChild(component2.image);
        }
      }
      game.removeChild(this._selectedTile);
      for each(var tile:Image in this._tiles) { game.removeChild(tile) };
      Systems.get("Collision").spriteCollide = Systems.get("Collision").defaultSpriteCollide;
    }


    override public function handleInput(keyboardStates:Array, mouseStates:Array):void {

      // Keyboard
      var component:Object = this._player.getComponent("Mobile");
      if(component) {
        var y:int = component.dirY;

        if(keyboardStates[Keyboard.UP]) y = -1; 
        else if(y < 0) y = 0; 

        if(keyboardStates[Keyboard.DOWN]) y = 1; 
        else if(y > 0) y = 0; 
      }
      if(component.dirY != y) {
        component.dirY = y;
        var component2:Object  = this._player.getComponent("Visible");
        if(component2) {
          var animation:String = null;
          switch(y) {
            case -1: animation = "up";break;
            case 1: animation = "down";break;
            default: animation = "pause";break;
          }
          if(animation) component2.animation.start(animation);
        }
      }

      // Mouse
      for(var key:String in mouseStates) {
        var touch:Touch = mouseStates[key];
        if(touch) {

          var gid:uint    = this._tileMap.pos2gid(touch.globalX, touch.globalY);
          var oldgid:uint = this._tileMap.pos2gid(this._selectedTile.x, this._selectedTile.y);

          switch(key) {
            case TouchPhase.BEGAN: 
              trace("foo: " + gid);
              break;
          //  case TouchPhase.ENDED: 
          //    break;
            case TouchPhase.HOVER: 
              if(gid != oldgid) {
                trace("cat: " + gid);
                var pos:Array = this._tileMap.gid2pos(gid);
                this._selectedTile.x = pos[0];
                this._selectedTile.y = pos[1];
              }
              break;
          }
          mouseStates[key] = null;
        }
      }
    }


  }
}
