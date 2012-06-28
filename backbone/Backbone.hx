package backbone;

import backbone.events.Event;
import haxe.Json;
import underscore.Underscore;
import backbone.model.Model;
class Backbone
{
	public static inline var VERSION = '0.9.2';
	public static  var emulateHTTP:Bool = false;
	public static  var emulateJSON:Bool = false;
	//public static var eventSplitter = ~/\s+/; no easy to work with so using
	public static var eventSplitter = " ";
	public static var Events = new Event();
	public static var Model = new Model();
	public static var Router = null;
	public static var View = null;
	
	static public function wrapError(object, model:Model, options:Dynamic)
	{
		
	}
	
	static inline public var methodMap = {
		create : 'POST',
		update : 'PUT',
		delete : 'DELETE',
		read   : 'GET'
	};
	
	static public function sync(method:String,?model:Dynamic=null,?options:Dynamic=null)
	{
		var type:String = Reflect.field(methodMap, method);
		Underscore.ifNullSetValue(options, cast { } );
		var params:Dynamic<Dynamic> = cast { };
		
		params.type = type;
		params.dataType = 'json';
		
		if (Reflect.field(options, "url") == null) {
			params.url = Underscore.ifNullSetValue( getValue(model, 'url') , urlError());
		}
		if (!Reflect.hasField(options, 'data') && model != null && (method == 'create' || method == 'update')) {
			params.contentType = 'application/json';
			params.data = Json.stringify(model.toJSON());
		}
		
		if (emulateJSON) {
			params.contentType = 'application/x-www-form-urlencoded';
			params.data = params.data != null? { model:params.data } :cast { };
		}
		if (emulateHTTP) {
			if (type == 'PUT' || type == 'DELETE') {
				if (emulateJSON) params.data._method = type;
				params.type = 'POST';
				params.beforeSend = function(xhr) {
					xhr.setRequestHeader('X-HTTP-Method-Override', type);
				};
			}
		}
		if (params.type != 'GET' && !emulateJSON) {
			params.processData = false;
		}
			//todo implementer
			trace('send');
	
	}
	
	static public function urlError()
	{
		throw "A url property or function must be specified";
	}
	
	static public function extend(class_:Class<Dynamic>, newFields:Dynamic=null) {
		var newClass:Class<Dynamic> = class_;
		for (field in Reflect.fields(newFields)) {
			Reflect.setField(newClass,field, Reflect.field(newFields, field) );
		}
		return newClass;
	}
	
	
	static public function getValue(object:Dynamic, prop:String) {
		if (!(object != null && Reflect.hasField(object, prop)) ) return null;
		return Underscore.isFunction(object.prop)?object.prop():object.prop;
	}
}