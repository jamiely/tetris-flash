package ly.jamie.tetris {
  import flash.display.MovieClip;
  public class GameField {
    public var squareSize:Number = 20;
    public var arrBitGameField:Array;
    public var arrGameField:Array;
    public var height:Number=20;
    public var width:Number=10;

    public var gameIsOver:Boolean = false;

    public static var bitEmpty:Number = 0;
    public static var bitFull:Number = 0x3FF

    public var currentBlock:Block;
    public var nextBlock:Block;

    public var paused:Boolean = false;

    public var ticks:Number = 0;

    public var mc:MovieClip = null;
    public var stillProcessing:Boolean = false;
    public var score:Number = 0;

    private var allBlocks:Array;

    public static var gf:GameField = new GameField();

    public function GameField() {
      this.allBlocks = new Array();  // used to destroy blocks

      this.arrBitGameField = new Array(20);
      this.arrGameField = new Array(10);
      for(var i:Number=0; i<this.width; i++) {
        this.arrGameField[i] = new Array(this.height);
      }
      for(i=0; i<this.height; i++) {
        this.arrBitGameField[i] = 0; 
        for(var x:Number=0; x<this.width; x++)
          this.arrGameField[x][i] = null;
      }
      this.score = 0;
    }

    public function isInitialized():Boolean {
      return this.mc != null;
    }

    public function setMovieClip(mc:MovieClip):void {
      this.mc = mc;
    }

    public function start():void {
      if(!this.isInitialized()) return;

      var x:Number = this.width * this.squareSize;
      var y:Number = this.height * this.squareSize;
      with(this.mc.graphics) {
        clear();
        lineStyle (1, 0x000000, 100);
        moveTo(0, 0);
        lineTo(x, 0);
        lineTo(x, y);
        lineTo(0, y);
        lineTo(0, 0);
      }

      for(var i:Number=0; i<this.height; i++) {
        this.arrBitGameField[i] = 0; 
        this.removeLine(i);
      }
      if(this.currentBlock != null) {
        this.currentBlock.destroy();
      }

      for(i=0; i<this.allBlocks.length; i++) {
        this.allBlocks[i].destroy();
      }

      this.currentBlock = this.getRandomBlock(new Point(this.squareSize*2, this.squareSize)); //this.getBlock(new Point(this.squareSize, 0), this.nextBlock.blockType);

      this.stillProcessing = false;
      this.ticks = 0;
      this.score = 0;

      this.gameIsOver = false;
    }

    public function getRandomBlock(location:Point):Block {
      if(!this.isInitialized()) throw new Error("getRandomBlock ERROR");

      var block:Block = new Block(this.mc, location, BlockType.Undefined);
      this.allBlocks.push(block);
      return this.allBlocks[this.allBlocks.length-1];
    }

    public function getBlock(location:Point, blockType:Number):Block {
      if(!this.isInitialized()) trace("getRandomBlock ERROR");
      return new Block(this.mc, location, blockType);
    }

    public function checkLines():Number {
      var checklines_result:Number = 0; 
      var y:Number = this.height - 1;
      while (y >= 0) {
        if(this.arrBitGameField[y] == bitEmpty) {
          y = 0;
        }
        //trace("this.arrBitGameField["+y+"] = " + this.arrBitGameField[y] + " == " + bitFull);
        if(this.arrBitGameField[y] == bitFull) {
          trace("Line " + y + " is full.");
          this.removeLine(y);
          checklines_result++;
          for(var index:Number = y; index>= 0; index--) {
            if( index>0 ) {
              this.arrBitGameField[index] = this.arrBitGameField[index-1];
              for(var x:Number=0; x<this.width; x++) {
                this.arrGameField[x][index] = this.arrGameField[x][index-1];
                if( this.arrGameField[x][index] != null ) {
                  this.arrGameField[x][index].setLocation( 
                    new Point(
                      this.arrGameField[x][index].location.x,
                      this.arrGameField[x][index].location.y + this.squareSize));
                }
              }
            } else {
              this.arrBitGameField[index] = bitEmpty;
              for(x=0; x<this.width; x++) 
                this.arrGameField[x][index] = null;
            }
          }
        } else {
          y--;
        }
      }
      return checklines_result;
    }

    public function removeLine(line:Number):void {
      for(var i:Number=0; i<this.width; i++) {
        if(this.arrGameField[i][line] != null) {
          this.arrGameField[i][line].destroy(); //flashAndDestroy();
          this.arrGameField[i][line] = null;
        }
      }
    }

    /**
     * Call this to increment the field 
     */
    public function gameTick():Number {
      this.ticks++;

      if( this.stillProcessing ) return 0;
      this.stillProcessing = true;
      var erasedLines:Number = 0;
      if( !this.currentBlock.down() ) {
        if( this.currentBlock.top() == 0 ) {
          this.paused = true;
          trace("game over!");
          this.gameIsOver = true;
          this.stillProcessing = false;
          return 0;
        }
        erasedLines = this.checkLines();
        if(erasedLines > 0) {
          this.score += erasedLines;
          // inc score
          // redraw
        }
        currentBlock = this.getRandomBlock(new Point(this.squareSize*2, this.squareSize)); //this.getBlock(new Point(this.squareSize, 0), this.nextBlock.blockType);
      }
      this.stillProcessing = false;
      return erasedLines;
    }
    public function stopBlock(block:Block):void {
      trace("Stopping block: "+ block);
      for(var i:Number=0; i<block.squares.length; i++)
        this.stopSquare(block.squares[i]);
    }
    public function stopSquare(square:Square):void {
      var y:Number = this.normalizeCoordinate(square.location.y);
      var x:Number = this.normalizeCoordinate(square.location.x);
      //trace("arrBitGameField before: "+this.arrBitGameField[y]);
      this.arrBitGameField[y] = this.arrBitGameField[y] | (1<<x);
      //trace("arrBitGameField after: "+this.arrBitGameField[y]);
      this.arrGameField[x][y] = square;
    }
    public function isEmpty(pt:Point):Boolean {
      var x:Number = this.normalizeCoordinate(pt.x);
      var y:Number = this.normalizeCoordinate(pt.y);
      //trace("isEmpty, x="+x + ", y="+y);
      return ! ((arrBitGameField[y] & (1<<x)) != 0 );
    }
    public function areEmpty(pts:Array):Boolean {
      for(var i:Number=0; i<pts.length; i++)
        if( !isEmpty(pts[i]) ) return false;
      return true;
    }
    public function isInBounds(pt:Point):Boolean {
      var x:Number = this.normalizeCoordinate(pt.x);
      var y:Number = this.normalizeCoordinate(pt.y);
      return ! ( (y<0 || y >= this.height) || (x<0 || x >= this.width) );
    }
    public function areInBounds(pts:Array):Boolean {
      for(var i:Number=0; i<pts.length; i++) 
        if( !isInBounds(pts[i]) ) return false;
      return true;
    }
    public function areAtBottom(pts:Array):Boolean {
      var y:Number;
      for(var i:Number=0; i<pts.length; i++) {
        y  = this.normalizeCoordinate(pts[i].y);
        if( y<0 || y >= this.height ) return true;
      }
      return false;
    }
    public function normalizeCoordinate(num:Number):Number {
      return Math.floor(num/this.squareSize);
    }
    public function isGameOver():Boolean {
      return gameIsOver;
    }
  }
}
