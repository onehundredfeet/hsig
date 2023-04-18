package signals;

private class Signal1CallbackData<T> extends SignalCallbackData {

	public var callback:(T)->Void;
	public function new(callback:(T)->Void, priority:Int) {
		super( priority);
		this.callback = callback;
	}
}

@:expose("Signal1")
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
	 public function add(callback:(T)->Void, priority = 0):SignalOptions<Signal1CallbackData<T>> {
		currentCallback = new Signal1CallbackData(callback, priority);
		callbacks.push(currentCallback);

		if (this._fireOnAdd == true) {
			callback(value);
		}

		return this;
	}

	final inline override function _dispatch(cb: Signal1CallbackData<T>) {
		cb.callCount++;
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

	public function remove(callback:(T)->Void):Void {
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
