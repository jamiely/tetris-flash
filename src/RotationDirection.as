class RotationDirection {
	public static var NORTH:Number = 1;
	public static var EAST:Number = 2;
	public static var SOUTH:Number = 3;
	public static var WEST:Number = 4;

	public static function clockwise(dir:Number) {
		dir++;
		if(dir > 4) dir = 1;
		return dir;
	}
	public static function counterClockwise(dir:Number) {
		dir--;
		if(dir < 1) dir = 4;
		return dir;
	}
}