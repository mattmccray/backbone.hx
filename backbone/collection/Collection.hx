package backbone.collection;

<<<<<<< HEAD
import underscore.Underscore;
import backbone.events.Event;
import backbone.model.Model;
import haxe.Json;


class Collection<T> extends Event , implements Dynamic<Dynamic> {
=======
import backbone.events.Event;
import backbone.model.Model;
import haxe.Json;
class Collection extends Event , implements Dynamic<Dynamic> {
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
	private var length:Int;
	private var _byId:Dynamic;
	private var _byCid:Dynamic;
	public var model:Model;
	public var comparator:Dynamic;
<<<<<<< HEAD
	public var models(default, null):Array<T>;
	
	public function new(models:Array<Dynamic>=null,?options=null){
=======
	public var models(default, null):Array<Dynamic>;
	
	public function new(models:Array<Dynamic>=null,?options=null) {
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
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
	
<<<<<<< HEAD
	public dynamic function initialize()
=======
	public function initialize()
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
	{
		
	}
	
<<<<<<< HEAD
	public function push(model:Dynamic, options:Dynamic) {
		var model = this._prepareModel(model, options);
		this.add(model, options);
		return model;
	}
	
	public function pop(options:Dynamic) {
		var model:Dynamic = this.at(this.length - 1);
		this.remove(model, options);
		return model;
	}
	

	
	public function unshift(model:Dynamic, options:Dynamic) {
		model = this._prepareModel(model, options);
		this.add(model, Underscore.extend( { at:0 }, options));
		return model;
	}
	
	public function at(object)
	{
		
	}
	
	public function remove(object:Dynamic, object1:Dynamic)
	{
		
	}
	
	private function _prepareModel(object, options:Dynamic)
	{
		
	}
	
	public function add(models:Dynamic, options:Dynamic)
	{
		var i:Int, index:Int, length:Int, model:T, cid:String, id:String, cids=cast{}, ids=cast{}, dups:Array<String>;
		Underscore.ifNullSetValue(options, cast { } );
		/**
		 *  Add a model, or list of models to the set. Pass silent to avoid firing the add event for every new model.
		 */
		models = Underscore.isArray(models)?models.slice():[models];
		/**
		 * Begin by turning bare objects into model references, and preventing invalid models or duplicate models from being added.
		 */
		for (i in 0...models.length) {
			model = models[i] = this._prepareModel(models[i], options);
			if (model == null) {
				throw "Can't add an invalid model to a collection";
			}
			cid = model.cid;
			id = model.id;
			if (cids.cid != null || Reflect.field(this._byCid,cid) != null || ((id != null) && (Reflect.field(ids,id)!= null || Reflect(this._byCid,id) != null))) {
				dups.push(i);
				continue;
			}
			Reflect.setField(ids, id, model);
			Reflect.setField(cids, cid, Reflect.field(ids, id);
		}
		//Remove duplicates.
		i = dups.length;
		while (i-->0) {
			models.splice(dups[i], 1);
		}
		//Listen to added models' events, and index models for lookup by id and by cid.
		for (i...models.length) {
			model = models[i];
			model.on('all', this._onModelEvent, this);
			Reflect.setField(this._byCid, model.cid, model);
		}
	}
	
	private function _onModelEvent()
	{
		
	}
	
	public function parse(resp:Dynamic, xhr:Dynamic) {
		return resp;
	}
	
=======

	
>>>>>>> cb882b456c303f059cadc355389617cc32a36db9
}