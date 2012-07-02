package backbonetests.collection;
import backbone.collection.Collection;
import backbone.model.Model;
import haxe.unit.TestCase;

class CollectionTest extends TestCase
{
<<<<<<< HEAD
	private var collection:Collection<Model>;
=======
	private var collection:Collection;
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
	private var model:Model;
	
	override public function setup():Void
	{
		super.setup();
		this.model = new Model();
<<<<<<< HEAD
		this.collection = new Collection<Model>();
		
	}
	
	//public function testNew() {
		//this.collection = new Collection<Model>([]);
		//assertFalse(this.collection == null);
	//}
=======
		this.collection = new Collection();
		
	}
	
	public function testNew() {
		this.collection = new Collection([]);
		assertFalse(this.collection == null);
	}
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
}