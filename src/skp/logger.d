/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta, a render framework
    Copyright (C) 2012 Dimitri 'skp' Sabadie <dimitri.sabadie@gmail.com> 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

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
