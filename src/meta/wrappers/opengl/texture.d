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

enum ETextureTarget {
    TWO_D = GL_TEXTURE_2D,
    ARRAY_1D = GL_TEXTURE_1D_ARRAY,
    RECTANGL = GL_TEXTURE_RECTANGLE
}

/* internal formats */
alias typeof(GL_RED) texture_internal_format_t;
alias GL_RED TIF_RED;
alias GL_RG TIF_RG;
alias GL_RGB TIF_RGB;
alias GL_RGBA TIF_RGBA;
alias GL_DEPTH_COMPONENT TIF_DEPTH_COMPONENT;
alias GL_DEPTH_STENCIL TIF_DEPTH_STENCIL;

enum ETextureIntFormat {
    R = GL_RED,
    RG = GL_RG,
    RGB = GL_RGB,
    RGBA = GL_RGBA,
    DEPTH_COMPONENT = GL_DEPTH_COMPONENT,
    DEPTH_STENCIL = GL_DEPTH_STENCIL
}

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

enum ETextureFormat {
    R = GL_RED,
    G = GL_GREEN,
    B = GL_BLUE,
    RG = GL_RG,
    RGB = GL_RGB,
    RGBA = GL_RGBA,
    BGR = GL_BGR,
    BGRA = GL_BGRA,
    DEPTH_COMPONENT = GL_DEPTH_COMPONENT,
    DEPTH_STENCIL = GL_DEPTH_STENCIL
}

/* texture parameter */
alias typeof(GL_TEXTURE_WRAP_S) texture_parameter_t;
alias typeof(GL_NEAREST) texture_parameter_value_t;

/* wrap */
alias texture_parameter_t texture_wrap_t;
alias GL_TEXTURE_WRAP_S TW_S;
alias GL_TEXTURE_WRAP_T TW_T;
alias GL_TEXTURE_WRAP_R TW_R;

enum ETextureParamWrap {
    S = GL_TEXTURE_WRAP_S,
    T = GL_TEXTURE_WRAP_T,
    R = GL_TEXTURE_WRAP_R
}

/* filter */
alias texture_parameter_t texture_filter_t;
alias GL_TEXTURE_MIN_FILTER TF_MIN;
alias GL_TEXTURE_MAG_FILTER TF_MAG;

enum ETextureParamFilter {
    MIN = GL_TEXTURE_MIN_FILTER,
    MAG = GL_TEXTURE_MAG_FILTER
}

class CTexture {
    mixin MTGLObject!uint;

    this() {
        glGenTextures(1, &_id);
        fetch_error("this");
    }

    ~this() {
        glDeleteTextures(1, &_id);
    }

    /* TODO: not very good here… */
    void unit(texture_unit_t u) @property {
        glActiveTexture(u);
        fetch_error("unit");
    }
}

struct STextureBinder {
    mixin MTGLError;

    private ETextureTarget _target;

    this(CTexture t, ETextureTarget target) {
        bind(t, target);
    }

    ~this() {
        glBindTexture(_target, 0);
    }

    private void bind(CTexture t, ETextureTarget target) in {
        assert ( t !is null );
    } body {
        glBindTexture(target, t.id);
        fetch_error("bind");
        _target = target;
    }

    void commit(int level, texture_internal_format_t internal, uint w, uint h, int border, texture_format_t format, EGLType type, void *data) {
        glTexImage2D(_target, level, internal, w, h, border, format, type, data);
        fetch_error("commit");
    }

    void parameter(texture_parameter_t param, texture_parameter_value_t value) {
        glTexParameteri(_target, param, value);
        fetch_error("parameter");
    }
}

class CBindError : CRuntimeError {
    this(string reason) {
        super("unable to bind a texture; reason: " ~ reason);
    }
}
