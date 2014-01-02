package {
  import flash.ui.Keyboard;
  import org.incubatio.Entity;
  public class Director {

    protected var _options:Object;

    public var groups:Array = new Array();

    public function Director(options:Object) {
      this._options = options;
    }

    public function handleInput(states:Array):void {
      var player:Entity = this._options.player;
      var component:Object = player.getComponent("Mobile");
      if(component) {
          var y:int = component.dirY;

          if(states[Keyboard.UP]) y = -1; 
          else if(y < 0) y = 0; 

          if(states[Keyboard.DOWN]) y = 1; 
          else if(y > 0) y = 0; 
      }
      if(component.dirY != y) {
        component.dirY = y;
        var component2:Object  = player.getComponent("Visible");
        var animation:String = null;
        switch(y) {
          case -1: animation = "up";break;
          case 1: animation = "down";break;
          default: animation = "pause";break;
        }
        if(animation) { component2.animation.start(animation); }
      }
    }

    public function handleInput2(inputEvents:Array):void {
      var player:Entity = this._options.player;
      var component:Object = player.getComponent("Mobile");
      if(component) {
        //for each(var e:Object in inputEvents) {
        var y:int = component.dirY;
        while(inputEvents.length > 0) {
          var e:Object = inputEvents.pop();

          switch(e.type) {

            case "touch": 
              break;


            case "keyUp":
              switch(e.keyCode) {
                case Keyboard.UP:   if(y < 0) y = 0; break;
                case Keyboard.DOWN: if(y > 0) y = 0; break;
              }
              break;

            case "keyDown":
              //Sometime a keyUp happens just after a keyDown, dafuk ?

              switch(e.keyCode) {
                case Keyboard.UP: y = -1; break;
                case Keyboard.DOWN: y = 1; break;
              }
              break;

            default: trace("Unexeptected inputEvent device: " + e.type);
          }
          component.dirY = y;
        }
      }
    }

    public function handleAI():void {
    }
  }
}
