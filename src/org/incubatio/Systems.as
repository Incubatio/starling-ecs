package org.incubatio {



  public class Systems {

    public function Systems():void { throw new Error("Systems can't be instanciated"); }

    protected static var _data:Object;
    protected static var _resources:Object = {};


    public static function initSystemList():void {
      if(Systems._data == null) {
        var list:Object = {
          Rendering: Rendering,
          //Rotation: Rotation,
          Collision: Collision,
          Movement: Movement
          //Weapon: Weapon,
        }
        Systems._data = {};
        for(var k:String in list) {
          var SystemClass:Class = list[k];
          Systems._data[k] = new SystemClass();
        }
      }
    }


    //public static function get(systemName:String):ISystem {
    public static function get(systemName:String):* {
      return Systems._data[systemName] ? Systems._data[systemName] : null;
    }


    public static function getResource(resourceName:String):* {
      return Systems._resources[resourceName] ? Systems._resources[resourceName] : null;
    }


    public static function setResource(resourceName:String, value:*):void {
      Systems._resources[resourceName] = value; 
    }


  }
}



import org.incubatio.Components;
import org.incubatio.Entity;
import org.incubatio.Systems;
import flash.geom.Rectangle;



// TODO: switch class below to an interface
interface ISystem { 
  function update(entity:Entity, ms:uint):void;
}



class Rendering implements ISystem {

  protected var _offset:Array = new Array(0, 0);
  protected var _scaleRate:Number = 1;

  public function update(entity:Entity, ms:uint) : void {
    var component:* = entity.getComponent("Visible");
    if(component) {
      // Three choice to manage animation:
      // 1. Animation automatically managed by a MovieClip object added to Starling.juggler
      // 2. using A movieClip and manually playing animation object.advanceTime(time);
      // 3. using gamecs spriteSheet object component.image = component.animation.update(ms); }
      if(component.animation && component.animation.isRunning()) { 

        var game:Game = Systems.getResource("game");
        game.removeChild(component.image);
        component.image = component.animation.update(4);
        game.addChild(component.image);
      }
      component.image.x = entity.x;
      component.image.y = entity.y;
    }
  }

  // Drawing is automatically managed by Action Script 3
}



// Transform Rotation
class Rotation implements ISystem {
  public function update(entity:Entity, ms:uint):void {
  }
}



// NOTE: possible perf optimisation: test collision and save position every second (instead of each frame)
// if collision, replace sprite the position saved the last second
class Collision implements ISystem {

  public function Collision(): void {
    //super(options);
    this.spriteCollide = this.defaultSpriteCollide;
  }
  
  /* function used to detect the collision 
  * @param {Object} entity
  * @param {Array} entities
  * @return {Array}
  */ 
  public var spriteCollide:Function = function():Vector.<Entity> { return new <Entity>[]; }

  // entity.components.Collidable ?
  public function defaultSpriteCollide(entity:Entity):Vector.<Entity> {
    var collisions:Vector.<Entity> = new <Entity>[];
    var entities:Vector.<Entity> = Systems.getResource("entities");
    for each(var entity2:Entity in entities) {
      if(entity.id != entity2.id) {
        var bounds1:Rectangle = entity.getComponent("Collidable").mask;
        bounds1.x = entity.x;
        bounds1.y = entity.y;
        var bounds2:Rectangle = entity2.getComponent("Collidable").mask;
        bounds2.x = entity2.x;
        bounds2.y = entity2.y;
        if (bounds1.intersects(bounds2)) collisions.push(entity2);
      }
    }
    return collisions;
  }

    
  public function update(entity:Entity, ms:uint):void {
    // We assume that we need a mobile object to test for collision
    var component:* = entity.getComponent("Mobile");
    var component2:* = entity.getComponent("Collidable");
    if(component && component2) {
      if(component.dirX != 0 || component.dirY != 0) {
        //component.hasCollided = component.hasCollided.map(function() { return true });

        var collisions:Vector.<Entity> = this.spriteCollide(entity);
        if(collisions.length > 0) {
          var collisions2:Vector.<Entity> = this.spriteCollide(entity);
          component.hasCollided = new <Boolean>[false, false, false]; 

          //var oldRect:Rectangle = component2.mask.clone();
          entity.pos = entity.oldPos.concat();
          var multiplier:Number = component.dirX != 0 && component.dirY != 0 ? 1 : 1.41;
          for(var i:uint = 0; i < 2; i++) {
            var move:int = component.dir[i] * component.speed[i] * multiplier;
            entity.pos[i] += move;
            
            collisions2 = this.spriteCollide(entity);
            if(collisions2.length > 0) {
              component.hasCollided[i] = true;
              entity.pos[i] -= move;
              //entity.oldPos.clone();
              //entity.pos = entity.pos.concat();
            }
          }
          for each(var entity2:Entity in collisions) { entity.trigger("collision", {to: entity2}) }
        }
      }
    }
  } 
}



class Movement implements ISystem {

  public function update(entity:Entity, ms:uint):void {
    var component:* = entity.getComponent("Mobile");
    if(component) {
      if(component.dirX != 0 || component.dirY != 0) {

        //entity.oldRect = entity.rect.clone();
        //TODO: entity.saveOldPos ?
        entity.oldPos = entity.pos.concat();

        // TODO: Maybe manage mobile object while pressing a key that will put the user in a pushing/pulling position
        // 1 straight move = ~1.41 diagonal move, possible optimization ratio:  3/~4.25 and 5/~7.07
        var multiplier:Number = component.dirX != 0 && component.dirY != 0 ? 1 : 1.41;

        var x:int = Math.round(component.dirX * component.speedX * multiplier);
        var y:int = Math.round(component.dirY * component.speedY * multiplier);

        //entity.dirty = true;
        entity.x += x;
        entity.y += y;
        // TODO: check namespace entityGroup.entityCollide ?

      }
    }
  }
}



class Weapon implements ISystem {
  public function update(entity:Entity, ms:uint):void {
  }
}


Systems.initSystemList();
