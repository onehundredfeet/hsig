package signals;



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
