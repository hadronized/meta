module skp.traits;

public import std.traits;

template THas(T_, string Q_) if (Q_ == "slice") {
    static if (is(T_ == class) || is(T_ == struct))
        enum THas = __traits(hasMember, T_, "opSlice");
    else
        enum THas = isArray!T_;
}

template TLike(T_, string Q_) if (Q_ == "array") {
    enum TLike = THas!(T_, "slice");
}
