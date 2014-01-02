package {
  import starling.display.Sprite;
  import starling.events.Event;
  import starling.events.KeyboardEvent;
  import starling.events.TouchEvent;

	import starling.textures.Texture;
	import org.incubatio.TextureAtlas;
	import org.incubatio.SpriteSheet;
	import org.incubatio.Animation;
	import starling.display.Image;

  import flash.geom.Matrix;

  import flash.utils.ByteArray;

  import flash.geom.Rectangle;

  import ShapeUtil;

  import Director;
  import org.incubatio.Entity;
  import org.incubatio.Systems;

  import  flash.net.URLRequest;
  import  flash.net.URLLoader;

  import Assets;

  public class Game extends Sprite {
    public var myDirector:Director;
    // TODO: move groups into director

    //public var inputEvents:Array = new Array();
    protected var _states:Array = new Array();

    public var mySystems:Array = new Array();
    public var groups:Object = {};

    public function Game() {
      super();
        

      trace('candy');
      var urlRequest:URLRequest = new URLRequest("http://localhost:8080/test");
      //var variables:URLVariables = new URLVariables();
      //variables.andsomequerystring = true;

      //urlRequest.data = variables;
      //urlRequest.method = 'POST';
      var urlLoader:URLLoader = new URLLoader(urlRequest);
      //urlLoader.addEventListener(Event.COMPLETE,  function(event:Event):void {
      urlLoader.addEventListener("complete",  function(event:Object):void {
          trace(event.target.data);
          trace('sweet');
      });
      //this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function start(config:Object):void {
      var entities:Array = new Array();
      var player:Entity;
      // TODO: move following initialisation in a function

      // PREPARE sprite model data
      for(var key:String in config.sprites) {
        for(var key2:String in config.sprites[key]) {
          if(key2 == "Visible") {
            var texture:Texture;
            var component:Object = config.sprites[key][key2];
            if(component.shape) {
              switch(component.shape) {
                // TODO: add texture to texture atlas
                case "rect": texture = ShapeUtil.squareTexture(component.size[0], component.size[1]); break;
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

      // Create Actors
      for each(var value:String in config.scene.actors) {

        var pos:Array = value.split(",");
        var name:String = pos.shift();
        // TODO: using pop might be faster, but does not matter much on init
        var componentData:Object = this.clone(config.sprites[name]);
        //var component2:Object = config.sprites[name]["Visible"];
        trace(componentData["Visible"]);
        if(componentData["Visible"]) {
          // componentData["Visible"].image = new Image(textureAtlas.get(componentData["Visible"].image));
          // TODO: fix overuse of image below/use texture atlas
          if(componentData["Visible"]["frameSize"]) {
              componentData["Visible"]["animation"] = new Animation(
                Assets.getSpriteSheet(componentData["Visible"]["image"], componentData["Visible"]["frameSize"]), 
                componentData["Visible"]["frameset"],
                componentData["Visible"]["options"]
              );
              //componentData["Visible"]["animation"].start("pause");
              //trace( componentData["Visible"]["animation"].getCurrentFrame());
              componentData["Visible"].image = componentData["Visible"]["animation"].update(0);
              //trace( componentData["Visible"]["animation"].getCurrentFrame());
          } else {
            componentData["Visible"].image = new Image(config.sprites[name]["Visible"].texture);
          }
          delete(componentData["Visible"].texture);

          if(componentData["Collidable"] && componentData["Collidable"]["type"] == "image") {
            componentData["Collidable"]["mask"] = componentData["Visible"].image.bounds.clone();
          }
        }


        var entity:Entity = new Entity(pos, componentData);
        entity.name = name;
        entities.push(entity);

        if(player == null && name == "Pad") { player = entity; }

        // Add actor to the scene
        var component2:Object = entity.getComponent("Visible");
        if(component2) { this.addChild(component2.image); }
          // TODO: line below should be made via system
          //component2.image.x = entity.x;
          //component2.image.y = entity.y;
      }
      this.groups.sprites = entities;

      // INIT systems
      Systems.setResource("game", this);
      Systems.setResource("entities", entities);
      Systems.setResource("screenSize", config.screen.size);
      for each(var k:String in config.systems) {
        var SystemClass:Class = Systems.get(k);
        //this.mySystems[k] = new SystemClass({ entities: entities });
        this.mySystems[k] = new SystemClass();
      }

      // Add world collision
      // TODO: rename _spriteCollide into defaultSpriteCollide
      this.mySystems["Collision"].spriteCollide = function(e:Entity):Array {
        var size:Array = Systems.getResource("screenSize");
        var component:Object = entity.getComponent("Visible");
        return (entity.x > size[0] - component.image.width || entity.y > size[1] - component.image.height  || entity.x < 0 || entity.y < 0) ? new Array(new Entity(new Array(0,0), {})) : this._spriteCollide(e);
      }

      // add entities events
      for each(entity in entities) {
        if(entity.name == "Ball") {
          entity.on("collision", function():void {
              var component:* = entity.getComponent("Mobile");
              if(component.hasCollidedX) component.dirX = -component.dirX;
              if(component.hasCollidedY) component.dirY = -component.dirY;
          });

        }

      }

      trace(config.screen.size);
      this.myDirector = new Director({groups: groups, player: player});
      //this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

      this.onAddedToStage(null);

      this.addEventListener(Event.ENTER_FRAME, tick);
    }


    public function clone( source:Object ):* { 
      var myBA:ByteArray = new ByteArray(); 
      myBA.writeObject( source ); 
      myBA.position = 0; 
      return( myBA.readObject() ); 
    }

    public function onAddedToStage(e:Event):void {
      this.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
      this.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
    }

    public function onKeyUp(e:KeyboardEvent):void {
      this._states[e.keyCode] = false;
    }

    public function onKeyDown(e:KeyboardEvent):void {
      this._states[e.keyCode] = true;
    }

    public function addInputEvent(e:Event):void { 
      //this.inputEvents.push(e); 
      //trace(this.inputEvents.length);
      //this.myDirector.handleInput(e);
    }

    //public function onEnterFrame(e:Event):void {
    public function tick(e:Event):void {
      //trace("Hello Frame " + stage.frameRate);

      // 1. Handle input and A.I.
      //myDirector.handleInput(this.inputEvents);
      myDirector.handleInput(this._states);


      // TODO: looks what more performant btw pop, while inputEvent.size or present solution)
      //this.inputEvents = new Array();
      //myDirector.handleAI()

      // 2. Update
      for each(var group:Array in groups) {
        for each(var entity:Entity in group) {
          for each(var system:* in mySystems) { system.update(entity, 10);}//stage.frameRate); }
        }
      }

      //myDirector.setOffset(mySystems.Rendering);

      // 3. Draw - NO NEED FOR FLASH
      //for entity in myDirector.groups.stars then mySystems.Rendering.draw(entity, display.bg2)
      //for entity in myDirector.groups.sprites then mySystems.Rendering.draw(entity, display.fg)

      // 4. Game Over condition
      //if(myDirector.player.killed && !myDirector.isGameOver) myDirector.gameOver()
    }
  }
}
