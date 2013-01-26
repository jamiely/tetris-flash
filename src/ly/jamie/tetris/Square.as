package ly.jamie.tetris {
  import flash.display.*;
  import flash.events.*;
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
      this.mc.x = location.x;
      this.mc.y = location.y;
    }

    public function toString():String {
      return location.toString();
    }

    public function destroy():void {
      //this.mc.removeMovieClip();
      this.mc.parent.removeChild(mc);
      delete this;
    }
  }
}
