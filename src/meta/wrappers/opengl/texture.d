module meta.wrappers.opengl.texture;

/* imports */
private {
    import meta.wrappers.opengl.common;
    import meta.wrappers.opengl.type;
}
public {
}

/* unit texture */
alias typeof(GL_TEXTURE0) texture_unit_t;
template TUnit(int u) {
    enum TUnit = GL_TEXTURE0 + u;
}

/* texture types */
alias typeof(GL_TEXTURE_2D) texture_type_t;
alias GL_TEXTURE_2D TT_2D;
alias GL_TEXTURE_1D_ARRAY TT_1D_ARRAY;
alias GL_TEXTURE_RECTANGLE TT_RECTANGLE;

/* internal formats */
alias typeof(GL_RED) texture_internal_format_t;
alias GL_RED TIF_RED;
alias GL_RG TIF_RG;
alias GL_RGB TIF_RGB;
alias GL_RGBA TIF_RGBA;
alias GL_DEPTH_COMPONENT TIF_DEPTH_COMPONENT;
alias GL_DEPTH_STENCIL TIF_DEPTH_STENCIL;

/* formats */
alias typeof(GL_RED) texture_format_t;
alias GL_RED TF_RED;
alias GL_GREEN TF_GREEN;
alias GL_BLUE TF_BLUE;
alias GL_RG TF_RG;
alias GL_RGB TF_RGB;
alias GL_RGBA TF_RGBA;
alias GL_BGR TF_BGR;
alias GL_BGRA TF_BGRA;
alias GL_DEPTH_STENCIL TF_DEPTH_STENCIL;
alias GL_DEPTH_COMPONENT TF_DEPTH_COMPONENT;
alias GL_STENCIL_INDEX TF_STENCIL_INDEX;

/* texture parameter */
alias typeof(GL_TEXTURE_WRAP_S) texture_parameter_t;
alias typeof(GL_NEAREST) texture_parameter_value_t;

/* wrap */
alias texture_parameter_t texture_wrap_t;
alias GL_TEXTURE_WRAP_S TW_S;
alias GL_TEXTURE_WRAP_T TW_T;
alias GL_TEXTURE_WRAP_R TW_R;

/* filter */
alias texture_parameter_t texture_filter_t;
alias GL_TEXTURE_MIN_FILTER TF_MIN;
alias GL_TEXTURE_MAG_FILTER TF_MAG;

class CTexture {
    mixin MTGLObject!uint;

    this() {
        glGenTextures(1, &_id);
        fetch_error("ctor()");
    }

    ~this() {
        glDeleteTextures(1, &_id);
    }

    void unit(texture_unit_t u) @property {
        glActiveTexture(u);
        fetch_error("unit()");
    }
}

class CBindError : CRuntimeError {
    this(string reason) {
        super("unable to bind a texture; reason: " ~ reason);
    }
}

scope class CTextureBinder {
    mixin MTGLError;

    private texture_type_t _target;

    this(CTexture t, texture_type_t target) {
        bind_(t, target);
    }

    ~this() {
        bind_(null, _target);
    }

    private void bind_(CTexture t, texture_type_t target) {
        if (t is null) {
            if (target != _target)
                throw new CBindError("incompatible targets");
            glBindTexture(_target, 0);
        } else {
            glBindTexture(target, t.id);
            fetch_error("bind()");
            _target = target;
        }
    }

    void bind(CTexture t, texture_type_t target) {
        bind_(t, target);
    }

    void texels(int level, texture_internal_format_t internal, uint w, uint h, int border, texture_format_t format, EGLType type, void *data) {
        glTexImage2D(_target, level, internal, w, h, border, format, type, data);
        fetch_error("texels()");
    }

    void parameter(texture_parameter_t param, texture_parameter_value_t value) {
        glTexParameteri(_target, param, value);
        fetch_error("parameter()");
    }
}
