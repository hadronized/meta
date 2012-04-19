module meta.utils.logger;

import std.stdio;
import std.datetime;
import meta.utils.singleton;

class logger {
    mixin Singleton!logger;

    /* TODO: problem with the first %s that sometimes over fails depending on what Clock.currTime() returns. */
    mixin template AddLogMethod(string name, string stream) {
        mixin("void " ~ name ~ "(A...)(A args) {
            " ~ stream ~ ".writef(\"%s | %-7s > \", Clock.currTime(), \"" ~ name ~ "\");
            writefln(args);
        }");
    }
    
    mixin AddLogMethod!("info", "stdout");
    mixin AddLogMethod!("deb", "stdout");
    mixin AddLogMethod!("warning", "stderr");
    mixin AddLogMethod!("error", "stderr");
}
