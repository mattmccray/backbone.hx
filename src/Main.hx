package ;

import backbone.model.Model;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author marc paraiso
 */

class Main
{
	
	static function main()
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		var model:Model = new Model();
		model.on("change", callback_);
		model.set("firstname", "marc");
		var firstname:String = model.get("firstname");
		trace(firstname);
	}
	
	static public function callback_(event:Dynamic,args:Dynamic)
	{
		
	}
	
}