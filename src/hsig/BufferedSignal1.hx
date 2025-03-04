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


@:expose("BufferedSignal1")
@:generic
class BufferedSignal1<T0> extends Signal1<T0> {

	var _queue = new Array<T0>();

	public override function dispatch(value:T0) {
		_queue.push(value);
	}

	public function dispatchBuffered() {
		sortPriority();
		while (_queue.length > 0) {
			this.value = _queue.shift();
			dispatchCallbacks();
		}
	}

	public function dispatchCollapsed() {
		if (_queue.length > 0) {
			sortPriority();
			this.value = _queue[_queue.length - 1];
			_queue.resize(0);
			dispatchCallbacks();
		}
	}

	public function clear() {
		_queue.resize(0);	
	}

	public override function dispatchDistinct(value:T0) {
		if (_queue.length > 0) {
			if (_queue[_queue.length - 1] == value) {
				return;
			}
		}
		else if (this.value == value) {
			return;
		}

		dispatch(value);
	}


}
