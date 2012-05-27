module meta.views.core.opengl.glsl;

private {
    import meta.views.core.opengl.gl;
    import meta.utils.traits;
}
public {
    import meta.ath.vecs;
}

mixin template GLSLObject() {
    mixin GLObject!GLint;

    public immutable string name;

    @property {
        GLint active() const {
            return _id != T.init;
        }

        GLint ninit() const {
            return -1;
        }
    }

    this(string name) {
        this.name = name;
    }
}

/* attribute */
class attribute(T) {
    mixin GLSLObject;

    this(string name) {
        super(name);
        _id = init;
    }

    void enable() {
        glEnableVertexAttribArray(_id);
        fetch_error("enable()");
    }

    void disable() {
        glDisableVertexAttribArray(_id);
        fetch_error("disable()");
    }

    void map(shader_program sp) {
        auto ptr = name.ptr;
        GLint l = glGetAttribLocation(sp.id, &name);
        fetch_error("map()");
        _id = l;
    }

    /* static if to determine if T is simple int, float, or what */
    static if (__trait(isArithmetic, T)) {
        mixin("
            void push(" ~ T.stringof ~ " x) {
                glVertexAttrib1" ~ T.stringof[0] ~ "(_id, x);
            }

            void pointer(" ~ T.stringof ~ " *p, uint stride, bool normalized) {
                glVertexAttribPointer(_id, 1, " ~ GLTypeOf!T ~ ", normalized, stride, p);
            }
        ");
    }

    /* static if to determine if T is vec */
    //    static if (Compatible!(T, "array")) {
    /* static if to determine if T is matrix */
}
