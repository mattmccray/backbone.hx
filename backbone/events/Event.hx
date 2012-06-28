package backbone.events;

class Event {
	static var eventSplitter = " ";
	
	public var callbacks(default,null):Hash<Dynamic>;

	public function new(){
	}
	
	public function on(events_:String,callback_:Dynamic,context:Dynamic=null):Event{
		
		if (callback_ == null) return this ;
		if (context == null) context = this;
		var events:Array<String>= events_.split(eventSplitter);
		var event:String = null;
		this.callbacks = this.callbacks != null ? this.callbacks : new Hash<Dynamic>();
		while (events.length > 0) {
			event = events.shift();
			var list = callbacks.get(event);
		var node = list != null?list.tail : {next:Dynamic,callback_:Dynamic};
			node.next = cast {};
			var tail = node.next ;
			node.callback_ = callback_;
			callbacks.set(event, { tail:tail, next:list != null?list.next:node } );
			#if debug
				trace(event);
				trace(callbacks.get(event));
				trace(callbacks.get(event).next.callback_);
			#end
		}
		return this;
	}
	
	public function off(events_:String,callback_=null,context_=null):Event {
		if (Lambda.count(callbacks)<= 0) return this;
		var events:Array<Dynamic> = events_ != null? events_.split(eventSplitter):cast(this.callbacks.keys(),Array<Dynamic>);
		var event  = null;
		while (Lambda.count(events) > 0) {
			
			event = events.shift();
			var node = callbacks.get(event);
			callbacks.remove(event);
			if (node == null || (callback_ == null || context_ == null) ) continue;
			var tail = node.tail;
			while ( node != tail) {
				node = node.next;
				var cb = node.callback_;
				var ctx = node.context ;
				if ((callback_ != null && cb != callback_) || (context_ != null && ctx != context_)) {
					this.on(event, cb, ctx);
				}
			}
		}
		return this;
	}
	
	public function trigger(events_:String,rest_:Array<Dynamic>=null):Event {
		if (this.callbacks == null) return this ;
		var all = this.callbacks.get("all");
		var events:Array<String> = events_.split(eventSplitter);
		var event = null;
		while (Lambda.count(events) > 0) {
			event = events.shift();
			var node = this.callbacks.get(event);
			if (node != null) {
				var tail = node.tail ;
				while (node != tail) {
					if (node.callback_ != null) {
						var arguments:Array<Dynamic> = [event];
						if (rest_ != null) arguments =  arguments.concat(rest_);
						#if js && flash
							node.callback_.apply(node.context, arguments);
						#else
							node.callback_(event, rest_);
						#end
					}
					node = node.next;
				}
			}
			node = all;
			if (node !=null) {
				var tail = node.tail;
				var arguments:Array<Dynamic> = [event];
				if (rest_ != null) arguments =  arguments.concat(rest_);
				node == node.next;
				while (node != tail) {
					if (node.callback_ != null) {
						#if js && flash
						node.callback_.apply(node.context, arguments);
						#else
						node.callback_(event, rest_);
						#end
					}
					node = node.next;
				}
			}
		}
		return this;
	}
	
	public function bind(events:String,callback_:Dynamic=null,context:Dynamic=null):Event{
		return on(events, callback_, context);
	}
	
	public function unbind(events:String,callback_:Dynamic=null,context:Dynamic=null):Event{
		return off(events, callback_, context);
	}
}

