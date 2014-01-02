package org.incubatio {

  import org.incubatio.SpriteSheet;
  import starling.display.Image;

  public class Animation {

    protected var _xflip:Object;
    protected var _yflip:Object;
    protected var _fps:uint;
    protected var _frameDuration:uint;

    protected var _spriteSheet:SpriteSheet;
    protected var _patterns:Object;

    protected var _currentFrame:uint;
    // TODO: currentFrameDuration is updated via a static number, should be updated via a timer.
    protected var _currentFrameDuration:uint;
    protected var _currentAnimation:String;

    public var image:Image;
    protected var _running:Boolean;

    public function Animation (spriteSheet:SpriteSheet, patterns:Object, options:Object) {
      options = options || {};
      this._spriteSheet = spriteSheet;
      this._patterns = patterns;

      // following fps is the number of time we want the animation to refresh per second. TODO: rename it
      this._fps = options.fps || 60;
      this._xflip = options.xflip || {};
      this._yflip = options.yflip || {};
      this._frameDuration = 1000 / this._fps;


      //this._currentFrame = null;
      this._currentFrameDuration = 0;
      // this._currentAnimation = null;

      this.image = new Image(this._spriteSheet.get(0));
      this._running = false;
    }


    public function open(currentAnimation:String):void { this._currentAnimation = currentAnimation; } 

    public function start(animName:String):Animation {
      trace("test ?");
      this.open(animName);
      this.reset(true);
      return this;
    }

    public function reset(running:Boolean = false):Animation {
      this._running = running;
      if(this._patterns[this._currentAnimation]) {
        this._currentFrame = this._patterns[this._currentAnimation][0];
        this._currentFrameDuration = 0;
        this._update(0);
      }
      return this;
    }

    public function pause():Animation {
      this._running = false;
      return this;
    }

    public function play():Animation {
      this._running = true;
      return this;
    }

    public function update(ms:uint = 30):Image {
      if (this._running) this._update(ms);
      return this.image;
    }

    protected function _update(ms:uint): void {
      if (!this._currentAnimation)
        throw new Error("No animation started. open(\"an animation\") or start(\"an animation\") before updating")

      var xflip:Boolean = false;
      var yflip:Boolean = false;

      this._currentFrameDuration += ms;
      if (this._currentFrameDuration >= this._frameDuration) {
        this._currentFrameDuration = 0;

        // Animation pattern Params
        var anim:Array = this._patterns[this._currentAnimation];
        /* start     = anim[0],
         * end       = anim[1],
         * isLooping = anim[2] */

        // if Animation finished
        if (anim.length == 1 || this._currentFrame == anim[1]) {
          // looping is considered as true if null (animation loops by default)
          if (anim[2] != false) { this._currentFrame = anim[0]; }
        } else { anim[0] < anim[1] ? this._currentFrame++ : this._currentFrame--; }
      }

      var image:Image = new Image(this._spriteSheet.get(this._currentFrame));

      // TODO: put flipped images in cache

      // TODO: I don't know how to flip image with starling yet
      // if(this._xflip[this._currentAnimation]) xflip = true
      // if(this._yflip[this._currentAnimation]) yflip = true
      // if(xflip || yflip) image = Transform.flip(image, xflip, yflip)
      this.image = image;
    }

    public function getCurrentFrame():uint {
      return this._currentFrame;
    }

    public function getCurrentAnimation():String {
      return this._currentAnimation;
    }

    public function isRunning():Boolean {
      return this._running;
    }
  }

}
