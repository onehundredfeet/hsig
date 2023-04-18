package signals;

class SignalCallbackData {
	public inline function new( priority:Int) {
		this.priority = priority;
	}

	public var callCount:Int = 0;
	public var repeat:Int = -1;
	public var priority:Int;
	public var remove:Bool = false;

   
}
