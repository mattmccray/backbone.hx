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
<<<<<<< HEAD
=======
		//testRunner.add(new BackboneTest());
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
		testRunner.run();
	}
}

