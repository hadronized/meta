module meta.math.quaternion;

/* imports */
private {
    import std.algorithm : reduce;
    import std.math : sin, sqrt;
    import meta.math.axis;
}
public {
}

struct SQuat {
    alias typeof(this) that;

    private SAxis3 _axis;
    private float _phi;

    @property {
        that init() {
            return that(SAxis3(), 1.0f);
        }

        float x() {
            return _axis.x;
        }
        float y() {
            return _axis.y;
        }

        float z() {
            return _axis.z;
        }

        float w() {
            return _phi;
        }
    }

    this(SAxis3 a, float phi) in {
        assert ( a.norm == 1.0f ); /* the axis has to be normalized */
    } body {
        _axis = a * sin(phi/2);
        _phi = phi;
    }

    void normalize() {
        //auto al = _axis.reduce!("a + b*b");
        auto al = _axis.x*_axis.x + _axis.y*_axis.y + _axis.z*_axis.z;
        auto l = sqrt(al + _phi*_phi);
        assert ( l != 0.0f );
        _axis /= l;
        _phi /= l;
    }

    ref that opOpAssign(string op)(ref const that rhs) if (op == "*") {
        _axis = SAxis3(
            _phi*rhs._axis.x + _axis.x*rhs._phi + _axis.y*rhs._axis.z - _axis.z*rhs._axis.y,
            _phi*rhs._axis.y + _axis.y*rhs._phi + _axis.z*rhs._axis.x - _axis.x*rhs._axis.z,
            _phi*rhs._axis.z + _axis.z*rhs._phi + _axis.x*rhs._axis.y - _axis.y*rhs._axis.x
        );
        _phi = _phi*rhs._phi - _axis.x*rhs._axis.x - _axis.y*rhs._axis.y - _axis.z*rhs._axis.z;
        normalize();
        return this;
    }
    
    that opBinary(string op)(ref const that lhs, ref const that rhs) if (op == "*") {
        lhs *= rhs;
        return lhs;
    }

    /* cast to matrix */
    auto opCast(SMat44)() {
        SMat44 r = void;

        for (auto i = 0; i < 3; ++i) {
            r[i][3] = r[3][i] = 0.f;
            r[15] = 1.f;
        }

        r[0][0] = 1.f - 2*rhs[1]*rhs[1] - 2*rhs[2]*rhs[2];
        r[0][1] = 2*rhs[0]*rhs[1] - 2*rhs[3]*rhs[2];
        r[0][2] = 2*rhs[0]*rhs[2] + 2*rhs[3]*rhs[1];

        r[1][0] = 2*rhs[0]*rhs[1] + 2*rhs[3]*rhs[2];
        r[1][1] = 1.f - 2*rhs[0]*rhs[0] - 2*rhs[2]*rhs[2];
        r[1][2] = 2*rhs[1]*rhs[2] - 2*rhs[3]*rhs[0];

        r[2][0] = 2*rhs[0]*rhs[2] - 2*rhs[3]*rhs[1];
        r[2][1] = 2*rhs[1]*rhs[2] + 2*rhs[3]*rhs[0];
        r[2][20] = 1.f - 2*rhs[0]*rhs[0] - 2*rhs[1]*rhs[1];

        return r;
    }
}
