import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import underscore.Underscore;

class UnderscoreTest extends TestCase {
	
	override public function setup():Void{
		super.setup();
	}
	
	public function testIsEqual() {
		print("\nisEqual");
		var a, b;
		a = { firstName:"Marc", lastName:"Thierry" };
		b = { firstName:"Marc", lastName:"Thierry" };
		assertTrue(Underscore.isEqual(a, b));
		assertTrue(Underscore.isEqual(1, 1));
		assertTrue(Underscore.isEqual("string", "string"));
		assertTrue(Underscore.isEqual([1, 2], [1, 2]));
		assertFalse(Underscore.isEqual(1, 2));
	}
	
	public function testIsNull() {
		print("\nisNull");
		assertTrue(Underscore.isNull(null));
		assertFalse(Underscore.isNull(1));
		assertFalse(Underscore.isNull([]));
	}
	
	public function testIsArray() {
		print("\nisArray");
		assertTrue(Underscore.isArray([]));
		assertTrue(Underscore.isArray(new Array<String>()));
		assertTrue(Underscore.isArray(["blip", { p:1 }, 1]));
		assertFalse(Underscore.isArray(1));
		assertFalse(Underscore.isArray( { x:2 } ));
	}
	
	public function testIsString() {
		print("\nIsString");
		assertTrue(Underscore.isString("hello"));
		assertFalse(Underscore.isString([1, 2, 3]));
		assertFalse(Underscore.isString( { a:1, b:2 }) );
	}
	
	public function testIsObject()
	{
		print("\nIsObject");
		assertFalse(Underscore.isObject("hello"));
		assertFalse(Underscore.isObject([1, 2, 3]));
		assertFalse(Underscore.isObject(function() { return true; } ));
		assertFalse(Underscore.isObject(1));
		
		assertTrue(Underscore.isObject( { a:1, b:2, c:3 } ));
	}
	
	public function testClone()
	{
		print("\nclone");
		var array:Array<Dynamic>, object:Dynamic,object1, val = 1;
		array = [1, 2, 3, 4];
		object = { a:1, b:2, c:3 };
		object1 = cast { };
		object1.firstname = "marc";
		object1.lastname = "prades";
		assertEquals("[1, 2, 3, 4]",Std.string(Underscore.clone(array)));
		assertEquals("{ a => 1, b => 2, c => 3 }", Std.string(Underscore.clone(object)));
		assertEquals(1, Underscore.clone(val));
		assertEquals('{ lastname => prades, firstname => marc }',Std.string(Underscore.clone(object1)));
		}
		
	public function testExtend() {
		print("\nextend");
		var person = cast { };
		person.country = "France";
		person.city = "Paris";
		person.age = 23;
		var extended = Underscore.extend(person, [ { gender:"male", skin:"red" },{hair:"blue"}]);
		assertEquals("France", extended.country);
		assertEquals("male", extended.gender);
		assertEquals("blue", extended.hair);
	}
	
	public function testUniqueId() {
		print("\nuniqueId");
		assertEquals("0", Underscore.uniqueId());
		assertEquals("1", Underscore.uniqueId());
		assertEquals("2", Underscore.uniqueId());
		assertEquals("myid_3", Underscore.uniqueId("myid_"));
		assertEquals("id4", Underscore.uniqueId("id"));
	}

	
	public function testIsEmpty() {
		print("\nisEmpty");
		assertTrue(Underscore.isEmpty( { } ));
		assertTrue(Underscore.isEmpty([]));
		assertTrue(Underscore.isEmpty(null));
		assertTrue(Underscore.isEmpty(""));
		assertFalse(Underscore.isEmpty( { a:1, b:2 } ));
		assertFalse(Underscore.isEmpty([1, 2, 3]));
		assertFalse(Underscore.isEmpty("string"));
	}
	
	public function testEach() {
		print("\neach");
		
		var array:Array<String> = ["this", "is", "a", "sentence"];
		var result_array:Array<String> = [];
		var reverse:String->Int->Dynamic->Void = function(word:String,index:Int,object:Dynamic) {
			result_array.push(array.pop());
		}
		Underscore.each(array, reverse);
		assertEquals("sentence", result_array[0]);
		assertEquals("a", result_array[1]);
		var obj = { a:1, b:2, c:3 };
		Underscore.each(obj, function(el,field,object) { assertTrue(Underscore.isInt(el)); } );
	}
	
	public function testIsInt() {
		print("\nisInt\n");
		assertTrue(Underscore.isInt(1));
		assertTrue(Underscore.isInt( -1));
		assertFalse(Underscore.isInt("a"));
	}
	
	public function testHas() {
		print("\nhas");
		var o = { a:1, b:2, c:3, d:4 };
		assertTrue(Underscore.has(o, 'a'));
		assertTrue(Underscore.has(o, 'c'));
		assertFalse(Underscore.has(o, 'e'));
	}
		
	public function testSize() {
		print("\nsize\n");
		var s = "string";
		assertEquals(6, Underscore.size(s));
		assertEquals(3, Underscore.size([1, 2, 3]));
		assertEquals(4, Underscore.size( { a:1, b:"hello", c:~/marc/, d:function() { return true; } } ));
	}
	
	public function testMap() {
		print("\nmap\n");
		var array = [1, 2, 3, 4];
		var mapFunction = function(el, index, array) {
			return el + 1;
		};
		var mappedArray = Underscore.map(array, mapFunction);
		assertEquals(2, mappedArray[0]);
		print(mappedArray);
		var collectedArray = Underscore.collect(array, mapFunction);
		assertEquals(5, collectedArray[3]);
	}
	
	public function testReduce() {
		print("\nreduce");
		var result = Underscore.reduce([1, 2, 3, 4], function(memo, value, index, obj) { return memo + value; } );
		assertEquals(10,result );
		print("\n" + result);
		var result2:String = Underscore.reduce(["t", "h", "i", "s"], function(memo, value, index, obj) { return memo + value; } );
		assertEquals("this", result2);
		print("\n" + result2);
	}
	
	public function testReverse() {
		print("\nreverse");
		var array = [1, 2, 3, 4];
		assertEquals("[4, 3, 2, 1]", Std.string(Underscore.reverse(array)));
	}
	
	override public function tearDown():Void {
		super.tearDown();
	}
		
	static function main() {
		var e:EReg = ~/\s+/;
		var test:haxe.unit.TestRunner = new TestRunner();
		test.add(new UnderscoreTest());
		test.run();
	}
}