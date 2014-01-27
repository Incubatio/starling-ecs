package {
  import starling.display.Sprite;
  import starling.events.Event;
  import starling.events.KeyboardEvent;
  import starling.events.TouchEvent;
  import starling.events.Touch;
	import starling.textures.Texture;

  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;

	import org.incubatio.TextureAtlas;
	import org.incubatio.SpriteSheet;
  import org.incubatio.ADirector;
  import org.incubatio.Entity;
  import org.incubatio.Systems;

  import flash.system.Capabilities;

  import flash.net.URLRequest;
  import flash.net.URLLoader;

  import Assets;
  import ShapeUtil;
  import BattleDirector;


  public class Game extends Sprite {

    public var directors:Array = new Array();
    public var directorList:Object;
    public var myDirector:ADirector;

    protected var _config:Object;
    protected var _keyboardStates:Array = new Array();
    protected var _mouseStates:Array = new Array();


    public function Game() {
      super();  
      this.directorList = { battle: BattleDirector};

      var urlRequest:URLRequest = new URLRequest("http://localhost:8080/test");
      //var variables:URLVariables = new URLVariables();
      //variables.andsomequerystring = true;

      //urlRequest.data = variables;
      //urlRequest.method = 'POST';
      var urlLoader:URLLoader = new URLLoader(urlRequest);
      //urlLoader.addEventListener(Event.COMPLETE,  function(event:Event):void {
      urlLoader.addEventListener("complete",  function(event:Object):void {
          trace(event.target.data);
          trace("Node Server reached");
      });
      //this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }


    public function getDirectorClass(name:String):Class {
      var director:Class;
      if(this.directorList[name]) director = this.directorList[name];
      return director;
    }


    public function start(config:Object):void {
      this._config = config;
      // TODO: move following initialisation in a function

      // Prepare sprite model data
      for(var key:String in config.sprites) {
        for(var key2:String in config.sprites[key]) {
          if(key2 == "Visible") {
            var texture:Texture;
            var component:Object = config.sprites[key][key2];
            if(component.shape) {
              switch(component.shape) {
                // TODO: add texture to texture atlas
                case "rect": texture = ShapeUtil.rectTexture(component.size[0], component.size[1]); break;
                case "circle": texture = ShapeUtil.circleTexture(component.radius); break;
                default: trace("Unrecognized component type");
              }
            } else if(component.image) {
              if(component.frameSize) {
                var s:SpriteSheet = Assets.getSpriteSheet(component.image, component.frameSize);
                texture = s.get(1);
              } else texture = Assets.getTexture(component.image)
            } 
            component.texture = texture;
            config.sprites[key][key2] = component;
          }
        }
      }

      this.switchDirector("Battle");

      // INIT systems
      Systems.setResource("game", this);
      Systems.setResource("screenSize", config.screen.size);

      this.onAddedToStage(null);

      this.addEventListener(Event.ENTER_FRAME, tick);
    }                                             


    public function onAddedToStage(e:Event):void {
      this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
      this.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);

      //Test if device is computer, add mouse event or touch event depending the device involve
      //trace("resolution: " + Capabilities.screenResolutionY);
      this.addEventListener(TouchEvent.TOUCH, this.onTouch);
    }


    public function onKeyUp(e:KeyboardEvent):void { this._keyboardStates[e.keyCode] = false; }


    public function onKeyDown(e:KeyboardEvent):void { this._keyboardStates[e.keyCode] = true; }


    private function onTouch(event:TouchEvent):void {
      var touch:Touch = event.getTouch(this);
      if(touch) { this._mouseStates[touch.phase] = touch; }
    }


    public function tick(e:Event):void {

      // 1. Handle input and A.I.
      myDirector.handleInput(this._keyboardStates, this._mouseStates);

      // 2. Update
      for each(var group:Array in myDirector.groups) {
        for each(var entity:Entity in group) {
          for each(var system:* in myDirector.systems) { Systems.get(system).update(entity, 10);}//stage.frameRate); }
        }
      }
      // 4. Game Over condition
      //if(myDirector.player.killed && !myDirector.isGameOver) myDirector.gameOver()
    }


    public function switchDirector(name:String):void {
      name = name.toLowerCase();

      if(!this.directors[name]) { 
        var DirectorClass:Class = this.getDirectorClass(name);
        this.directors[name] = new DirectorClass({config: this._config});
      }

      this.myDirector = this.directors[name];
      Systems.setResource("entities", this.myDirector.entities);
      this.myDirector.draw(this);
    }


  }
}
