package ly.jamie.tetris {
  import flash.geom.Point;
  import flash.display.MovieClip;
  import flash.text.*;
  import flash.events.*;

  public class Game extends MovieClip {
    private var focusEnabled:Boolean = true;
    private var gf:GameField;
    private var gfmc:MovieClip;
    private var sd:MovieClip;
    private var ei:MovieClip;
    private var startingspeed:Number;
    private var speed:Number;
    private var clock:Number;
    private var lines:Number;
    private var score:Number;
    private var sc:ScoreKeeper;
    private var showScores:Function;
    private var restart:Function;
    private var txtDebug:TextField = null;

    private function debug(msg:String):void {
      if(this.txtDebug == null) {
        // create a debug text field
        this.txtDebug = new TextField();
        this.txtDebug.width = 500;
        this.txtDebug.x = 0;
        this.txtDebug.y = 300;
        this.addChild(this.txtDebug);
      }
      this.txtDebug.text = msg + "\n" + this.txtDebug.text;
    }
    function Game() {
      try {
        this.initialize();
      }
      catch(ex:Object) {
        debug("Problem initializing game: " + ex.message + 
          "\n" + ex.stacktrace);
      }
    }
    private function drawBackground(mc: MovieClip, fillColor:uint): void {
      mc.graphics.beginFill(fillColor);
      mc.graphics.drawRect(0, 0, 100, 80);
      mc.graphics.endFill();
    }
    private function initialize():void {
      debug("Game initializing");

      // helps to see
      this.opaqueBackground = 0x00ff00;

      //Selection.setFocus(this);

      // Singleton 
      this.gf = GameField.gf;
      debug("Game field created.");
      this.gfmc = new MovieClip();
      this.gfmc.name = "mcGamefield";
      this.gfmc.x = 0;
      this.gfmc.y = 0;
      this.drawBackground(this.gfmc, 0x0000ff);
      this.addChild(this.gfmc);
      debug("Game field movie clip added");

      // score pane
      this.sd = new MovieClip();
      this.addChild(this.sd);
      this.sd.x = 100;
      this.sd.y = 0;
      this.drawBackground(this.sd, 0xff0000);
      this.sd.name = "mcScore";
      this.sd._visible = false;
      this.sd._x = 2;
      this.sd._y = 2;
      debug("Score pane created");

      // enter initials pane
      this.ei = new MovieClip();
      this.addChild(this.ei);
      this.ei.name = "mcEnterInitials";
      this.ei._visible = true;
      this.ei._x = 2;
      this.ei._y = 22;
      //Selection.setFocus(this.mcEnterInitials.txtInitials);
      debug("Initials pane created");

      this.gf.setMovieClip(this.gfmc);
      this.gf.start();
      debug("Game started");
      this.startingspeed = 10;
      this.speed = this.startingspeed;
      this.clock = 0;
      this.score = 0;
      this.lines = 0;

      this.sc = new ScoreKeeper("tetris", "http://www.angelforge.com/flash/tetris/class/ScoreKeeper.php", "b");


      this.showScores = function():void {
        var scores:Array = sc.getScores();
        this.sd.txtScores.text = "";
        for(var i:Number=0; i<scores.length; i++) {
          //trace(scores[i].name + " " + scores[i].score);
          this.sd.txtScores.text += "\n" + scores[i].name + " " + scores[i].score;
        }
        this.sd._visible = true;
      }

      var run:Function = function():void {
        if(this.gf.isGameOver()) {
          this.paused = true;
          if(this.sc.isReady) {
            if(!this.ei._visible && this.sc.scores[this.sc.scores.length-1].score < this.score) { // enter high score
              this.ei.show();
            } else if(!this.ei._visible) {
              this.showScores();
              this.removeEventListener(Event.ENTER_FRAME, run);
            }
          }
        }
        if(!this.paused) this.clock++; // increment clock if game is not paused
        if(this.clock >= this.speed) { // if the clock ticks are greater than the speed
          var num:Number = this.gf.gameTick(); // play 1 frame, 1 tick
          this.lines += num; // increment the total number of lines cleared
          var multiplier:Number = (this.startingspeed - this.speed); // multiply lines by this
          if(multiplier < 1) multiplier = 1; // make sure multiplier is at least 1
          if(num > 0) this.score += multiplier * num * num; // modify score
          this.erasedLines.text = StringUtils.zeroPad(new String(this.score), 5); // display score
          //trace(this.gf.score);
          this.clock = 0; // reset clock
        }
        var temp:Number = this.startingspeed - this.lines / 10;
        this.speed = (temp > 0) ? Math.floor(temp) : 0;
      }

      this.restart = function(): void {
          this.gf.start();
          this.sd._visible = false;
          this.speed = this.startingspeed;
          this.clock = 0;
          this.score = 0;
          this.lines = 0;
          this.addEventListener(Event.ENTER_FRAME, run);
          this.paused = false;
      }

      this.addEventListener(Event.ENTER_FRAME, run);

/*

      this.keylistener = new Object();
      this.keylistener.mc = this;
      Key.addListener(this.keylistener);

      this.keylistener.onKeyDown = function() {
        if(! this.mc.paused) {
          switch(Key.getCode()) {
            case Key.DOWN:
              this.mc.gf.currentBlock.down();
              break;
            case Key.RIGHT:
              this.mc.gf.currentBlock.right();
              break;
            case Key.LEFT:
              this.mc.gf.currentBlock.left();
              break;
            case Key.CONTROL:
              this.mc.gf.currentBlock.rotate(true);
              break;
            case Key.UP:
              this.mc.gf.currentBlock.rotate(false);
              break;
            case Key.SPACE:
              while(this.mc.gf.currentBlock.down()) {
              }
              break;
            case 80: case 112: // p
              trace("pause");
              this.mc.paused = ! this.mc.paused;
              break;
            case Key.HOME:
              this.mc.restart();
              break;
          }
        } else {
          switch(Key.getCode()) {
            case 80: case 112: // p
              trace("pause");
              this.mc.paused = ! this.mc.paused;
          }
        }
      }
*/

/*
      btnStart.onPress = function() {
        this._parent.restart();
        this._visible = false;
      }
*/
    }
  }
}

