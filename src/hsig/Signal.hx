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

private class Signal0CallbackData extends SignalCallbackData {

	public var callback:()->Void;
	public function new(callback:()->Void, priority:Int) {
		super( priority);
		this.callback = callback;
	}
}

/**
 *  The API is based off massiveinteractive's msignal and Robert Penner’s AS3 Signals, however is greatly simplified.
 */
@:expose("Signal")
class Signal extends BaseSignal<Signal0CallbackData> {
	public function new(?fireOnAdd:Bool = false) {
		super(fireOnAdd);
	}

	public function dispatch() {
		sortPriority();
		dispatchCallbacks();
	}

	final inline override function _dispatch(cb:Signal0CallbackData) {
		cb.callCount++;
		cb.callback();
	}

	/**
	 * Use the .add method to register callbacks to be fired upon signal.dispatch
	 *
	 * @param callback A callback function which will be called when the signal's ditpatch method is fired.
	 *
	 * @return BaseSignal
	 */
	 public function add(callback:()->Void, priority = 0):SignalOptions<Signal0CallbackData> {
		currentCallback = new Signal0CallbackData(callback, priority);
		callbacks.push(currentCallback);

		if (this._fireOnAdd == true) {
			callback();
		}

		return this;
	}



	public function remove(callback:()->Void):Void {
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

typedef Signal0 = Signal
