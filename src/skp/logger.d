module skp.logger;

import std.stdio;
import std.datetime;
import skp.singleton;

class CLogger {
    mixin MTSingleton!CLogger;

    /* TODO: problem with the first %s that sometimes over fails depending on what Clock.currTime() returns. */
    mixin template MTAddLogMethod(string name, string stream) {
        static if (name == "deb") {
            mixin("void " ~ name ~ "(A...)(A args) {
                debug " ~ stream ~ ".writef(\"%s | %-7s > \", Clock.currTime(), \"" ~ name ~ "\");
                debug " ~ stream ~ ".writefln(args);
            }");
        } else {
            mixin("void " ~ name ~ "(A...)(A args) {
                " ~ stream ~ ".writef(\"%s | %-7s > \", Clock.currTime(), \"" ~ name ~ "\");
                " ~ stream ~ ".writefln(args);
            }");
        }
    }
    
    mixin MTAddLogMethod!("info", "stdout");
    mixin MTAddLogMethod!("deb", "stdout");
    mixin MTAddLogMethod!("warning", "stderr");
    mixin MTAddLogMethod!("error", "stderr");
}
