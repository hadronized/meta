module meta.wrappers.opengl.buffer;

/* TODO: we have to change a few things here, such as create a new scope class to
   handle the type of a buffer, and make buffers moar general */

/* imports */
private {
    import meta.wrappers.opengl.common;
}
public {
}

enum EBufferType {
    NONE          ,
    ARRAY         = GL_ARRAY_BUFFER,
    ELEMENT_ARRAY = GL_ELEMENT_ARRAY_BUFFER,
    TFB           = GL_TRANSFORM_FEEDBACK_BUFFER,
    UNIFORM       = GL_UNIFORM_BUFFER
}

enum EBufferUsage {
    STREAM_DRAW  = GL_STREAM_DRAW,
    STATIC_DRAW  = GL_STATIC_DRAW,
    DYNAMIC_DRAW = GL_DYNAMIC_DRAW,
    DYNAMIC_COPY = GL_DYNAMIC_COPY
}

enum EBufferAccess {
    READ       = GL_READ_ONLY,
    WRITE      = GL_WRITE_ONLY,
    READ_WRITE = GL_READ_WRITE
}

class CBuffer {
    mixin MTGLObject!uint;

    this() {
        glGenBuffers(1, &_id);
        assert ( _id );
        fetch_error("this()");
    }

    ~this() {
        glDeleteBuffers(1, &_id);
    }
}

struct SBufferBinder {
    mixin MTGLError;

    private EBufferType _type;

    this(const CBuffer b, EBufferType t) in {
        assert ( b !is null );
    } body {
        bind(b, t);
    }

    ~this() {
        glBindBuffer(_type, 0);
    }

    void bind(const CBuffer b, EBufferType t) in {
        assert ( b !is null );
    } body {
        _type = t;
        glBindBuffer(t, b.id);
        fetch_error("bind()");
    }

    void commit(ulong size, void *data, EBufferUsage usage) {
        glBufferData(_type, size, data, usage);
        fetch_error("commit()");
    }

    void update(int offset, uint size, void *data) {
        glBufferSubData(_type, offset, size, data);
        fetch_error("update()");
    }

    void * map(EBufferAccess a) {
        auto mapped = glMapBuffer(_type, a);
        fetch_error("map()");
        return mapped;
    }

    void * map(int offset, uint length, EBufferAccess a) {
        auto mapped = glMapBufferRange(_type, offset, length, a);
        fetch_error("map() range");
        return mapped;
    }

    bool unmap() {
        auto r = glUnmapBuffer(_type);
        fetch_error("unnap()");
        return r == GL_TRUE;
    }
}
