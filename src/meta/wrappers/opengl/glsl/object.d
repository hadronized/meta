module meta.wrappers.opengl.glsl.object;

/* imports */
public {
	import meta.wrappers.opengl.common;
}
private {
}


mixin template GLSLObject() {
    mixin GLObject!GLint;

    public immutable string name;

    @property {
        GLint active() const {
            return _id != init;
        }

        GLint init() const {
            return -1;
        }
    }
}


