package {
  import flash.ui.Keyboard;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  import org.incubatio.Entity;

  // TODO: Rename into BattleDirector ?
  public class Director {

    protected var _options:Object;

    public var groups:Array = new Array();

    public function Director(options:Object) {
      this._options = options;
    }

    public function handleInput(keyboardStates:Array, mouseStates:Array):void {

      // Keyboard
      var player:Entity = this._options.player;
      var component:Object = player.getComponent("Mobile");
      if(component) {
        var y:int = component.dirY;

        if(keyboardStates[Keyboard.UP]) y = -1; 
        else if(y < 0) y = 0; 

        if(keyboardStates[Keyboard.DOWN]) y = 1; 
        else if(y > 0) y = 0; 
      }
      if(component.dirY != y) {
        component.dirY = y;
        var component2:Object  = player.getComponent("Visible");
        if(component2) {
          var animation:String = null;
          switch(y) {
            case -1: animation = "up";break;
            case 1: animation = "down";break;
            default: animation = "pause";break;
          }
          if(animation) { component2.animation.start(animation); }
        }
      }

      // Mouse
      var touch:Touch;
      if(mouseStates[TouchPhase.BEGAN]) {
        touch = mouseStates[TouchPhase.BEGAN];
        //trace("Touch BEGAN at position: " + localPos);
        mouseStates[TouchPhase.BEGAN] = null;
      }
      if(mouseStates[TouchPhase.ENDED]) {
        touch = mouseStates[TouchPhase.ENDED];
        //trace("Touch ENDED at position: " + localPos);

      //} else if(touch.phase == TouchPhase.MOVED) {
      //  trace("Touch MOVED at position: " + localPos);
        mouseStates[TouchPhase.ENDED] = null;
      } 
      if(mouseStates[TouchPhase.HOVER]) {
        touch = mouseStates[TouchPhase.HOVER];
        
        var gid:uint    = this._options.map.pos2gid(touch.globalX, touch.globalY);
        var oldgid:uint = this._options.map.pos2gid(this._options.selectedTile.x, this._options.selectedTile.y);
        if(gid != oldgid) {
          trace("cat: " + gid);
          var pos:Array = this._options.map.gid2pos(gid);
          this._options.selectedTile.x = pos[0];
          this._options.selectedTile.y = pos[1];
        }

        //var buffImg:Image = new Image(ShapeUtil.rectTexture(20, 20, 1, 0x00FF00, true));
        //buffImg.x = i * tileWidth; 
        //buffImg.y = j * tileHeight;
        //this.addChild(buffImg);

        //trace("Touch HOVER at position: " + localPos);
        mouseStates[TouchPhase.HOVER] = null;
      }
    }

    public function handleAI():void {
    }
  }
}
