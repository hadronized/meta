module meta.math.vecs;

/* imports */
private {
    import std.algorithm : reduce;
    import std.math : sqrt;
    import meta.utils.traits;
} public {
}


/* TODO: add common and useful math op */
struct vec(uint D, T) if (D >= 2 && D <= 4) {
    mixin template AddCompProperties(string name, uint i) {
        mixin("
            @property T " ~ name ~ "() const {
                return _[i];
            }

            @property T " ~ name ~ "(in T v) {
                return _[i] = v;
            }");
    }

    /* components */
    private T[D] _;

    /* make vec usable such as array */
    alias _ this;

    mixin AddCompProperties!("x", 0u);
    mixin AddCompProperties!("r", 0u);
    mixin AddCompProperties!("y", 1u);
    mixin AddCompProperties!("g", 1u);
    static if (D > 2) {
        mixin AddCompProperties!("z", 2u);
        mixin AddCompProperties!("b", 2u);
    }
    static if (D > 3) {
        mixin AddCompProperties!("w", 3u);
        mixin AddCompProperties!("a", 3u);
    }

    inout(T)[D] as_array() inout @property {
        return _;
    }

    inout(T) * ptr() inout @property {
        return _.ptr;
    }


    alias D length;
    alias T value_type;

    this(P...)(P params) if (params.length <= D) {
        set_!0u(params);
    }

    /* This method recursively builds the vec */
    private void set_(uint I, H, R...)(H head, R remaining) if (I <= D) {
        static if (is(H : T)) {
            /* we can directly set the corresponding component */
            _[I] = head;
            /* and go to the next component */
            set_!(I+1)(remaining);
        } else {
            static if (Has!(H, "slice")) { /* TODO: I think we have to test if H has slice, not vec, which obviously has it */
                _[I..I+H.length] = head[];
                set_!(I+H.length)(remaining);
            } else {
                static assert (0, "cannot assign " ~ H.stringof ~ " to " ~ typeof(this).stringof);
            }
        }
    }

    /* terminal version of the set_ template method */
    private void set_(uint I)() {
    }

    /* operators */
    ref vec opAssign(in vec rhs) {
        set_!0u(rhs);
        return this;
    }

    /* make vec sliceable */
    const(T)[] opSlice(size_t x, size_t y) const {
        return _[x..y];
    }

    const(T)[] opSlice() const {
        return _;
    }

    static if (__traits(isArithmetic, T)) {
        float norm() const @property {
            return sqrt(reduce!("a + b*b")(0.0f, _));
        }

        void normalize() {
            auto n = norm;
            assert ( n ); /* TODO: float precision-lost issue */

            foreach (ref v; _)
                v /= n;
        }

        /* TODO: we can optimize this method */
        vec opBinary(string op)(in vec rhs) const if (op == "-" || op == "+") {
            vec r;
            foreach (i; 0..D)
                mixin("r[i] = _[i]" ~ op ~ "rhs[i];");
            return r;
        }

    }
}


/* common vecs */
alias vec!(2, float) vec2;
alias vec!(3, float) vec3;
alias vec!(4, float) vec4;


/* trait */
template vec_trait(V : vec!(D, T), uint D, T) {
    alias D dimension;
    alias T value_type;
}

