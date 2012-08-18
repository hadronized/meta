module meta.math.matrix;

/* imports */
private {
    import std.math;
}
public {
}

struct SMat44 {
    private float[4][4] _;
    alias _ this;

    inout(float) * ptr() inout @property {
        return _.ptr.ptr;
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
            [ itanfovyr,     0.0f,  0.0f,    0.0f ],
            [      0.0f, itanfovy,  0.0f,    0.0f ],
            [      0.0f,     0.0f,   inf,   -1.0f ], 
            [      0.0f,     0.0f, nfinf,    0.0f ]
    ]);
}
