module meta.utils.traits;

public import std.traits;

void has(T, string trait)() if (trait == "slice") {
    T foo;
    auto bar = foo[1..2];
    auto zoo = foo[];
}
