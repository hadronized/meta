module meta.utils.math.vecs;

import meta.utils.traits;

/* TODO: add common and useful math op */
struct vec(uint D, T) if (D >= 2 && D <= 4) {
    mixin template AddCompProperties(string name, uint i) {
        mixin("
            @property T " ~ name ~ "() const {
                return _comp[i];
            }

            @property T " ~ name ~ "(in T v) {
                return _comp[i] = v;
            }");
    }

    /* components */
    T[D] _comp;

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

    alias D length;

    this(P...)(P params) if (params.length <= D) {
        set_!0u(params);
    }

    /* This method recursively builds the vec */
    private void set_(uint I, H, R...)(H head, R remaining) if (I <= D) {
        static if (is(H : T)) {
            /* we can directly set the corresponding component */
            _comp[I] = head;
            /* and go to the next component */
            set_!(I+1)(remaining);
        } else {
            static if (__traits(compiles, has!(vec!(D, T), "slice"))) {
                _comp[I..I+H.length] = head[];
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
    ref vec opAssign(const ref vec rhs) {
        set_!0u(rhs);
        return this;
    }

    /* make vec sliceable */
    const(T)[] opSlice(size_t x, size_t y) const {
        return _comp[x..y];
    }

    const(T)[] opSlice() const {
        return _comp;
    }
}

/* common vecs */
alias vec!(2, float) vec2;
alias vec!(3, float) vec3;
alias vec!(4, float) vec4;