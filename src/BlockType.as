class BlockType {
	public static var Undefined:Number = 0;
	public static var Square:Number = 1;
	public static var Line:Number = 2;
	public static var J:Number = 3;
	public static var L:Number = 4;
	public static var T:Number = 5;
	public static var Z:Number = 6;
	public static var S:Number = 7;
	public static function getRandomType():Number {
		return Math.floor( Math.random()*7 + 1 );
	}
	public static function getBlockName(blockType:Number):String {
		switch(blockType) {
			case BlockType.Square: return "square";
			case BlockType.Line: return "line";
			case BlockType.J: return "j";
			case BlockType.L: return "l";
			case BlockType.T: return "t";
			case BlockType.Z: return "z";
			case BlockType.S: return "s";
			default: return "undecided";
		}
	}
}