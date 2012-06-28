package;
import backbonetests.collection.CollectionTest;
import backbonetests.events.EventTest;
import backbonetests.model.ModelTest;
import backbonetests.BackboneTest;
import haxe.unit.TestRunner;

class BackboneTests {
	static function main() {
		var testRunner:TestRunner = new TestRunner();
		testRunner.add(new ModelTest());
		testRunner.add(new EventTest());
		testRunner.add(new CollectionTest());
		//testRunner.add(new BackboneTest());
		testRunner.run();
	}
}

