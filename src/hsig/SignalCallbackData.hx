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

import hsig.IBaseSignal;

// Heavily derived from https://github.com/peteshand/signals, with modification by https://github.com/onehundredfeet


@:allow(hsig.IBaseSignal)
abstract class SignalCallbackData {
	public inline function new(  priority:Int) {
		this._priority = priority;
	}

	 var _callCount:Int = 0;
	 var _repeat:Int = -1;
	 var _priority:Int;
	 var _remove:Bool = false;
   
	 abstract function signal() : IBaseSignal;

	 /**
	 * Use the ._priority method to specifies the _priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @param value An optional Int that specifies the _priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal
	 */
	public inline function priority(value:Int):SignalCallbackData {
		if (value != _priority) {
			_priority = value;
			signal().setDirty();
		}

		return this;
	}

	/**
	 * Use the .repeat method to define the number of times the callback should be triggered before removing itself. Default value = -1 which means it will not remove itself.
	 *
	 * @param value An Int that specifies the number of repeats before automatically removing itself.
	 *
	 * @return BaseSignal
	 */
	public inline function repeat(value:Int = -1):SignalCallbackData {
		if (_repeat != value) {
			_repeat = value;
			signal().setDirty();
		}
		return this;
	}

	/**
	 * Use the .fireOnAdd method that if called will immediately call the most recently added callback.
	 *
	 * @return Void
	 */
	public inline function fireOnAdd():SignalCallbackData {
		if (!signal().isFireOnAdd()) {
			fire();
		}
		return this;
	}

	abstract function fire() : Void;

}
