class EnterInitials extends MovieClip {
	var txtInitials:TextField;
	var btnOK:Button;
	var valid:Boolean;

	function onLoad():Void {
		txtInitials.maxChars = 4; // limited to 4 character names
		//Selection.setFocus(this._target + ".txtInitials");
		Selection.setFocus("this.txtInitials");
		btnOK.onPress = btn_submit;
		this._visible = false;
		this.valid = false;
	}
	function addString(s:String):Void {
		this.txtInitials.text += s;
	}
	function btn_submit() {
		var p = this._parent._parent;
		var ei = this._parent;

		trace("parent: "+ p);
		var ob = new Object();
		ob.name = ei.txtInitials.text;
		ob.score = p.score;

		trace("Player " + ob.name + " Submitting score:" + ob.score);
		for(var i:Number=0; i<p.sc.scores.length; i++) {
			if(ob.score > p.sc.scores[i].score) { // if it is higher than some score
				p.sc.scores.splice(i, 0, ob); 
				p.sc.scores.pop(); 
				break;
			}
		}
		for(var i:Number=0; i<p.sc.scores.length; i++) 
			trace("Player:"+p.sc.scores[i].name + " Score:" + p.sc.scores[i].score);

		p.sc.addScores(p.sc.scores);

		ei._visible = false;
		p.sd._visible = true;
		p.score = 0;
		this.valid = false;
	}

	function show() {
		_visible = true;
	}
}