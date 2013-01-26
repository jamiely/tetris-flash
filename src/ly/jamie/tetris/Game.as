package ly.jamie.tetris {
  import flash.geom.Point;
  import flash.display.MovieClip;
  import flash.text.*;
  import flash.events.*;
  import flash.ui.*;

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
    private var txtDebug:TextField = null;
    private var paused:Boolean = false;
    private var erasedLines: TextField = null;
    private var txtInstructions: TextField = null;
    private var txtScore: TextField = null;
    private var tryRun: Function;

    private function setScore(score:Number): void {
      this.score = score;
      this.txtScore.text = StringUtils.zeroPad(new String(score), 6); // display score
    }

    private function tearDown():void {
      debug("TEARDOWN");
      this.removeEventListener(Event.ENTER_FRAME, this.tryRun);
    }

    private function debug(msg:String):void {
      if(this.txtDebug == null) {
        // create a debug text field
        this.txtDebug = new TextField();
        this.txtDebug.width = 400;
        this.txtDebug.opaqueBackground = 0xCCCCCC;
        this.txtDebug.x = 200;
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
          "\n" + ex.getStackTrace());
      }
    }
    private function drawBackground(mc: MovieClip, 
      fillColor:uint, width:Number=100, height:Number=80): void {

      mc.graphics.beginFill(fillColor);
      mc.graphics.drawRect(0, 0, width, height);
      mc.graphics.endFill();
    }
    private function setupMovieclips(): void {
      // instructions
      this.txtInstructions = new TextField();
      this.txtInstructions.width = 400;
      this.txtInstructions.opaqueBackground = 0xCCCCCC;
      this.txtInstructions.x = 200;
      this.txtInstructions.y = 100;
      this.txtInstructions.text = "Instructions\n* Left,Right - move a block \n* CTRL,UP - rotate a block \n* Spacebar - Fast drop a block \n* HOME,ENTER - Restart"
      this.addChild(this.txtInstructions);
      
      this.erasedLines = new TextField();
      this.erasedLines.x = 400;
      this.erasedLines.width = 200;
      this.addChild(this.erasedLines);

      //Selection.setFocus(this);

      // Singleton 
      this.gfmc = new MovieClip();
      this.gfmc.name = "mcGamefield";
      this.drawBackground(this.gfmc, 0x0000ff, 200, 300);
      this.addChild(this.gfmc);

      // score pane
      this.sd = new MovieClip();
      this.sd.x = 200;
      this.sd.y = 0;
      this.sd.name = "mcScore";
      this.addChild(this.sd);
      this.txtScore = new TextField();
      this.txtScore.width = 200;
      this.txtScore.x = 0;
      this.txtScore.y = 0;
      this.txtScore.text = "Score\n* Left,Right - move a block \n* CTRL,UP - rotate a block \n* Spacebar - Fast drop a block \n* HOME,ENTER - Restart"
      this.txtScore.defaultTextFormat = new TextFormat('Verdana',40,0x000000);
      this.sd.addChild(this.txtScore);
      debug("Score pane created");

      // enter initials pane
      this.ei = new MovieClip();
      this.addChild(this.ei);
      this.ei.name = "mcEnterInitials";
      this.ei.visible = true;
      this.ei.x = 2;
      this.ei.y = 22;
      debug("Initials pane created");
    }
    private function resetClockAndScore(): void {
      this.clock = 0;
      this.setScore(0);
      this.lines = 0;
    }
    private function initialize():void {
      debug("Game initializing");

      this.opaqueBackground = 0xEEEEEE;

      this.setupMovieclips();
      this.gf = GameField.gf;
      this.gf.setMovieClip(this.gfmc);
      this.gf.start();
      debug("Game started");

      this.startingspeed = 10;
      this.speed = this.startingspeed;
      this.resetClockAndScore();
      debug("Clock setup")

      this.sc = new ScoreKeeper("tetris", "http://www.angelforge.com/flash/tetris/class/ScoreKeeper.php", "b");
      debug("Score keeper setup")

      var self:Object = this;
      this.tryRun = function():void {
        try {
          self.runGameLoop.call(self);
        }
        catch(ex:Object) {
          debug("Problem running: " + ex.message + "\n" + ex.getStackTrace());
        }
      }
      this.addEventListener(Event.ENTER_FRAME, this.tryRun);

      this.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
        try { 
          self.onKeyDown.call(self, e);
        }
        catch(ex:Object) {
          debug("Problem executing key event: " + ex.message + 
            "\n" + ex.getStackTrace());
        }
      });
    }

    private function restart(): void {
        this.tearDown();
        debug("RESTART");
        var self:Object = this;
        this.gf.debug = function(msg:String):void {
          self.debug(msg);
        };
        debug("This gf=" + this.gf);
        this.gf.start();
        debug("Start game field");
        this.sd.visible = false;
        this.speed = this.startingspeed;
        this.resetClockAndScore();
        debug("Reset clock");
        this.addEventListener(Event.ENTER_FRAME, this.tryRun);
        debug("Add listener");
        this.paused = false;
    }

    private function onKeyDown(e:KeyboardEvent): void {
      var KEY_P:Number = 80;

      var code:Number = e.keyCode;
      debug("Key event! " + code);

      switch(code) {
        case Keyboard.HOME: case Keyboard.ENTER:
          this.restart();
          return;
      }

      if(!this.paused) { // ! paused
        switch(code) {
          case Keyboard.DOWN:
            debug("Down");
            this.gf.currentBlock.down();
            break;
          case Keyboard.RIGHT:
            debug("Right");
            this.gf.currentBlock.right();
            break;
          case Keyboard.LEFT:
            debug("Left");
            this.gf.currentBlock.left();
            break;
          case Keyboard.CONTROL:
            this.gf.currentBlock.rotate(true);
            break;
          case Keyboard.UP:
            debug("Up");
            this.gf.currentBlock.rotate(false);
            break;
          case Keyboard.SPACE:
            while(this.gf.currentBlock.down()) {
            }
            break;
          case KEY_P:
            debug("PAUSE");
            this.paused = true;
            break;
        }
      } else { // Paused
        switch(code) {
          case KEY_P:
            debug("UNPAUSE");
            this.paused = false;
            break;
        }
      }
    }

    private function showScores(): void {
      var scores:Array = sc.getScores();
      this.sd.txtScores.text = "";
      for(var i:Number=0; i<scores.length; i++) {
        //trace(scores[i].name + " " + scores[i].score);
        this.sd.txtScores.text += "\n" + scores[i].name + " " + scores[i].score;
      }
      this.sd.visible = true;
    }

    /// The game loop
    private function runGameLoop(): void {
      // adfiodso
      if(this.gf.isGameOver()) {
        debug("Game over");
        this.paused = true;
        if(this.sc.isReady) {
          if(!this.ei.visible && this.sc.scores[this.sc.scores.length-1].score < this.score) { // enter high score
            this.ei.show();
          } else if(!this.ei.visible) {
            this.showScores();
            this.tearDown();
          }
        }
      }
      if(!this.paused) this.clock++; // increment clock if game is not paused
      if(this.clock >= this.speed) { // if the clock ticks are greater than the speed
        var num:Number = this.gf.gameTick(); // play 1 frame, 1 tick
        this.lines += num; // increment the total number of lines cleared
        var multiplier:Number = (this.startingspeed - this.speed); // multiply lines by this
        if(multiplier < 1) multiplier = 1; // make sure multiplier is at least 1
        if(num > 0) {
          this.setScore(this.score + 100 * multiplier * num * num); // modify score
        }
        this.erasedLines.text = StringUtils.zeroPad(new String(this.lines), 4); // display score
        this.clock = 0; // reset clock
      }
      var temp:Number = this.startingspeed - this.lines / 10;
      this.speed = (temp > 0) ? Math.floor(temp) : 0;
    }
  }
}

