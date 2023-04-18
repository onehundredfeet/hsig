package hsig;

private class Signal2CallbackData<T0, T1> extends SignalCallbackData {

	public var callback:(T0,T1)->Void;
	public function new(callback:(T0,T1)->Void, priority:Int) {
		super( priority);
		this.callback = callback;
	}
}

@:expose("Signal2")
class Signal2<T0, T1> extends BaseSignal<Signal2CallbackData<T0, T1>> {
	public var value1:T0;
	public var value2:T1;

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
	 public function add(callback:(T0, T1)->Void, priority = 0):SignalOptions<Signal2CallbackData<T0,T1>> {
		currentCallback = new Signal2CallbackData(callback, priority);
		callbacks.push(currentCallback);

		if (this._fireOnAdd == true) {
			callback(value1,value2);
		}

		return this;
	}

	final inline override function _dispatch(cb: Signal2CallbackData<T0, T1>) {
		cb.callCount++;
		cb.callback(value1, value2);
	}


	public inline function dispatch(value1:T0, value2:T1) {
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		dispatchCallbacks();
	}

	public function dispatchDistinctAny(value1:T0, value2:T1) {
		if (this.value1 == value1 && this.value2 == value2) {
			return;
		}
		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		dispatchCallbacks();
	}

	public function dispatchDistinctAll(value1:T0, value2:T1) {
		if (this.value1 == value1 || this.value2 == value2) {
			return;
		}

		sortPriority();
		this.value1 = value1;
		this.value2 = value2;
		dispatchCallbacks();
	}

	public function remove(callback:(T0, T1)->Void):Void {
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
