module meta.wrappers.opengl.renderbuffer;

/* imports */
private {
    import meta.wrappers.opengl.common;
}

class CRenderbuffer {
   mixin MTGLObject!uint;

   this() {
       glGenRenderbuffers(1, &_id);
       assert ( _id );
       fetch_error("this");
   }

   ~this() {
       glDeleteRenderbuffers(1, &_id);
   }
}

enum ERenderbufferTarget {
    RENDERBUFFER = GL_RENDERBUFFER
}

struct SRenderBufferBinder {
    mixin MTGLError;

    private ERenderbufferTarget _target;

    this(const CRenderbuffer rb, ERenderbufferTarget t) in {
        assert ( rb !is null );
    } body {
        bind(rb, t);
    }

    ~this() {
        glBindRenderbuffer(_target, 0);
    }

    void bind(const CRenderbuffer rb, ERenderbufferTarget t) in {
        assert ( rb !is null );
    } body {
		_target = t;
        glBindRenderbuffer(t, rb.id);
        fetch_error("bind");
    }
}


