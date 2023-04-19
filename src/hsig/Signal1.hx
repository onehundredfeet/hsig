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

@:generic
private class Signal1CallbackData<T> extends SignalCallbackData {

	public var callback:(T)->Void;
	var _signal : Signal1<T>;
	public function new(signal: Signal1<T>, callback:(T)->Void, priority:Int) {
		super( priority);
		this.callback = callback;
		this._signal = signal;
	}

	function signal() : IBaseSignal {
		return _signal;
	}
	function fire() : Void {
		@:privateAccess _signal._fireCB(this);
	}
}

@:expose("Signal1")
@:generic
class Signal1<T> extends BaseSignal<Signal1CallbackData<T>> {
	public var value(default,null):T;

	public function new(?fireOnAdd:Bool = false) {
		super(fireOnAdd);
	}

		/**
	 * Use the .add method to register callbacks to be fired upon signal.dispatch
	 *
	 * @param callback A callback function which will be called when the signal's ditpatch method is fired.
	 *
	 * @return BaseSignal
	 */
	 public function add(callback:(T)->Void, priority = 0):Signal1CallbackData<T> {
		var currentCallback = new Signal1CallbackData(this,callback, priority);
		callbacks.push(currentCallback);

		if (this._fireOnAdd == true) {
			callback(value);
		}

		return currentCallback;
	}

	final inline override function _fireCB(cb: Signal1CallbackData<T>) {
		cb._callCount++;
		cb.callback(value);
	}


	public inline function dispatch(value1:T) {
		sortPriority();
		this.value = value1;
		dispatchCallbacks();
	}

	public inline function dispatchDistinct(value1:T) {
		if (value1 == value) return;
		sortPriority();
		this.value = value1;
		dispatchCallbacks();
	}

	public function removeByFunc(callback:(T)->Void):Void {
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

// Void->Void // T->Void
