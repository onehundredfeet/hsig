import signals.Signal;
import signals.Signal1;
import signals.Signal2;
import signals.Signal3;

class BasicExample
{
    static function main()
    {
        var signal0 = new Signal();
        signal0.add(() -> trace('hello world!'));
        signal0.dispatch();

        var signal1 = new Signal1<String>();
        signal1.add((_) -> trace('hello world!'));
        signal1.dispatch("hi");

        var signal2 = new Signal2<String, Int>();
        signal2.add((_,_) -> trace('hello world!'));
        signal2.dispatch("hi", 0);

        var signal3 = new Signal3<String, Int, Float>();
        signal3.add((_,_,_) -> trace('hello world!'));
        signal3.dispatch("hi", 0, -1.);
    }
}