package org.incubatio {

  import org.incubatio.Systems;
  import org.incubatio.Entity;
	import org.incubatio.Animation;

	import starling.display.Image;
  import starling.display.Sprite;

  import flash.utils.ByteArray;



  public class ADirector {

    protected var _options:Object;

    public var entities:Vector.<Entity> = new <Entity>[];
    public var groups:Array = new Array();
    public var systems:Array = new Array();


    //public function ADirector():void { throw new Error("ADirector can't be instanciated"); }


    public function clone(source:Object):* { 
      var buff:ByteArray = new ByteArray(); 
      buff.writeObject(source); 
      buff.position = 0; 
      return (buff.readObject()); 
    }


    public function initEntitiesFromConfig(config:Object):Vector.<Entity> {

      var entities:Vector.<Entity> = new <Entity>[];
      for each(var value:String in config.scene.actors) {

        var pos:Array = value.split(",");
        var name:String = pos.shift();
        var type:String = pos.shift();
        var componentData:Object = this.clone(config.sprites[type]);

        if(componentData["Visible"]) {
          // componentData["Visible"].image = new Image(textureAtlas.get(componentData["Visible"].image));
          // TODO: optimise overuse of image below. Use texture atlas
          if(componentData["Visible"]["frameSize"]) {
              componentData["Visible"]["animation"] = new Animation(
                Assets.getSpriteSheet(componentData["Visible"]["image"], componentData["Visible"]["frameSize"]), 
                componentData["Visible"]["frameset"],
                componentData["Visible"]["options"]
              );
              //componentData["Visible"]["animation"].start("pause");
              componentData["Visible"].image = componentData["Visible"]["animation"].update(0);
          } else {
            componentData["Visible"].image = new Image(config.sprites[type]["Visible"].texture);
          }
          delete(componentData["Visible"].texture);

          if(componentData["Collidable"] && componentData["Collidable"]["type"] == "image") {
            componentData["Collidable"]["mask"] = componentData["Visible"].image.bounds.clone();
          }
        }

        var entity:Entity = new Entity(pos, componentData);
        entity.name = name;
        entities.push(entity);
      }
      return entities;
    }


    public function draw(game:Sprite):void { }


    public function clear(game:Sprite):void { }


    public function handleInput(keyboardStates:Array, mouseStates:Array):void { }

  }
}
