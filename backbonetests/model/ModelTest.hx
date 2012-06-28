package backbonetests.model;


import backbone.model.Model;
import haxe.unit.TestCase;

class ModelTest extends TestCase {
	private var model:Model;
	private var datas:Dynamic;
	
	override public function setup():Void{
		super.setup();
		model = new Model();
		datas = { firstname:'Jack', lastname:'MacDonald', country:'Scottland', city:'Paris', age:34 };
	}
	
	public function testToJSON() {
		model.set(datas);
		var data:Dynamic = model.toJSON() ;
		assertEquals('Jack', data.firstname);
		assertEquals('MacDonald', data.lastname);
		assertEquals(34, data.age);
		assertFalse(datas == data);
	}
	
	public function testNew() {
		model = new Model( {
			firstname:"John",
			lastname:"Kennedy"
		});
		assertEquals("John", model.get("firstname"));
		assertEquals("Kennedy", model.get("lastname"));
		
	}
	
	public function testIsNew() {
		assertTrue(model.isNew());
	}
	
	public function testSet() {
		assertEquals(null, model.get("unset_property"));
		model.set("firstname", "John");
		assertEquals("John", model.get("firstname"));
		model.set("lastname", "Doe");
		assertEquals("Doe", model.get("lastname"));
		model.set( { country:"USA", city:"Detroit" } );
		assertEquals("USA", model.get("country"));
		assertEquals("Detroit", model.get("city"));
	}
	
	public function testTrigger(){
		var test = this ;
		var callback_ = function(event:Dynamic, args:Dynamic) {
			assertEquals(0, cast(event, String).indexOf("change"));
		}
		model.set("age", 29);
		model.set( { country:"France", city:"Paris" } );
		model.set("country", "Uk");
		model.on("change:city", callback_);
		model.set("city", "Rennes");
		model.on("change",callback_,this);
		model.set("firstname", "marc");
		model.on("change:lastname", callback_);
		model.set("firstname", "John");
		model.set("lastname", "Doe");
		model.on("change:country", callback_);

	}
}