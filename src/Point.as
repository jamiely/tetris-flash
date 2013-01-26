class Point {
	public var x:Number;
	public var y:Number;
	public function Point(x:Number, y:Number) {
		this.x = x;
		this.y = y;
	}
	public function toString():String {
		return "(" + this.x + ", " + this.y + ")";
	}
}