/**
 * ScoreKeeper.as
 * 
 * Score files use the extension ".scores"
 *
 * 
 *
 * Query String variables
 *  game			specify the name of the game.
 *  scores		comma-delimited list of <name:score> pairs. the names
 *						and scores are colon-delimited.
 *  success   returned by server.  options ('yes', 'no')
 *  mode			options('addScores', 'getScores');
 *  password  supply a password if server requires it
 *  errorMsg  returned by server in case of error
 */

package ly.jamie.tetris {
  public class ScoreKeeper {
    //var lv:LoadVars;
    private var lv:Object;
    private var serverString:String;
    private var scores:Array;
    private var isReady:Boolean = false;
    public function ScoreKeeper(gameName:String, serverString:String, password:String) {
      return;
      //this.lv = new LoadVars();
      this.lv._parent = this;
      this.lv.game = gameName;
      this.lv.password = password;
      this.serverString = serverString;
      this.lv.onLoad = function(success:Object): void {
        trace("Loaded? " + success);
        for(var item:Object in this) {
          trace(item + "=" + this[item]);
        }

        this.loading = false;

        /**
         * Should return array of objects of form
         *  var object1.name:String = "JAL"
         *  var object2.score:Number = 50000;
         *  var array:Array = {object1, object2, object3, ...}
         */

        // package received variables
        var name_score_pairs:Array; // used to process text
        name_score_pairs = this.scores.split(","); // split according to comma
        
        this._parent.scores = new Array();
        
        var tmpScore:Array;
        var ob:Object; // uesd for temporary storage

        for(var i:Number=0; i<name_score_pairs.length; i++) {
          tmpScore = name_score_pairs[i].split(":"); // colon-delimited
          ob = new Object();
          ob.name = tmpScore[0];
          ob.score = tmpScore[1];
          this._parent.scores.push(ob);
        }

        this._parent.isReady = true;
      }
      
      this.lv.mode = "getScores";
      this.lv.sendAndLoad(this.getServerURL(), this.lv, "GET");
        
    }

    /**
     * Add an array of scores
     *
     * Query String Variables
     * success   Returned with either 'yes' or 'no'
     * mode      addScore
     *
     */
    public function addScores(scores:Array):Boolean {
      return false;
      // build scores string
      var strScores:Array = new Array();
      for(var i:Number=0; i<scores.length; i++)
        strScores.push(scores[i].name + ":" + scores[i].score);
      this.lv.scores = strScores.join(",");
      this.lv.mode = "addScores";
      // this.lv.game // should already be set

      this.lv.sendAndLoad(this.getServerURL(), this.lv, "POST");
      this.lv.loading = true;

      return this.lv.success == "yes";
    }

    public function getServerURL():String {
      return this.serverString;
    }
    public function getScores():Array {
      return this.scores;
    }
  }
}
