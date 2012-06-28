package backbone.model;
import backbone.Backbone;
import backbone.events.Event;
import backbone.model.Model;
import underscore.Underscore;

class Model  extends Event, implements Dynamic<Dynamic>{
	
	public var defaults(default,null):Dynamic;
	public var attributes(default,null):Dynamic;
	private var _escapedAttributes:Dynamic;
	private var changed:Dynamic;
	private var _silent:Dynamic;
	private var _previousAttributes:Dynamic;
	private var _pending:Dynamic;
	private var cid:String;
	private var collection:Dynamic;
	private var _changing:Bool;
	public var id(default, null):String;
	public var idAttribute:String;
	

	
	/**
	 * Create a new model, with defined attributes.
	 * A client id (cid) is automatically generated
	 * and assigned for you.
	 */
	public function new(attributes:Dynamic=null,options:Dynamic=null,?params:Dynamic=null){
		super();
		if (options != null && Reflect.hasField(options,"parse"))  {
			attributes = this.parse(attributes);
		}
		if (defaults == null) defaults = cast { };
		if (attributes == null) attributes = cast { };
		this.attributes = Underscore.extend(cast { } , [ defaults , attributes ]);
		if (options != null && Reflect.hasField(options, "collection") && options.collection != null) this.collection = options.collection;
		this._escapedAttributes = cast { };
		this.cid = Underscore.uniqueId('c');
		this._pending = cast { };
		this._previousAttributes = Underscore.clone(this.attributes);
		this.initialize([attributes, options, params]);
		idAttribute = 'id';
		changed = cast {};
		_silent = cast {};
	}
	
	private function getValue(object:Dynamic, prop:String) {
		if (!(object != null && Reflect.hasField(object, prop)) ) return null;
		return Underscore.isFunction(object.prop)?object.prop():object.prop;
	}
	
	public function initialize(params:Array<Dynamic>=null){
		
	}
	
	public function toJSON(options:Dynamic=null){
		return Underscore.clone(this.attributes);
	}
	
	public function get(attr:String){
		return Reflect.field(this.attributes, attr);
	}
	
	public function escape(attr){
		var html = Reflect.field(this._escapedAttributes, attr);
		if (html != null) return html;
		var val = this.get(attr);
		Reflect.setField(this._escapedAttributes, attr, Underscore.escape(val == null?'':'' + val));
		return Reflect.field(this._escapedAttributes, attr);
		}
	
	public function has(attr){
		return this.get(attr) != null;
	}
	
	public function set(key:Dynamic,?value:Dynamic,?options:Dynamic):Dynamic{
		var attrs:Dynamic, attr:Dynamic, val:Dynamic;
		if (Underscore.isObject(key) || key == null) {
			attrs = key;
			options = value;
		}else {
			attrs =cast  { };
			Reflect.setField(attrs, key, value);
		}
		options = options != null?options:cast { };
		if (attrs == null) return this;
		if (Type.getClassName(Type.getClass(attrs)) == Model) attrs = Reflect.field(attrs, 'attributes');
		if (Reflect.field(options, 'unset') != null) for (attr in Reflect.fields(attrs) ) Reflect.deleteField(attrs, attr);
		
		if (this._validate(attrs, options) == false) return false;
		if (Reflect.hasField(attrs, this.idAttribute) ) this.id = Reflect.field(attrs, this.idAttribute);
		var changes  = cast { };
		Reflect.setField(options, 'changes', changes);
		var now = this.attributes;
		var escaped = this._escapedAttributes;
		var prev = this._escapedAttributes != null?this._previousAttributes:cast { };
		for (attr in Reflect.fields(attrs)) {
			val = Reflect.field(attrs, attr);
			if (!Underscore.isEqual(Reflect.field(now, attr), val) || (Reflect.field(options, 'unset') != null && Underscore.has(now, attr) ) ) {
				Reflect.deleteField(escaped, attr);
				Reflect.setField((Reflect.field(options, 'silent') != null?this._silent : changes), attr, true);
			}
			Reflect.field(options, "unset")!= null ? Reflect.deleteField(now, attr) : Reflect.setField(now, attr, val);
		
			if (!Underscore.isEqual(Reflect.field(prev, attr), val) || ( Underscore.has(now, attr) != Underscore.has(prev, attr) )) {
				Reflect.setField(this.changed, attr, val);
				if (!Reflect.hasField(options, 'silent')) Reflect.setField(this._pending, attr, true);
			}else {
				Reflect.deleteField(this.changed, attr);
				Reflect.deleteField(this._pending, attr);
			}
		}
		if (Reflect.field(options, "silent") == null) this.change(options);
		return this;
	}
	
	public function unset(attr:Dynamic, ?options:Dynamic) {
		options = options != null?options : cast { };
		options.unset = true;
		return this.set(attr, null, options);
	}
	
