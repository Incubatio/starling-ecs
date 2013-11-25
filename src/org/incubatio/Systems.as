package org.incubatio {
  public class Systems {

    public function Systems():void { throw new Error("Systems can't be instanciated"); }

    protected static var _data:Object;
    protected static var _resources:Object = {};


    public static function initSystemList():void {
      Systems._data = {
        Rendering: Rendering,
        Rotation: Rotation,
        Collision: Collision,
        Movement: Movement,
        Weapon: Weapon,
        Jump: Jump
      }
    }

    public static function get(systemName:String):* {
      return Systems._data[systemName] ? Systems._data[systemName] : false;
    }

    public static function getResource(resourceName:String):* {
      return Systems._resources[resourceName] ? Systems._resources[resourceName] : false;
    }

    public static function setResource(resourceName:String, value:*):void {
      Systems._resources[resourceName] = value; 
    }
  }
}

import Components;
import Entity;
import flash.geom.Rectangle;


// TODO: switch class below to interface
class System {
  //protected var _options:Object = {};
  //public function System(options:Object) : void {
    //for k in options { this._data[k] = options[k] }
  //  this._options = options;
  //}
}

class Rendering extends System {

  protected var _offset:Array = new Array(0, 0);
  protected var _scaleRate:Number = 1;

  public function update(entity:Entity, ms:int) : void {
    var component:* = entity.getComponent("Visible");
    if(component) {
      if(component.animation) { component.image = component.animation.update(ms); }
      component.image.x = entity.x;
      component.image.y = entity.y;
    }
  }

  // Drawing is automatically managed by Action Script 3
}

// Transform Rotation
class Rotation extends System {
  /*
  public function update(sprite):void {
    if(!sprite.components.Visible.originalImage) {
      sprite.components.Visible.originalImage = sprite.components.Visible.image;
    }
    if(sprite.components.Rotative) {
      sprite.components.Rotative.rotation += sprite.components.Rotative.rotationSpeed;
      if(sprite.components.Rotative.rotation >= 360) { sprite.components.Rotative.rotation -= 360; }
      sprite.components.Visible.image = gamecs.Transform.rotate(sprite.components.Visible.originalImage, sprite.components.Rotative.rotation);
      var size:Array = sprite.components.Visible.image.getSize();
      sprite.rect.width = size[0];
      sprite.rect.height = size[1];
      sprite.dirty = true;
    }
  } */
}



// NOTE: possible perf optimisation: test collision and save position every second (instead of each frame)
// if collision, replace sprite the position saved the last second
class Collision extends System {
  /*
  _isColliding: (entity, entities) ->
    res = false
    for entity2 in entities
      if entity.rect.collideRect(entity2.rect)
        res = true
        break
    return res
  */

  public function Collision(): void {
    //super(options);
    this.spriteCollide = this._spriteCollide;
  }
  
  /* function used to detect the collision 
  * @param {Object} entity
  * @param {Array} entities
  * @return {Array}
  */ 
  public var spriteCollide:Function = function():Array { return new Array() };

  // entity.components.Collidable ?
  public function _spriteCollide(entity:Entity):Array {
    var collisions:Array = new Array();
    var entities:Array = Systems.getResource("entities");
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

        var collisions:Array = this.spriteCollide(entity);
        if(collisions.length > 0) {
          var collisions2:Array = this.spriteCollide(entity);
          component.hasCollided = new Array(false, false, false); 

          //var oldRect:Rectangle = component2.mask.clone();
          entity.pos = entity.oldPos.concat();
          var multiplier:Number = component.dirX != 0 && component.dirY != 0 ? 1 : 1.41;
          trace(collisions);
          trace(entity.pos);
          for(var i:uint = 0; i < 2; i++) {
            var move:int = component.dir[i] * component.speed[i] * multiplier;
            entity.pos[i] += move;
            trace(entity.pos);
            
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

class Movement extends System {

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

        /*
        for each(var entity:Entity in collisions) {
          if(!entity2.Traversable) entity2.dirty = true;
          entity2.dirty = true;
        }
        */
      }
    }
  }
}


class Weapon extends System {
  /*
  public function update(entity, ms, director):void {
    var component:* = entity.getComponent("Weaponized");
    if(component && component.attacking) {
      weapon = director.scene.entitys[entity.weapon];
    
      // test for current animation and if not exists, start it
      if(!weapon.animation.currentAnimation) {
        trace(entity.animation.currentAnimation)
        animation = (!entity.animation.currentAnimation || entity.animation.currentAnimation == "pause") ? "down" : entity.animation.currentAnimation;
        weapon.animation.start(animation);
      }
      //Rendering.clear(weapon, director.display)
      weapon.oldImage = null;

      // test for collision, apply hit
      collisions = gamecs.sprite.spriteCollide(weapon, director.scene.spriteGroup);
      for each(var entity2:Entity in collisions) {
        if(entity2.Destructible) {
          director.surface.clear(entity2.rect);
          entity2.kill();
        }
      }
      
      // TODO: push ennemy on hit
      // TODO: if ennemy is comming double hit, immobile normal hit, backing = 1/2 hit


      // Check if animation is finished, if not update image
      if(weapon.animation.finished) {
        sprite.attacking = false;
        weapon.animation.currentAnimation = null;
        weapon.dirty = false;
        weapon.rect.moveIp([- (sprite.rect.left + sprite.rect.width*2), - (sprite.rect.top + sprite.rect.height*2)]);
      } else {
        weapon.dirty = true;
        weapon.rect.moveIp(sprite.rect.left - weapon.rect.left, sprite.rect.top - weapon.rect.top);
        weapon.image = weapon.animation.update(60);
      }
    }
  }
  */
}


// TOTHINK: Wouldn't it be enough to set a default MoveY to 1 ?
// TOTHINK: Not really a gravity system, maybe implement one with box2d
class Jump extends System {
  /*

  //TODO: jumping speed should be in component ?
  protected var _force:int = 3;
  protected var _gravity:int = 2;

  public function update (entity, ms): void {
    var component:* = entity.getComponent("Mobile");
    var component2:* = entity.getComponent("Jumpable");
    if(component && component2) {
      // TODO: replace jumping by the startedAt
      if(component2.startedAt) {
        component.moveY = -1;
        //trace, this._gravity * (new Date() - component2.startedAt) / 100
        //trace, this._force * component.speedX
        var speed:Number = (this._force * component.speedX) -  (this._gravity * (new Date() - component2.startedAt) / 100 );
        //trace 3, Math.round(speed);
        component.speedY = Math.round(speed);
        if(speed < 1) component2.startedAt = false;
      } else {
        component.moveY = 1;
        component.speedY = 4;
        // Lol thx to the folowing, the hero can hang to the roof ^^ @IKeepThisForNow
        if(entity.rect.top == entity.oldRect.top) component2.canJump = true;
      }
    }
  }
  */
}

Systems.initSystemList();
