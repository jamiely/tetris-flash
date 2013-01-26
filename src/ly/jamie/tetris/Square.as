package ly.jamie.tetris {
  import flash.display.*;
  public class Square {
    public var location:Point;
    //public size:Size;
    public var foreColor:uint;
    public var backColor:uint;
    public var mc:MovieClip

    public function Square(mc:MovieClip, location:Point) {
      this.mc = mc;
      this.location = location;
    }

    public function setLocation(location:Point):void {
      this.location = location;
      this.mc._x = location.x;
      this.mc._y = location.y;
    }

    public function toString():String {
      return location.toString();
    }

    public function destroy():void {
      //this.mc.removeMovieClip();
      this.mc.parent.removeChild(mc);
      delete this;
    }

    public function flashAndDestroy(): void {
      this.mc.onEnterFrame = function():void {
        if(this.count == undefined) this.count = 0;
        this.count++;
        if(this.count % 2 == 0) this._visible = true;
        else this._visible = false;
        if(this.count > 5) this.removeMovieClip();
      }
    }
  }
}
