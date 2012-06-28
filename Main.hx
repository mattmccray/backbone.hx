package;

import backbone.Backbone;
import backbone.events.Event;
import backbone.model.Model;
import underscore.Underscore;
class Main implements Dynamic<Dynamic>{
	public function new(){
		
	}
	static function main() {
		var main:Main = new Main();

		var event:Event = new Event();
		event.on("change reset", main.onchange, main);
		event.on("change", main.onotherchange, main);
		event.on("start", main.onstart, main);
		event.on("all", main.onall, main);
		event.off("all");
		event.off("change");
		trace(event.callbacks);
		event.trigger("change", ["first_argument"]);
		event.trigger("reset", ["first_argument"]);
		event.trigger("start");
		
		
		var target =cast {};
		target.country = "France";
		target.city = "Paris";
		trace(target);
		Underscore.extend(target, [{ greet:function() { trace("Greetings"); } , firstNmame:"Marc", lastName:"Prades" }] );
		trace(target);
		target.greet();
		#if neko
		var input = Sys.stdin().readLine();
		#end
	}
	public function onall(event=null,?arg1)
	{
		trace(Std.format("onall $event"));
	}
	public function onchange(event=null,?arg1):Void
	{
		var m = Std.format("onchange $event $arg1");
		trace(m);
	}	public function onotherchange(event=null,?arg1):Void
	{
		var m = Std.format("onotherchange $event $arg1");
		trace(m);
	}
	public function onstart(event=null,?args1):Void {
		trace(Std.format("onstart $event"));
	}
	
}