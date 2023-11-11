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
class BufferedSignal extends Signal {

	var _times = 0;

	public override function dispatch() {
		_times++;
	}

	public function dispatchBuffered() {
		sortPriority();
		while (_times > 0) {
			dispatchCallbacks();
		}
	}

	public function dispatchCollapsed() {
		if (_times > 0) {
			sortPriority();
			_times = 0;
			dispatchCallbacks();
		}
	}

	public function clear() {
		_times = 0;
	}

}
