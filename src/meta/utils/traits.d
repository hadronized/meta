module meta.utils.traits;

public import std.traits;

/* designed to be used with is(typeof()) or __trait(compiles, ()) */
void has(T, string trait)() if (trait == "slice") {
    T foo;
    auto bar = foo[1..2];
    auto zoo = foo[];
}


template Compatible(T, string Q) {
    static if (Q == "array") {
        enum Compatible = __traits(compiles, () => {
                has!(T, "slice");
            });
    } else {
        static assert(false, Q ~ " is not a valid compatibility test!");
    }
}
