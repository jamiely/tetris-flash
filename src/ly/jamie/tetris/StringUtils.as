package ly.jamie.tetris {
  public class StringUtils {
    public static function zeroPad(str:String, len:Number):String {
      while(str.length < len) {
        str = "0" + str;
      }
      return str;
    }
  }
}

