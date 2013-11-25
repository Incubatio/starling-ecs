package org.incubatio {
  public class EventObject {
    protected var _events: Array;

    public function on(name:String, cb:Function) :  void {
      if(!this._events) this._events = [];
      if(!this._events[name]) this._events[name] = [];
      this._events[name].push(cb);
    }

    public function off(name:String): void {
     if(this._events) this._events.remove(name);
    }

    public function trigger(name:String, argv:Object = null): void {
      if(argv == null) argv = new Object();
      if(this._events && this._events[name]) {
        for each(var cb:Function in this._events[name]) {
          cb({name: name, ctx: this, params: argv})
        }
      }
    }
  }
}
