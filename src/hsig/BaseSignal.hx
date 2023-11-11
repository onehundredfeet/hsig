/*
	Copyright 2018 P.J.Shand
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
	FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
// Heavily derived from https://github.com/peteshand/signals, with modification by https://github.com/onehundredfeet
package hsig;



class BaseSignal<TCB : SignalCallbackData> implements IBaseSignal {
	#if js
	@:noCompletion private static function __init__() {
		untyped Object.defineProperties(BaseSignal.prototype, {
			"numListeners": {
				get: js.Syntax.code("function () { return this.get_numListeners (); }"),
				set: js.Syntax.code("function (v) { return this.set_numListeners (v); }")
			},
			"hasListeners": {
				get: js.Syntax.code("function () { return this.get_hasListeners (); }"),
				set: js.Syntax.code("function (v) { return this.set_hasListeners (v); }")
			},
		});
	}
	#end

	public var numListeners(get, null):Int;
	public var hasListeners(get, null):Bool;

	var _fireOnAdd:Bool = false;

	public function isFireOnAdd():Bool {
		return _fireOnAdd;
	}

	var callbacks:Array<TCB> = [];
	var toTrigger:Array<TCB> = [];
	var requiresSort:Bool = false;

    function _fireCB(cb:TCB) {
        // override
    }

	public function setDirty() {
		requiresSort = true;
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
			if (callbackData._repeat < 0 || callbackData._callCount <= callbackData._repeat) {
				toTrigger.push(callbackData);
			} else {
				callbackData._remove = true;
			}
			i++;
		}

		// remove single dispatchers
		var j:Int = callbacks.length - 1;
		while (j >= 0) {
			var callbackData = callbacks[j];
			if (callbackData._remove == true) {
				callbacks.splice(j, 1);
			}
			j--;
		}

		for (l in 0...toTrigger.length) {
			if (toTrigger[l] != null) {
				_fireCB(toTrigger[l]);
			}
		}
		toTrigger.resize(0);
	}

	public function removeAll() {
		callbacks.resize(0);
	}

	public function remove(data: SignalCallbackData) {
		var j:Int = 0;
		while (j < callbacks.length) {
			if (callbacks[j] == data) {
				callbacks[j] = callbacks[callbacks.length - 1];
				callbacks.pop();
			} else {
				j++;
			}
		}
	}
	function sortCallbacks(s1:SignalCallbackData, s2:SignalCallbackData):Int {
		if (s1._priority > s2._priority)
			return -1;
		else if (s1._priority < s2._priority)
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
