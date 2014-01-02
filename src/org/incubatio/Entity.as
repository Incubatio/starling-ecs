package org.incubatio {
import org.incubatio.Components;
import org.incubatio.EventObject;

  public class Entity extends EventObject {
    protected static var UID:int = 1;
    public var id:int;
    protected var _options:Object;
    protected var _components:Object = {};
    public var pos:Array;
    public var oldPos:Array;
    public var name:String;

    public function Entity(pos:Array, componentsData:Object, options:Object = null) : void {
      //this._options = new Array();
      //this._components = new Array();
      this.oldPos = this.pos = pos;
      this.id = Entity.UID++;

      //for(var k:String in options) { this._data[k] = options[k]; }
      this._options = options != null ? options : {};

      for(var k:String in componentsData) {
        var params:Object = componentsData[k];

        //if typeof Components[k] == "function"
        var ComponentClass:* = Components.get(k);    
        if(ComponentClass) {
          this._components[k] = new ComponentClass();
          //this.components[k].parent = this;

          //init component object, TOTHINK: shouldn't that be the role of Component constructor ?
          for(var k2:String in params) {
            if(!this._components[k].hasOwnProperty(k2)) {
              trace('Warning Component Property "' + k2 + '" Not Found in ' + k + ' | current value: ' + params[k2]);
            }
            // TODO: check if action script pass Array be reference or not
            this._components[k][k2] = typeof(params[k2]) == "object" ? params[k2] : this._components[k][k2] = params[k2];
          }
            
        } else trace('Warning Component Class "' + k + '" Not Found.');
      }
    }

    public function get x():int { return this.pos[0]; }
    public function get y():int { return this.pos[1]; }
    public function get z():int { return this.pos[2]; }

    public function set x(pos:int):void { this.pos[0] = pos; }
    public function set y(pos:int):void { this.pos[1] = pos; }
    public function set z(pos:int):void { this.pos[2] = pos; }

    public function getComponent(componentName:String):* {
      return this._components[componentName] ? this._components[componentName] : false;
    }

    public function getComponents():Object {
      return this._components;
    }

    public function toString() : String {
      return (this.name || "Entity") + '#' + this.id
    }
  }
}