	public function clear(options:Dynamic=null):Dynamic {
		options = options != null?options : cast { };
		options.unset = true;
		return this.set(Underscore.clone(this.attributes), options);
	}
	
	public function fetch(options:Dynamic=null) {
		options = options != null?options : cast { };
		var model:Model= this;
		var success = Reflect.field(options, 'success');
		options.success = function(resp:Dynamic, status:Dynamic, xhr:Dynamic) {
			if (model.set(model.parse(resp, xhr), options) == null) return false;
			if (success != null) success(model, resp);
			return true;
		}
		options.error = Backbone.wrapError(options.error, model, options);
		return (this.sync != null?this.sync : Backbone.sync)('read', [this, options]);
	}
	
	public function destroy(options:Dynamic):Dynamic{
		options = options != null?  Underscore.clone(options)  : cast { };
		var model:Model= this;
		var success = options.success;
		var triggerDestroy = function() {
			model.trigger('destroy', [model, model.collection, options]);
		}
		if (this.isNew()) {
			triggerDestroy();
			return false;
		}
		options.success = function(resp) {
			if (options.wait) triggerDestroy();
			if (success!=null) {
				success(model, resp);
			}else {
				model.trigger('sync',[model, resp, options]);
			}
		}
		options.error = Backbone.wrapError(options.error, model, options);
		var sync:Dynamic = this.sync != null ? this.sync : Backbone.sync ;
		var xhr :Dynamic = sync('delete',this, options);
		if (options.wait == null) triggerDestroy();
		return xhr;
	}
	
	public function sync(event:String,?model:Dynamic=null,?options:Dynamic=null){
		
	}
	
	public function url() {
		var base = getValue(this, 'urlRoot') != null?getValue(this, 'urlRoot'):getValue(this.collection, 'url') != null?getValue(this.collection, 'url'):urlError();
	}
	
	private function urlError(){
		
	}
	
	public function parse(resp:Dynamic,?xhr:Dynamic) {
		return resp;
	}
	
	public function clone():Model {
		return new Model(this.attributes);
	}
	
	public function isNew(){
		return this.id == null;
	}
	
	public function change(options:Dynamic=null):Dynamic {
		Underscore.ifNullSetValue(options, cast { } );
		var changing = this._changing;
		this._changing = true ;
		for (attr in Reflect.fields(this._silent)) {
			Reflect.setField(this._pending, attr, true);
		}
		var changes = Underscore.extend(cast { }, [Reflect.field(options, 'changes'), this._silent]);
		this._silent = { };
		for (attr in Reflect.fields(changes)) {
			#if debug
				trace(changes);
			#end
			this.trigger('change:' + attr, [this, this.get(attr), options]);
		}
		if (changing) return this ;
		while (!Underscore.isEmpty(this._pending)) {
			this._pending = { };
			
			this.trigger('change', [this, options]);
			for (attr in Reflect.fields(this.changed)) {
				if (Reflect.field(this._pending, attr) == true || Reflect.field(this._silent, attr) != null) continue;
				Reflect.deleteField(this.changed, attr);
			}
			this._previousAttributes = Underscore.clone(this.attributes);
		}
		this._changing = false;
		return this ;
	}
	
	private function _validate(attrs:Dynamic,options:Dynamic):Bool{
		if ( (Reflect.hasField(options,"silent") && options.silent==true) || this.validate == null) return true;
		attrs = Underscore.extend(cast { }, [this.attributes, attrs]);
		var error = this.validate(attrs, options);
		if (error == null) return true;
		if (options != null &&  Reflect.hasField(options, "error") ) {
			options.error(this, error, options);
		}else {
			this.trigger("error",[this, error, options]);
		}
		return false;
	}
	
	public function hasChanged(attr:String=null):Bool {
		if (attr == null) return false;
		return Underscore.has(this.changed, attr);
	}
	
	public function changedAttributes(diff:Dynamic){
		if (diff == null) {
			var res = this.hasChanged() ? Underscore.clone(this.changed) : null;
			return res ;
		}
		var val, changed = null, old = this._previousAttributes;
		for (attr in Reflect.fields(diff)) {
			val = Reflect.field(diff, attr);
			if (Underscore.isEqual(Reflect.field(old, attr), val) )continue;
			if ( changed == null) changed = cast { };
			Reflect.setField(changed, attr, val);
		}
		return changed;
	}
	
	public function previous(attr:Dynamic){
		if (this._previousAttributes == null) return null;
		return Reflect.field(this._previousAttributes, attr);
	}
	
	public function previousAttributes(){
		return Underscore.clone(this._previousAttributes);
	}
	
	public function isValid(){
		return this.validate(this.attributes) == null;
	}
	
	private function validate(attrs:Dynamic,?options:Dynamic=null){
		
	}

	public function toString():String {
		return Std.string(attributes);
	}
}