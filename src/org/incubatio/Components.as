package org.incubatio {

  public class Components {
    protected static var _data:Object = {};
    
    public function Components():void { throw new Error("Components can't be instanciated"); }

    public static function initComponentList():void {
        Components._data = {
          Visible: Visible,
          Communicable: Communicable,
          Mobile: Mobile,
          Rotative: Rotative,
          Flipable: Flipable,
          Movable: Movable,
          Destructible: Destructible,
          Inteligent: Inteligent,
          Weaponized: Weaponized,
          Triggerable: Triggerable,
          Collidable: Collidable,
          Jumpable: Jumpable
        }
    }

    public static function get(componentName:String):* {
      return Components._data[componentName] ? Components._data[componentName] : false;
    }
  }
}

import starling.textures.Texture;
import starling.display.Image;


class Visible {
  public var image_urn:String = null;
  //public var image:Image = null;
  //public var originalImage:Image = null;
  public var color:String = "#f00";
  public var size:int = 0;
  public var radius:int = 0;
  public var shape:int = 0;

  public var image:Image;
  public var animation:Object;
}

class Communicable {
  public var avatar:String = "question.png";
  public var dialogs:Array = null;
}

class Mobile {
  public var speed:Array = null;
  public var dir:Array = null;
  public var hasCollided:Array = null;
  public function Mobile(): void {
    this.speed = new Array(0, 0, 0);
    this.dir = new Array(0, 0, 0);
    this.hasCollided = new Array(false, false, false);
  }
  
  public function get dirX():int { return this.dir[0]; }
  public function get dirY():int { return this.dir[1]; }
  public function get dirZ():int { return this.dir[2]; }
  public function set dirX(dir:int):void { this.dir[0] = dir; }
  public function set dirY(dir:int):void { this.dir[1] = dir; }
  public function set dirZ(dir:int):void { this.dir[2] = dir; }

  public function get speedX():int { return this.speed[0]; }
  public function get speedY():int { return this.speed[1]; }
  public function get speedZ():int { return this.speed[2]; }
  public function set speedX(speed:int):void { this.speed[0] = speed; }
  public function set speedY(speed:int):void { this.speed[1] = speed; }
  public function set speedZ(speed:int):void { this.speed[2] = speed; }

  public function get hasCollidedX():Boolean { return this.hasCollided[0]; }
  public function get hasCollidedY():Boolean { return this.hasCollided[1]; }
  public function get hasCollidedZ():Boolean { return this.hasCollided[2]; }
  public function set hasCollidedX(hasCollided:Boolean):void { this.hasCollided[0] = hasCollided; }
  public function set hasCollidedY(hasCollided:Boolean):void { this.hasCollided[1] = hasCollided; }
  public function set hasCollidedZ(hasCollided:Boolean):void { this.hasCollided[2] = hasCollided; }
}

class Rotative {
  public var rotationSpeed:int = 10;
  public var rotationAngle:int = 0;
}

class Flipable {
  public var vertical:Boolean = false;
  public var horizontal:Boolean = false;
}

class Movable {
  //alive: true
}

// TODO: Alive class
class Destructible {
// lifepoints
}

//class Traversable

class Inteligent {
//  public var pathfinding:String = "straight"; //none(human), random, sentinel, A*
//  public var detectionRadius:int = 0;
}

class Weaponized {
  public var behavior:String = 'offensive'; // defensive, balanced
  public var alorithm:String = 'kamikaze'; // none(human), fixed strategy, multiple strategy, alpha beta pruning
  public var attacking:Boolean = false;
  public var weapon:String = 'sword';
  // public var attackRadius:int = 0;
}

class Triggerable {
  public var triggered:Boolean = false;
}

class Collidable {
  public var type:String = null;
  public var mask:*;
}

class Jumpable {
  public var startedAt:Date = null;
  public var canJump:Boolean = true;
}

Components.initComponentList();
