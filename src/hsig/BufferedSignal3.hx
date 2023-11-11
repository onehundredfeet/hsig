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
private class QueueIitem3<T0, T1, T2> {
	public function new(value1:T0, value2:T1, value3:T2) {
		this.value1 = value1;
		this.value2 = value2;
		this.value3 = value3;
	}
	public var value1 : T0;
	public var value2 : T1;
	public var value3 : T2;
}

@:expose("BufferedSignal3")
@:generic
class BufferedSignal3<T0, T1, T2> extends Signal3<T0, T1, T2> {

	var _freeList = new Array<QueueIitem3<T0, T1, T2>>();
	var _queue = new Array<QueueIitem3<T0, T1, T2>>();

	public override function dispatch(value1:T0,value2:T1, value3:T2) {
		if (_freeList.length > 0) {
			var item = _freeList.pop();
			item.value1 = value1;
			item.value2 = value2;
			item.value3 = value3;
			_queue.push(item);
		} else {
			_queue.push(new QueueIitem3<T0, T1, T2>(value1,value2, value3));
		}
	}

	public function dispatchBuffered() {
		sortPriority();
		while (_queue.length > 0) {
			var v = _queue.shift();

			this.value1 = v.value1;
			this.value2 = v.value2;
			this.value3 = v.value3;		
			_freeList.push(v);

			dispatchCallbacks();
		}
	}

	public function dispatchCollapsed() {
		if (_queue.length > 0) {
			sortPriority();
			var v = _queue[_queue.length - 1];
			this.value1 = v.value1;
			this.value2 = v.value2;
			this.value3 = v.value3;
			while (_queue.length > 0) {
				v = _queue.pop();
				_freeList.push(v);
			}
			dispatchCallbacks();
		}
	}

	public function clear() {
		while (_queue.length > 0) {
			var v = _queue.pop();
			_freeList.push(v);
		}
	}

	public override function dispatchDistinctAny(value1:T0, value2:T1, value3:T2) {
		if (_queue.length > 0) {
			var v = _queue[_queue.length - 1];
			if (v.value1 == value1 && v.value2 == value2 && v.value3 == value3) {
				return;
			}
		}
		else if (this.value1 == value1 && this.value2 == value2 && this.value3 == value3) {
			return;
		}

		dispatch(value1, value2, value3);
	}

	public override function dispatchDistinctAll(value1:T0, value2:T1, value3:T2) {
		if (_queue.length > 0) {
			var v = _queue[_queue.length - 1];
			if (v.value1 == value1 || v.value2 == value2 || v.value3 == value3) {
				return;
			}
		}
		else if (this.value1 == value1 || this.value2 == value2 || this.value3 == value3) {
			return;
		}

		dispatch(value1, value2, value3);
	}
}
