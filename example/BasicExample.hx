import hsig.Signal;
import hsig.Signal1;
import hsig.Signal2;
import hsig.Signal3;
import hsig.Signal4;
import hsig.BufferedSignal1;
import hsig.BufferedSignal2;

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

        var signal4 = new Signal4<String, Int, Float, Signal>();
        signal4.add((_,_,_, _) -> trace('hello world!'));
        signal4.dispatch("hi", 0, -1., null);

        var bufSignal2 = new BufferedSignal2<String, Int>();
        bufSignal2.add((a,b) -> trace('hello world! : ${a} : ${b}'));
        bufSignal2.dispatch("hi", 0);
        bufSignal2.dispatch("hi there", 0);
        bufSignal2.dispatch("hi there", 1);
        bufSignal2.dispatchDistinctAny("hi there", 1);
        bufSignal2.dispatchDistinctAny("hi there", 2);
        trace('Waiting...');
        bufSignal2.dispatchBuffered();
        bufSignal2.dispatchCollapsed();
        bufSignal2.dispatch("never", 0);
        bufSignal2.dispatch("seen", 1);
        bufSignal2.dispatchCollapsed();



        var bufSignal2 = new BufferedSignal1<String>();
        bufSignal2.add((a) -> trace('hello world! : ${a} '));
        bufSignal2.dispatchDistinct("hi");
        bufSignal2.dispatchDistinct("hi");
        bufSignal2.dispatchDistinct("hi there");
        bufSignal2.dispatchDistinct("hi there");
        trace('Waiting...');
        bufSignal2.dispatchBuffered();



    }
}