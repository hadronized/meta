module meta.test.singleton;

import std.datetime;
import std.stdio;
import meta.utils.singleton;

class foo {
    mixin Singleton!foo;

    private int _a;

    void set_a(int a) {
        _a = a;
    }
}

int main(string[] args) {
    writeln("Hello, world!");

    foo.inst().set_a(314);

    auto currtime = Clock.currTime();
    auto strtime = currtime.toString();

    writefln("Date of the day: %s", strtime);
    return 0;
}