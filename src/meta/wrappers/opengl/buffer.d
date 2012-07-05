module meta.wrappers.opengl.buffer;

/* TODO: we have to change a few things here, such as create a new scope class to
   handle the type of a buffer, and make buffers moar general */

/* imports */
private {
    import meta.wrappers.opengl.common;
}
public {
}


enum buffer_type {
    NONE          ,
    ARRAY         = GL_ARRAY_BUFFER,
    ELEMENT_ARRAY = GL_ELEMENT_ARRAY_BUFFER,
    TFB           = GL_TRANSFORM_FEEDBACK_BUFFER,
    UNIFORM       = GL_UNIFORM_BUFFER
}

enum buffer_usage {
    STREAM_DRAW  = GL_STREAM_DRAW,
    STATIC_DRAW  = GL_STATIC_DRAW,
    DYNAMIC_DRAW = GL_DYNAMIC_DRAW,
    DYNAMIC_COPY = GL_DYNAMIC_COPY
}

enum buffer_access {
    READ       = GL_READ_ONLY,
    WRITE      = GL_WRITE_ONLY,
    READ_WRITE = GL_READ_WRITE
}

class buffer {
    mixin GLObject!uint;

    this() {
        glGenBuffers(1, &_id);
        assert ( _id );
        fetch_error("this()");
    }

    ~this() {
        glDeleteBuffers(1, &_id);
    }
}

scope class bound_buffer {
    mixin GLError;

    immutable buffer_type _type;

    this(const buffer b, buffer_type t) {
        glBindBuffer(t, b.id);
        fetch_error("bind()");
        _type = t;
    }

    ~this() {
        glBindBuffer(_type, 0);
    }

    void commit(uint size, void *data, buffer_usage usage) {
        glBufferData(_type, size, data, usage);
        fetch_error("commit()");
    }

    void update(int offset, uint size, void *data) {
        glBufferSubData(_type, offset, size, data);
        fetch_error("update()");
    }

    void * map(buffer_access a) {
        auto mapped = glMapBuffer(_type, a);
        fetch_error("map()");
        return mapped;
    }

    void * map(int offset, uint length, buffer_access a) {
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
