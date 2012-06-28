package backbone.collection;

import backbone.events.Event;
import backbone.model.Model;
import haxe.Json;
class Collection extends Event , implements Dynamic<Dynamic> {
	private var length:Int;
	private var _byId:Dynamic;
	private var _byCid:Dynamic;
	public var model:Model;
	public var comparator:Dynamic;
	public var models(default, null):Array<Dynamic>;
	
	public function new(models:Array<Dynamic>=null,?options=null) {
		super();
		options = options != null? options : cast { };
		if (Reflect.hasField(options, 'model')) this.model = options.model;
		if (Reflect.hasField(options, 'comparator')) this.comparator = options.comparator;
		this._reset();
		this.initialize();
		if (models != null) this.reset(models, { silent:true, parse:Reflect.field(options, 'parse') } );
	}
	
	private function _reset(?options:Dynamic=null)
	{
		this.length = 0;
		this.models = [];
		this._byId = cast { };
		this._byCid = cast { };
	}
	public function toJSON()
	{
		return Lambda.map(models, function(model_:Model) { return model_.toJSON(); } );
	}
	public function reset(?models:Array<Dynamic>=null,?options:Dynamic=null)
	{
		
	}
	
	public function initialize()
	{
		
	}
	

	
}