module meta.test.has;

import std.stdio;
import meta.utils.math.vecs;
import meta.utils.logger;
import meta.utils.memory;
import meta.utils.traits;

int main() {
    static if (__traits(compiles, has!(vec!(3, float), "slice")))
        writeln("vec!(3, float) are sliceable!");

    alias vec!(4, float) vec4;
    alias vec!(3, float) vec3;
    alias vec!(2, float) vec2;

    auto v = spawn!vec3(3, 1, 4);
    v.x = 4;
    auto v2 = spawn!vec2(0, 1);
    auto vc = spawn!vec3(314, v2);
    auto v4 = spawn!vec4(v2, v2);

    logger.inst().deb("v=%s ; v2=%s ; vc=%s ; v4=%s", v, v2, vc, v4);

    return 0;
}