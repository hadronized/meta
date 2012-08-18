module meta.wrappers.opengl.va;

/* imports */
public {
    import meta.wrappers.opengl.common;
}
private {
}

class CVA {
    mixin MTGLObject!uint;

    this() {
        glGenVertexArrays(1, &_id);
        fetch_error("this()");
    }

    ~this() {
        glDeleteVertexArrays(1, &_id);
    }

    void use() {
        glBindVertexArray(_id);
        fetch_error("use()");
    }

    void done() const {
        glBindVertexArray(0);
    }
}

