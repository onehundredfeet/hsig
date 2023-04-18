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


abstract SignalOptions<TCB: SignalCallbackData>(BaseSignal<TCB>) from BaseSignal<TCB> {
	/**
	 * Use the .priority method to specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @param value An optional Int that specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal
	 */
	public inline function priority(value:Int):BaseSignal<TCB> {
		@:privateAccess {
			if (this.currentCallback == null)
				return this;
			this.currentCallback.priority = value;
			// priorityUsed = true;
			this.requiresSort = true;
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
	public function repeat(value:Int = -1):BaseSignal<TCB> {
		@:privateAccess {
			if (this.currentCallback == null)
				return this;
			this.currentCallback.repeat = value;
		}
		return this;
	}

	/**
	 * Use the .fireOnAdd method that if called will immediately call the most recently added callback.
	 *
	 * @return Void
	 */
	public function fireNow():Void {
		@:privateAccess {
			if (this._fireOnAdd)
				return;
			if (this.currentCallback == null)
				return;
			this._dispatch(this.currentCallback);
		}
	}
}
