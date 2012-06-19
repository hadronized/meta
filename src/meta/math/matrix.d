module meta.math.matrix;

/* imports */
private {
    import std.math;
}
public {
}


/* for now, mat is just a 4x4 matrix */
struct mat {
    private float[4][4] _;
    alias _ this;

    inout(float) * ptr() inout @property {
        return _.ptr.ptr;
    }
}


/* main matrix generators */
mat make_perspective(float fovy, float ratio, float znear, float zfar) in {
    assert ( fovy > 0f );
    assert ( ratio > 0f );
    assert ( znear < zfar );
} body {
    float itanfovy = 1 / tan(fovy / 2);
    float itanfovyr = itanfovy / ratio;
    float inf = 1 / (znear - zfar);
    float nfinf = (znear + zfar) * inf;

    return mat([
            [ itanfovyr,       0f,  0f,    0f ],
            [        0f, itanfovy,  0f,    0f ],
            [        0f,       0f, inf,   -1f ], 
            [        0f,       0f, nfinf,  0f ]
    ]);
}
