package backbonetests.collection;
import backbone.collection.Collection;
import backbone.model.Model;
import haxe.unit.TestCase;

class CollectionTest extends TestCase
{
	private var collection:Collection;
	private var model:Model;
	
	override public function setup():Void
	{
		super.setup();
		this.model = new Model();
		this.collection = new Collection();
		
	}
	
	public function testNew() {
		this.collection = new Collection([]);
		assertFalse(this.collection == null);
	}
}