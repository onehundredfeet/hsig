package hsig;



interface IBaseSignal {
    function isFireOnAdd():Bool;
    function remove( cb : SignalCallbackData ) : Void;
    function setDirty():Void;
}