package backbonetests.events;


import backbone.events.Event;
import haxe.unit.TestCase;

class EventTest extends TestCase {
	private var event:Event;
	
	override public function setup():Void{
		super.setup();
		event = new Event();
	}
	
	public function testOn() {
		event.on("change", callback_);
		event.on("reset", callback_);
		event.on("start end", callback_);
		assertTrue(event.callbacks.exists("change"));
		assertTrue(event.callbacks.exists("reset"));
		assertTrue(event.callbacks.exists("start"));
		assertTrue(event.callbacks.exists("end"));
		assertEquals(4, Lambda.count(event.callbacks) );
	}
	
	public function testOff() {
		event.on("change", callback_);
		event.on("start end", callback_);
		event.off("change", callback_);
		event.off("end", callback_);
		assertFalse(event.callbacks.exists("change"));
		assertFalse(event.callbacks.exists("reset"));
		assertFalse(event.callbacks.exists("end"));
		assertTrue(event.callbacks.exists("start"));
		
	}
	
	public function testTrigger() {
		event.on("change", callback_);
		event.trigger("change");
		event.trigger("change", ["changed"]);
	}
	
	public function callback_(event:Dynamic, args:Dynamic) {
		assertEquals("change", event);
		if (args != null) {
			assertEquals("changed", args[0]);
		}
	}
	
}