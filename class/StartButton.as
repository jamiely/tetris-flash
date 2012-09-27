class StartButton {
	/**
	 * Stores the MovieClip instance that the StartButton is 
	 * drawn onto.  Should most often be a blank movie clip.
	 */
	var mc:MovieClip;
	var txtField:TextField;
	public function StartButton(mc:MovieClip, location:Point) {
		this.mc = mc;
		this.mc._x = location.x;
		this.mc._y = location.y;
		this.mc.createTextField("text", this.mc.getNextHighestDepth(), 0, 0, 10, 10);
		this.txtField = this.mc.text;
		this.txtField.text = "start";
		
		var txtFormat:TextFormat = new TextFormat("Bit3");
		txtFormat.color = 0x0000FF;
		this.txtField.setTextFormat(txtFormat);

		this.txtField._visible = true;
		this.txtField.autoSize = "left";
		this.txtField.embedFonts = true;
	}

	public function show() {
		this.txtField._visible = true;
		
		with(this.mc) {
			lineStyle(1, 0xFF0000, 100);
			moveTo(0, 0);
			lineTo(0, text._height);
			lineTo(text._width, text._height);
			lineTo(text._width, 0);
			lineTo(0,0);
		}
	}

	public function hide() {
		this.txtField._visible = false;
		this.mc.clear();
	}
}
		