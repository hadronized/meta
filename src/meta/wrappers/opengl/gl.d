module meta.views.core.opengl.gl;

version(none) {
public {
    import derelict.opengl3.gl3;
    import meta.views.core.opengl.glfw;
    import meta.color;
}




/* gl device */
class device {
    mixin GLError;

    void clear(buffer_bit bb) {
        glClear(bb);
        fetch_error("clear()");
    }
    
    void set_clear_color(ref const color c) {
        glClearColor(c.r, c.g, c.b, c.a);
        fetch_error("set_clear_color()");
    }

    void set_viewport(ref const viewport v) {
        glViewport(v.x, v.y, v.w, v.h);
        fetch_error("set_viewport()");
    }
}


}


