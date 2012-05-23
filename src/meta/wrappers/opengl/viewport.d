module meta.wrappers.opengl.viewport;

private {
	import meta.wrappers.opengl.common;
	import meta.utils.math.vecs;
}
public {
}


alias vec4!int viewport_parameters; /* x, y, w, h */

class viewport {
    this(int x, int y, int w, int h) {
		glViewport(x, y, w, h);
		fetch_error("this()");
    }

	viewport_parameters parameters() @property {
		int[4] xywh;
		glGetIntegerv(GL_VIEWPORT, &xywh);
		fetch_error("parameters()");
		return viewport_parameters(xywh);
	}	
}

