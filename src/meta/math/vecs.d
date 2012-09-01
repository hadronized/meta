module meta.math.vecs;

/* imports */
private {
    import std.algorithm : reduce;
    import std.math : sqrt;
    import skp.traits;
} public {
}

/* TODO: add common and useful math op */
struct SVec(uint D_, T_) if (D_ >= 2 && D_ <= 4) {
    private alias typeof(this) that;

    mixin template MTAddCompProperties(string N_, uint I_) {
        mixin("
            @property T_ " ~ N_ ~ "() const {
                return _[I_];
            }

            @property T_ " ~ N_ ~ "(in T_ v) {
                return _[I_] = v;
            }");
    }

    /* components */
    private T_[D_] _;

    mixin MTAddCompProperties!("x", 0u);
    mixin MTAddCompProperties!("r", 0u);
    mixin MTAddCompProperties!("y", 1u);
    mixin MTAddCompProperties!("g", 1u);
    static if (D_ > 2) {
        mixin MTAddCompProperties!("z", 2u);
        mixin MTAddCompProperties!("b", 2u);
    }
    static if (D_ > 3) {
        mixin MTAddCompProperties!("w", 3u);
        mixin MTAddCompProperties!("a", 3u);
    }

    inout(T_)[D_] as_array() inout @property {
        return _;
    }

    inout(T_) * ptr() inout @property {
        return _.ptr;
    }

    alias D_ length;
    alias T_ value_type;

    this(P...)(P params) if (params.length <= D_) {
        set_!0u(params);
    }

    /* This method recursively builds the SVec */
    private void set_(uint I_, H_, R_...)(H_ head, R_ remaining) if (I_ <= D_) {
        static if (is(H_ : T_)) {
            /* we can directly set the corresponding component */
            _[I_] = head;
            /* and go to the next component */
            set_!(I_+1)(remaining);
        } else {
            static if (THas!(H_, "slice")) { /* TODO: I think we have to test if H has slice, not SVec, which obviously has it */
                _[I_..I_+H_.length] = head[];
                set_!(I_+H_.length)(remaining);
            } else {
                static assert (0, "cannot assign " ~ H_.stringof ~ " to " ~ typeof(this).stringof);
            }
        }
    }

    /* terminal version of the set_ template method */
    private void set_(uint I_)() {
    }

    /* operators */
    ref that opAssign(in that rhs) {
        set_!0u(rhs);
        return this;
    }

    /* make SVec sliceable */
    const(T_)[] opSlice(size_t x, size_t y) const {
        return _[x..y];
    }

    const(T_)[] opSlice() const {
        return _;
    }

    ref T_ opIndex(size_t i) {
        assert ( i < D_ );
        return _[i];
    }

    static if (__traits(isArithmetic, T_)) {
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
        that opBinary(string O_)(in that rhs) if (O_ == "-" || O_ == "+") {
            that r = void;
            foreach (i; 0..D_)
                mixin("r[i] = _[i]" ~ O_ ~ "rhs[i];");
            return r;
        }

        that opBinary(string O_, S_)(S_ s) if (O_ == "/" || O_ == "*") in {
            static if (O_ == "/")
                assert ( O_ != 0.0f );
        } body {
            that r = void;
            foreach (i; 0..D_)
                mixin("r[i] = _[i]" ~ O_ ~ " s;");
            return r;
        }

        /*
        that opBinaryRight(string O_, S_)(S_ s) {
            return opBinary!(O_)(s);
        }
        */

        ref that opOpAssign(string op, A_)(A_ v) if (op == "/" || op == "*") {
            foreach (ref x; _)
                mixin("x" ~ op ~ "= v;");
            return this;
        }

        static if (D_ == 3) {
            auto opCast(SMat44)() {
                SMat44 r;
                foreach (i; 0..D_)
                    r[i,3] = _[i];
                return r;
            }
        }
    }
}

/* common SVecs */
alias SVec!(2, float) SVec2;
alias SVec!(3, float) SVec3;
alias SVec!(4, float) SVec4;

/* trait */
template TVecTrait(V_ : SVec!(D_, T_), uint D_, T_) {
    alias D_ dimension;
    alias T_ value_type;
}
