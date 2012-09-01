module meta.math.matrix;

/* imports */
private {
    import std.math : tan;
}
public {
}

struct SMat44 {
    private alias typeof(this) that;

    private float[16] _;

    @property {
        that init() {
            that r = void;
            foreach (i; 0..4) {
                r[i,i] = 1.0f;
                foreach (j; (i+1)..4) 
                    r[i,j] = r[j,i] = 0.0f;
            }
            return r;
        }

        inout(float) * ptr() inout {
            return _.ptr;
        }
    }

    ref that opAssign(in that rhs) {
        _[] = rhs._[];
        return this;
    }

    ref float opIndex(size_t i, size_t j) {
        assert ( i < 4 );
        assert ( j < 4 );
        return _[i*4+j];
    }

    ref that opOpAssign(string O_)(in that rhs) if (O_ == "*") {
        that m = void;
        foreach (i; 0..4) {
            foreach (j; 0..4) {
                m[i,j] = 0.0f;
                foreach (k; 0..4)
                    m[i,j] += this[i,k] * rhs[k, j];
            }
        }

        this = m;
        return this;
    }

    that opBinary(string O_)(that lhs, in that rhs) if (O_ == "*") {
        lhs *= rhs;
        return lhs;
    }
}

/* matrix generators */
SMat44 make_perspective(float fovy, float ratio, float znear, float zfar) in {
    assert ( fovy > 0.0f );
    assert ( ratio > 0.0f );
    assert ( znear < zfar );
} body {
    float itanfovy = 1.0f / tan(fovy / 2.0f);
    float itanfovyr = itanfovy / ratio;
    float inf = 1.0f / (znear - zfar);
    float nfinf = (znear + zfar) * inf;

    return SMat44([
            itanfovyr,     0.0f,  0.0f,    0.0f,
                 0.0f, itanfovy,  0.0f,    0.0f,
                 0.0f,     0.0f,   inf,   -1.0f, 
                 0.0f,     0.0f, nfinf,    0.0f 
    ]);
}
