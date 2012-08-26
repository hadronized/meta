module meta.wrappers.opengl.framebuffer;

/* imports */
private {
    import meta.wrappers.opengl.common;
    import meta.wrappers.opengl.renderbuffer;
    import meta.wrappers.opengl.texture;
}

class CFramebuffer {
    mixin MTGLObject!uint;

    this() {
        glGenFramebuffers(1, &_id);
        assert ( _id );
        fetch_error("this");
    }

    ~this() {
        glDeleteFramebuffers(1, &_id);
    }
}

enum EFramebufferTarget {
    DRAW = GL_DRAW_FRAMEBUFFER,
    READ = GL_READ_FRAMEBUFFER
}


template TFramebufferColorAttachment(int I_) {
    enum TFramebufferColorAttachment = GL_COLOR_ATTACHMENT0+I_;
}

enum EFramebufferAttachment {
    DEPTH = GL_DEPTH_ATTACHMENT,
    STENCIL = GL_STENCIL_ATTACHMENT,
    DEPTH_STENCIL = GL_DEPTH_STENCIL_ATTACHMENT
}

struct SFramebufferBinder {
    mixin MTGLError;

    private EFramebufferTarget _target;

    this(const CFramebuffer fb, EFramebufferTarget t) in {
        assert ( fb !is null );
    } body {
        bind(fb, t);
    }

    ~this() {
        glBindFramebuffer(_target, 0);
    }

    void bind(const CFramebuffer fb, EFramebufferTarget t) in {
        assert ( fb !is null );
    } body {
        _target = t;
        glBindFramebuffer(t, fb.id);
        fetch_error("bind");
    }

    void attach(const CRenderbuffer rb, ERenderbufferTarget t, EFramebufferAttachment a) {
        glFramebufferRenderbuffer(_target, a, t, rb.id);
        fetch_error("attach(renderbuffer)");
    }

    void attach(const CTexture t, int level, EFramebufferAttachment a) {
        glFramebufferTexture(_target, a, t.id, level);
        fetch_error("attach(texture)");
    }

    void check_status() {
        auto v = glCheckFramebufferStatus(_target);
        fetch_error("this");

        final switch (v) {
            case GL_FRAMEBUFFER_COMPLETE :
                CLogger.inst().deb("Framebuffer complete");
                break;

            case GL_FRAMEBUFFER_UNDEFINED :
                throw new CFramebufferCompletenessError("undefined");

            case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT :
                throw new CFramebufferCompletenessError("attachment");

            case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT :
                throw new CFramebufferCompletenessError("missing attchment");

            case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER :
                throw new CFramebufferCompletenessError("draw buffer");

            case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER :
                throw new CFramebufferCompletenessError("read buffer");

            case GL_FRAMEBUFFER_UNSUPPORTED :
                throw new CFramebufferCompletenessError("unsupported");

            case GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE :
                throw new CFramebufferCompletenessError("multisample");

            case GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS :
                throw new CFramebufferCompletenessError("layer targets");
        }
    }
}

class CFramebufferCompletenessError : CRuntimeError {
    this(string reason) {
        super("framebuffer completeness violated; reason: " ~ reason);
    }
}
