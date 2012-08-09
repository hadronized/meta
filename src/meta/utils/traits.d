module meta.utils.traits;

public import std.traits;

template Has(T, string Q) if (Q == "slice") {
    static if (is(T == class) || is(T == struct))
        enum Has = __traits(hasMember, T, "opSlice");
    else
        enum Has = isArray!T;
}

template Like(T, string Q) if (Q == "array") {
    enum Like = Has!(T, "slice");
}
