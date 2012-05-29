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
enum buffer_bit {
	COLOR = GL_COLOR_BUFFER_BIT,
	DEPTH = GL_DEPTH_BUFFER_BIT
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
}

