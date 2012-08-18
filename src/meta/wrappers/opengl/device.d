module meta.wrappers.opengl.device;

/* imports */
private {
    import meta.wrappers.opengl.common;
}
public {
    import meta.utils.color;
    import meta.wrappers.opengl.viewport;
}

/* buffer bit */
enum EBufferBit {
    COLOR = GL_COLOR_BUFFER_BIT,
    DEPTH = GL_DEPTH_BUFFER_BIT
}

/* gl device */
class CDevice {
    mixin MTGLError;

    void clear(EBufferBit bb) {
        glClear(bb);
        fetch_error("clear()");
    }
    
    void set_clear_color(ref const SColor c) {
        glClearColor(c.r, c.g, c.b, c.a);
        fetch_error("set_clear_color()");
    }
}

