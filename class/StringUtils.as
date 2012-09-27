class StringUtils {
	public static function zeroPad(str:String, len:Number) {
		while(str.length < len) {
			str = "0" + str;
		}
		return str;
	}
}