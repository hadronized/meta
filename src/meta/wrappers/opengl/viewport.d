module meta.wrappers.opengl.viewport;

private {
    import meta.wrappers.opengl.common;
    import meta.math.vecs;
}
public {
}

alias SVec!(4, int) SViewportParameters; /* x, y, w, h */

class CViewport {
    mixin MTGLError;

    this() {
    }

    this(int x, int y, int w, int h) {
        glViewport(x, y, w, h);
        fetch_error("this()");
    }

    SViewportParameters parameters() @property {
        int[4] xywh;
        glGetIntegerv(GL_VIEWPORT, xywh.ptr);
        fetch_error("parameters()");
        return SViewportParameters(xywh);
    }    
}

