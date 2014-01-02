package {
  import net.hires.debug.Stats;

  import starling.core.Starling;

  import flash.display.Sprite;
  import flash.events.Event;

  import flash.net.URLRequest;
  import flash.net.URLLoader;

  import flash.geom.Rectangle;

  [SWF(width="1024", height="800", frameRate="60", backgroundColor="#999999")]
  //[SWF(frameRate="60", backgroundColor="#999999")]
  public class Main extends Sprite {

    protected var _stats:Stats;
    protected var _myStarling:Starling;
    protected var _config:Object;

    public var myLoader:URLLoader;

    public function Main() {
      super();
      this._stats = new Stats();
      this.addChild(this._stats);
      trace("Hello World!");

      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(e:Event):void {
      var myRequest:URLRequest = new URLRequest("data.json");
      myLoader = new URLLoader();
      myLoader.addEventListener(Event.COMPLETE, onload);
      myLoader.load(myRequest);
    }

    // e:flash.event.Event
    public function onload(e:Event):void {
      myLoader.removeEventListener(Event.COMPLETE, onload);

      this._config = JSON.parse(myLoader.data);

      var viewPort:Rectangle = new Rectangle(0, 0, this._config.screen.size[0], this._config.screen.size[1]);
      this._myStarling = new Starling(Game, stage);
      this._myStarling.antiAliasing = 1;
      this._myStarling.start();
      this._myStarling.addEventListener("rootCreated", onRootCreated);
    }

    private function onRootCreated(event:Object, game:Game):void {
      myLoader.removeEventListener("rootCreated", onRootCreated);
      game.start(this._config);
    }
    
  }
}
