package hsig;


class BaseSignal<TCB : SignalCallbackData> {
	#if js
	@:noCompletion private static function __init__() {
		untyped Object.defineProperties(BaseSignal.prototype, {
			"numListeners": {
				get: untyped __js__("function () { return this.get_numListeners (); }"),
				set: untyped __js__("function (v) { return this.set_numListeners (v); }")
			},
			"hasListeners": {
				get: untyped __js__("function () { return this.get_hasListeners (); }"),
				set: untyped __js__("function (v) { return this.set_hasListeners (v); }")
			},
		});
	}
	#end

	public var numListeners(get, null):Int;
	public var hasListeners(get, null):Bool;

	public var _fireOnAdd:Bool = false;

	var currentCallback:TCB;
	var callbacks:Array<TCB> = [];
	var toTrigger:Array<TCB> = [];
	var requiresSort:Bool = false;

    public function _dispatch(cb:TCB) {
        // override
    }



	public function new(?fireOnAdd:Bool = false) {
		this._fireOnAdd = fireOnAdd;
	}

	inline function sortPriority() {
		if (requiresSort) {
			callbacks.sort(sortCallbacks);
			requiresSort = false;
		}
	}

	inline function dispatchCallbacks() {
		var i:Int = 0;
		while (i < callbacks.length) {
			var callbackData = callbacks[i];
			if (callbackData.repeat < 0 || callbackData.callCount <= callbackData.repeat) {
				toTrigger.push(callbackData);
			} else {
				callbackData.remove = true;
			}
			i++;
		}

		// remove single dispatchers
		var j:Int = callbacks.length - 1;
		while (j >= 0) {
			var callbackData = callbacks[j];
			if (callbackData.remove == true) {
				callbacks.splice(j, 1);
			}
			j--;
		}

		for (l in 0...toTrigger.length) {
			if (toTrigger[l] != null) {
				_dispatch(toTrigger[l]);
			}
		}
		toTrigger.resize(0);
	}

	public function removeAll() {
		callbacks.resize(0);
	}

	function sortCallbacks(s1:SignalCallbackData, s2:SignalCallbackData):Int {
		if (s1.priority > s2.priority)
			return -1;
		else if (s1.priority < s2.priority)
			return 1;
		else
			return 0;
	}

	function get_numListeners() {
		return callbacks.length;
	}

	function get_hasListeners() {
		return numListeners > 0;
	}

}
