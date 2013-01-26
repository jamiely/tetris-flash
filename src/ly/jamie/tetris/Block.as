package ly.jamie.tetris {
  import flash.display.MovieClip;
  public class Block extends MovieClip {
    public var sq1:Square;
    public var sq2:Square;
    public var sq3:Square;
    public var sq4:Square;
    public var squares:Array;
    public var blockType:Number;
    private var squareSize:Number = 20;
    private var rotationDirection:Number = RotationDirection.NORTH;
    public var mc:MovieClip;

    private function squareMC(color:uint): MovieClip {
      var mc:MovieClip = new MovieClip();
      mc.graphics.beginFill(color);
      mc.graphics.drawRect(0, 0, this.squareSize, this.squareSize);
      mc.graphics.endFill();
      return mc;
    }
    public function Block(mc:MovieClip, location:Point, blockType:Number) {
      this.mc = mc;

      var depth:Number = this.mc.numChildren;
      var colors:Array = new Array(0x000000, 0xff0000, 0xffff00, 0x00ffff, 0xff00ff, 0x0000ff, 0x00ff00);
      var color:uint = colors[Math.floor(Math.random() * colors.length)];

      this.sq1 = new Square(this.mc.addChild(this.squareMC(color)) as MovieClip, location);
      this.sq2 = new Square(this.mc.addChild(this.squareMC(color)) as MovieClip, location);
      this.sq3 = new Square(this.mc.addChild(this.squareMC(color)) as MovieClip, location);
      this.sq4 = new Square(this.mc.addChild(this.squareMC(color)) as MovieClip, location);

      this.squares = [this.sq1, this.sq2, this.sq3, this.sq4];
      for (var i:Number=0; i<this.squares.length; i++) {
        this.squares[i].mc.height = squareSize;
        this.squares[i].mc.width = squareSize;
      }

      this.rotationDirection = RotationDirection.NORTH;
      
      if(blockType == BlockType.Undefined)
        blockType = BlockType.getRandomType();

      this.blockType = blockType;
      trace("Block type: "+blockType);
      switch(blockType) {
        case BlockType.Square:
          this.createSquare(location); 
          break;
        case BlockType.Line:
          this.createLine(location, RotationDirection.NORTH);
          break;
        case BlockType.J:
          this.createJ(location, RotationDirection.NORTH);
          break;
        case BlockType.L:
          this.createL(location, RotationDirection.NORTH);
          break;
        case BlockType.T:
          this.createT(location, RotationDirection.NORTH);
          break;
        case BlockType.Z:
          this.createZ(location, RotationDirection.NORTH);
          break;
        case BlockType.S:
          this.createS(location, RotationDirection.NORTH);
          break;
        default:
          trace("INVALID BLOCKTYPE:" + blockType);
      }
      //trace("Block created.");
    }

    public function traceBlockPositions():void {
      for(var i:Number=0; i<this.squares.length; i++) 
        trace(this.squares[i].location.x + ", " + this.squares[i].location.y);
    }
    
    public function down():Boolean {
      //trace("Down");
      var pt:Point;

      var newPoints:Array = new Array();
      var loc:String = "";
      for(var i:Number=0; i<this.squares.length; i++) {
        pt = this.moveDown(this.squares[i].location);
        //trace("this.squares[i].location = " + this.squares[i].location);
        //trace("pt = " + pt);
        newPoints[i] = pt;
        //loc += " ("+pt.x +", " + pt.y + ")";
      }

      if(GameField.gf.areAtBottom(newPoints)) {
        GameField.gf.stopBlock(this);
      } else if(!GameField.gf.areInBounds(newPoints)) {
        //trace("Out of bounds.");
        return false;
      } else if(GameField.gf.areEmpty(newPoints)) { //this.blockPositionIsValid(newPoints)) 
        this.setLocations(newPoints);
        return true;
      } else {
        //trace("block positions not empty: "+ loc);
        GameField.gf.stopBlock(this);
        return false;
      }

      return false;
    }
    public function blockPositionIsValid(newPoints:Array):Boolean {
      var isEmpty:Boolean = true;
      var newPoint:Point;
      for(var i:Number=0; i<newPoints.length; i++) {
        //locs += " (" + newPoint.x + ", " + locations[i].y + ")";
        isEmpty = isEmpty && GameField.gf.isEmpty(newPoints[i]);
      }
      return isEmpty;
    }
    public function right():Boolean {
      var newPoints:Array = new Array(4);
      for(var i:Number=0; i<this.squares.length; i++) 
        newPoints[i] = this.moveRight(this.squares[i].location);


      if(!GameField.gf.areInBounds(newPoints)) {
        trace("Out of bounds.");
        return false;
      } else if(GameField.gf.areEmpty(newPoints)) { //this.blockPositionIsValid(newPoints)) 
        this.setLocations(newPoints);
        return true;
      } /*else {
        trace("block positions not empty: "+ loc);
        GameField.gf.stopBlock(this);
        return false;
      }*/
      return false;
    }

    public function left():Boolean {
      var newPoints:Array = new Array(4);
      for(var i:Number=0; i<this.squares.length; i++) 
        newPoints[i] = this.moveLeft(this.squares[i].location);

      //if(newPoints.length < 4) trace("Left");		
      if(!GameField.gf.areInBounds(newPoints)) {
        trace("Out of bounds.");
        return false;
      } else if(GameField.gf.areEmpty(newPoints)) { //this.blockPositionIsValid(newPoints)) 
        this.setLocations(newPoints);
        return true;
      } 
      return false;
    }

    public function rotate(clockWise:Boolean):Boolean {
      var oldLocations:Array = new Array(4);
      var rotation:Number = (clockWise)? 
        RotationDirection.clockwise(rotationDirection) :
        RotationDirection.counterClockwise(rotationDirection);

      for(var i:Number=0; i<this.squares.length; i++) 
        oldLocations[i] = this.squares[i].location;

      var location:Point = this.sq2.location;

      switch(blockType) {
        case BlockType.Square:
          this.createSquare(this.sq1.location); 
          break;
        case BlockType.Line:
          this.createLine(location, rotation);
          break;
        case BlockType.J:
          this.createJ(location, rotation);
          break;
        case BlockType.L:
          this.createL(location, rotation);
          break;
        case BlockType.T:
          this.createT(location, rotation);
          break;
        case BlockType.Z:
          this.createZ(location, rotation);
          break;
        case BlockType.S:
          this.createS(location, rotation);
          break;
      }
      
      var newLocations:Array = new Array(4);
      for(i=0;i<this.squares.length; i++) 
        newLocations[i] = this.squares[i].location;

      if(GameField.gf.areEmpty(newLocations) && GameField.gf.areInBounds(newLocations)) {//this.blockPositionIsValid(newLocations)) 
        this.rotationDirection = rotation;
        return true;
      }
      else { // restore old points
        this.setLocations(oldLocations)
      }

      return false;
    }

    /**
     *  13
     *  24
     */
    public function createSquare(location:Point):void {
      this.sq1.setLocation(new Point(location.x, location.y));
      this.sq2.setLocation(new Point(location.x, location.y + squareSize));
      this.sq3.setLocation(new Point(location.x + squareSize, location.y));
      this.sq4.setLocation(new Point(location.x + squareSize, location.y + squareSize));
    }

    /**
     *  1
     *  2       1234
     *  3
     *  4
     */
    public function createLine(location:Point, rotationDirection:Number):void {
      var locations:Array;
      switch(rotationDirection) {
        case RotationDirection.NORTH: case RotationDirection.SOUTH:
          locations = new Array(
            new Point(location.x, location.y - squareSize),
            new Point(location.x, location.y),
            new Point(location.x, location.y + squareSize),
            new Point(location.x, location.y + 2*squareSize));
          break;
        case RotationDirection.WEST: case RotationDirection.EAST: default:
          locations = new Array(
            new Point(location.x - squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x + squareSize, location.y),
            new Point(location.x + 2*squareSize, location.y));
          break;
      }
      if(locations.length < 4) trace("Line");
      this.setLocations(locations);
    }
    
    /**
     *  1      4        34
     *  2      321      2       123
     * 43               1         4
     */
    public function createJ(location:Point, rotationDirection:Number):void {
      var locations:Array;
      switch(rotationDirection) {
        case RotationDirection.NORTH:
          locations = new Array(
            new Point(location.x, location.y - squareSize),
            new Point(location.x, location.y),
            new Point(location.x, location.y + squareSize),
            new Point(location.x - squareSize, location.y + squareSize));
          break;
        case RotationDirection.EAST:
          locations = new Array(
            new Point(location.x + squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x - squareSize, location.y),
            new Point(location.x - squareSize, location.y - squareSize));
          break;
        case RotationDirection.SOUTH:
          locations = new Array(
            new Point(location.x, location.y + squareSize),
            new Point(location.x, location.y),
            new Point(location.x, location.y - squareSize),
            new Point(location.x + squareSize, location.y - squareSize));
          break;
        case RotationDirection.WEST: default:
          locations = new Array(
            new Point(location.x - squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x + squareSize, location.y),
            new Point(location.x + squareSize, location.y + squareSize));
      }
      if(locations.length < 4) trace("J");
      this.setLocations(locations);
    }

    /**
     *  1          43      4
     *  2    321    2    123
     *  34   4      1
     */
    public function createL(location:Point, rotationDirection:Number):void {
      var locations:Array;
      switch(rotationDirection) {
        case RotationDirection.NORTH:
          locations = new Array(
            new Point(location.x, location.y - squareSize),
            new Point(location.x, location.y),
            new Point(location.x, location.y + squareSize),
            new Point(location.x + squareSize, location.y + squareSize)					);
          break;
        case RotationDirection.EAST:
          locations = new Array(
            new Point(location.x + squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x - squareSize, location.y),
            new Point(location.x - squareSize, location.y + squareSize));
          break;
        case RotationDirection.SOUTH:
          locations = new Array(
            new Point(location.x, location.y + squareSize),
            new Point(location.x, location.y),
            new Point(location.x, location.y - squareSize),
            new Point(location.x - squareSize, location.y - squareSize));
          break;
        default: case RotationDirection.WEST:
          locations = new Array(
            new Point(location.x - squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x + squareSize, location.y),
            new Point(location.x + squareSize, location.y - squareSize));
      }
      if(locations.length < 4) trace("L");
      this.setLocations(locations);
    }

    /**
     * Rotating clock-wise around the 2.
     *   1     3            4
     *  324    21   423    12
     *         4     1      3
     */
    public function createT(location:Point, rotationDirection:Number):void {
      var locations:Array;
      switch(rotationDirection) {
        case RotationDirection.NORTH: 
          locations = new Array(
            new Point(location.x, location.y - squareSize),
            new Point(location.x, location.y),
            new Point(location.x - squareSize, location.y),
            new Point(location.x + squareSize, location.y));
          break;
        case RotationDirection.EAST:
          locations = new Array(
            new Point(location.x + squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x, location.y - squareSize),
            new Point(location.x, location.y + squareSize));
          break;
        case RotationDirection.SOUTH: 
          locations = new Array(
            new Point(location.x, location.y + squareSize), 
            new Point(location.x, location.y),
            new Point(location.x + squareSize, location.y),
            new Point(location.x - squareSize, location.y));
          break;
        default: case RotationDirection.WEST:
          locations = new Array(
            new Point(location.x - squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x, location.y + squareSize),
            new Point(location.x, location.y - squareSize));
          break;
      }
      if(locations.length < 4) trace("T");
      this.setLocations(locations);
    }
    
    /**
     *   1
     *  23     42
     *  4       31
     *   
     */
    public function createZ(location:Point, rotationDirection:Number):void {
      var locations:Array;
      switch(rotationDirection) {
        case RotationDirection.NORTH: case RotationDirection.SOUTH:	
          locations = new Array(
            new Point(location.x + squareSize, location.y - squareSize),
            new Point(location.x, location.y),
            new Point(location.x + squareSize, location.y),
            new Point(location.x, location.y + squareSize));
          break;
        case RotationDirection.WEST: case RotationDirection.EAST:
          locations = new Array(
            new Point(location.x + squareSize, location.y + squareSize),
            new Point(location.x, location.y),
            new Point(location.x, location.y + squareSize),
            new Point(location.x - squareSize, location.y));
      }
      if(locations.length < 4) trace("Z");
      this.setLocations(locations);
    }

    /**
     * Pivots around number 2.
     *  1           4     34
     *  23     21   32   12
     *   4    43     1    
     */
    public function createS(location:Point, rotationDirection:Number):void {
      var locations:Array;
      switch(rotationDirection) {
        case RotationDirection.SOUTH: case RotationDirection.NORTH:
          locations = new Array(new Point(location.x, location.y - squareSize),
            new Point(location.x, location.y),
            new Point(location.x + squareSize, location.y),
            new Point(location.x + squareSize, location.y + squareSize));
          break;
        case RotationDirection.WEST: case RotationDirection.EAST:
          locations = new Array(new Point(location.x + squareSize, location.y),
            new Point(location.x, location.y),
            new Point(location.x, location.y + squareSize),
            new Point(location.x - squareSize, location.y + squareSize));
          break;
        /**case RotationDirection:SOUTH:
          locations = new Array(
            new Point(location.x, location.y + squareSize),
            new Point(location.x, location.y),
            new Point(location.x - squareSize, location.y),
            new Point(location.x - squareSize, location.y - squareSize));
          break;*/
      }
      if(locations.length < 4) trace("S");
      this.setLocations(locations);
    }

    public function setLocations(locations:Array):void {
      if(locations.length == 4) {
        for(var i:Number = 0; i<this.squares.length; i++) {
          this.squares[i].setLocation(locations[i]);
        }
      } else {
        trace("Could not set locations.  Only recieved " + locations.length + " points.");
      }
    }
    public function stopSquares(): void {
      for(var i:Number = 0; i<this.squares.length; i++)
        GameField.gf.stopSquare(this.squares[i]);
    }

    public function moveLeft(pt:Point):Point {
      var return_point:Point = new Point(pt.x - squareSize, pt.y);
      return return_point;
    }
    public function moveRight(pt:Point): Point {
      var return_point:Point = new Point(pt.x + squareSize, pt.y);
      return return_point;
    }
    public function moveDown(pt:Point):Point {
      return new Point(pt.x, pt.y + squareSize);
    }

    public function top():Number {
      var topPoint:Number = 10000;
      for(var i:Number = 0; i<this.squares.length; i++) 
        topPoint = Math.min(topPoint, this.squares[i].location.y);
      return topPoint;
    }
    public function destroy():void {
      for(var i:Number=0; i<this.squares.length; i++) {
        if(this.squares[i] != null) 
          this.squares[i].destroy();
      }
      delete this;
    }
    override public function toString():String {
      var returnString:String = "Block";
      for(var i:Number=0;i<this.squares.length; i++) {
        returnString += "\t" + this.squares[i].toString() + "\n";
      }
      return returnString;
    }
  }
}
