module meta.wrappers.opengl.texture;

/* imports */
private {
    import meta.wrappers.opengl.common;
    import meta.wrappers.opengl.type;
}
public {
}


/* unit texture */
alias typeof(GL_TEXTURE0) texture_unit;
template unit(int u) {
    enum unit = GL_TEXTURE0 + u;
}


/* texture types */
alias typeof(GL_TEXTURE_2D) texture_type;
alias GL_TEXTURE_2D TT_2D;
alias GL_TEXTURE_1D_ARRAY TT_1D_ARRAY;
alias GL_TEXTURE_RECTANGLE TT_RECTANGLE;

/* internal formats */
alias typeof(GL_RED) texture_internal_format;
alias GL_RED TIF_RED;
alias GL_RG TIF_RG;
alias GL_RGB TIF_RGB;
alias GL_RGBA TIF_RGBA;
alias GL_DEPTH_COMPONENT TIF_DEPTH_COMPONENT;
alias GL_DEPTH_STENCIL TIF_DEPTH_STENCIL;

/* formats */
alias typeof(GL_RED) texture_format;
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
alias typeof(GL_TEXTURE_WRAP_S) texture_parameter;
alias typeof(GL_NEAREST) texture_parameter_value;

/* wrap */
alias texture_parameter texture_wrap;
alias GL_TEXTURE_WRAP_S TW_S;
alias GL_TEXTURE_WRAP_T TW_T;
alias GL_TEXTURE_WRAP_R TW_R;

/* filter */
alias texture_parameter texture_filter;
alias GL_TEXTURE_MIN_FILTER TF_MIN;
alias GL_TEXTURE_MAG_FILTER TF_MAG;


class texture {
    mixin GLObject!uint;

    this() {
        glGenTextures(1, &_id);
        fetch_error("ctor()");
    }

    ~this() {
        glDeleteTextures(1, &_id);
    }

    void unit(texture_unit u) @property {
        glActiveTexture(u);
        fetch_error("unit()");
    }
}

class bind_error : runtime_error {
    this(string reason) {
        super("unable to bind a texture; reason: " ~ reason);
    }
}

scope class texture_binder {
    mixin GLError;

    private texture_type _target;

    this(texture t, texture_type target) {
        bind_(t, target);
    }

    ~this() {
        bind_(null, _target);
    }

    private void bind_(texture t, texture_type target) {
        if (t is null) {
            if (target != _target)
                throw new bind_error("incompatible targets");
            glBindTexture(_target, 0);
        } else {
            glBindTexture(target, t.id);
            fetch_error("bind()");
            _target = target;
        }
    }

    void bind(texture t, texture_type target) {
        bind_(t, target);
    }

    void texels(int level, texture_internal_format internal, uint w, uint h, int border, texture_format format, gltype type, void *data) {
        glTexImage2D(_target, level, internal, w, h, border, format, type, data);
        fetch_error("texels()");
    }

    void parameter(texture_parameter param, texture_parameter_value value) {
        glTexParameteri(_target, param, value);
        fetch_error("parameter()");
    }
}
