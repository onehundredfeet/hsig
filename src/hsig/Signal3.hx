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
package hsig;
// Heavily derived from https://github.com/peteshand/signals, with modification by https://github.com/onehundredfeet

private class Signal3CallbackData<T0, T1, T2> extends SignalCallbackData {

	public var callback:(T0,T1,T2)->Void;
	var _signal : Signal3<T0, T1, T2>;

	public function new(signal: Signal3<T0, T1, T2>, callback:(T0,T1,T2)->Void, priority:Int) {
		super( priority);
		this.callback = callback;
		_signal = signal;
	}

	function signal() : IBaseSignal {
		return _signal;
	}
	function fire() : Void {
		_signal._dispatch(this);
	}
}


@:expose("Signal3")
class Signal3<T0, T1, T2> extends BaseSignal<Signal3CallbackData<T0, T1, T2>> {
	public var value1(default,null):T0;
	public var value2(default,null):T1;
	public var value3(default,null):T2;


	public function new(?fireOnAdd:Bool = false) {
		super(fireOnAdd);
	}

	final inline override function _dispatch(cb: Signal3CallbackData<T0, T1, T2>) {
		cb._callCount++;
		cb.callback(value1, value2, value3);
	}

	/**
	 * Use the .add method to register callbacks to be fired upon signal.dispatch
	 *
	 * @param callback A callback function which will be called when the signal's ditpatch method is fired.
	 *
	 * @return BaseSignal
	 */
	 public function add(callback:(T0, T1, T2)->Void, priority = 0):Signal3CallbackData<T0,T1,T2> {
		var currentCallback = new Signal3CallbackData(this, callback, priority);
		callbacks.push(currentCallback);

		if (this._fireOnAdd == true) {
			callback(value1,value2, value3);
		}

		return currentCallback;
	}

	public function dispatch(value1:T0, value2:T1, value3:T2) {
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		this.value3 = value3;
		dispatchCallbacks();
	}
	public function dispatchDistinctAny(value1:T0, value2:T1, value3:T2) {
		if (this.value1 == value1 && this.value2 == value2 && this.value3 == value3) return;
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		this.value3 = value3;
		dispatchCallbacks();
	}

	public function dispatchDistinctAll(value1:T0, value2:T1, value3:T2) {
		if (this.value1 == value1 || this.value2 == value2 || this.value3 == value3) return;
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		this.value3 = value3;
		dispatchCallbacks();
	}

	public function removeByFunc(callback:(T0, T1,T2)->Void):Void {
		var j:Int = 0;
		while (j < callbacks.length) {
			if (callbacks[j].callback == callback) {
				callbacks[j] = callbacks[callbacks.length - 1];
				callbacks.pop();
			} else {
				j++;
			}
		}
	}
}
