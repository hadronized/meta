module meta.wrappers.opengl.viewport;

private {
	import meta.wrappers.opengl.common;
	import meta.utils.math.vecs;
}
public {
}


alias vec!(4, int) viewport_parameters; /* x, y, w, h */

class viewport {
	mixin GLError;

    this(int x, int y, int w, int h) {
		glViewport(x, y, w, h);
		fetch_error("this()");
    }

	viewport_parameters parameters() @property {
		int[4] xywh;
		glGetIntegerv(GL_VIEWPORT, xywh.ptr);
		fetch_error("parameters()");
		return viewport_parameters(xywh);
	}	
}

