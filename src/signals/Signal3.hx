package signals;
private class Signal3CallbackData<T0, T1, T2> extends SignalCallbackData {

	public var callback:(T0,T1,T2)->Void;
	public function new(callback:(T0,T1,T2)->Void, priority:Int) {
		super( priority);
		this.callback = callback;
	}
}


@:expose("Signal3")
class Signal3<T0, T1, T2> extends BaseSignal<Signal3CallbackData<T0, T1, T2>> {
	public var value1:T0;
	public var value2:T1;
	public var value3:T2;


	public function new(?fireOnAdd:Bool = false) {
		super(fireOnAdd);
	}

	final inline override function _dispatch(cb: Signal3CallbackData<T0, T1, T2>) {
		cb.callCount++;
		cb.callback(value1, value2, value3);
	}

	/**
	 * Use the .add method to register callbacks to be fired upon signal.dispatch
	 *
	 * @param callback A callback function which will be called when the signal's ditpatch method is fired.
	 *
	 * @return BaseSignal
	 */
	 public function add(callback:(T0, T1, T2)->Void, priority = 0):SignalOptions<Signal3CallbackData<T0,T1,T2>> {
		currentCallback = new Signal3CallbackData(callback, priority);
		callbacks.push(currentCallback);

		if (this._fireOnAdd == true) {
			callback(value1,value2, value3);
		}

		return this;
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

	public function remove(callback:(T0, T1,T2)->Void):Void {
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
