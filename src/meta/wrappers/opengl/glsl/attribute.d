module meta.wrappers.opengl.glsl.attribute;

/* imports */
public {
	import meta.math.vecs;
	import meta.utils.traits;
	import meta.wrappers.opengl.type;
	import meta.wrappers.opengl.shader_program;
	import meta.wrappers.opengl.glsl.object;
}
private {
}


/* attribute */
class attribute(T) {
    mixin GLSLObject;

    this(string name) {
      	this.name = name;
        _id = init;
    }

    void enable() {
        glEnableVertexAttribArray(_id);
        fetch_error("enable()");
    }

    void disable() {
        glDisableVertexAttribArray(_id);
        fetch_error("disable()");
    }

    void into(shader_program sp) {
        auto ptr = name.ptr;
        GLint l = glGetAttribLocation(sp.id, name.ptr);
        fetch_error("map()");
        _id = l;

		if (_id != init) 
			logger.inst().deb("attribute \'%s\' is active for shader program (id=%d)", name, sp.id);
    }

    /* static if to determine if T is simple int, float, or what */
	static if (	is(T == float) || is(T == int) || is(T == uint) || is(T == double) ) {
        mixin("
            void pointer(" ~ T.stringof ~ " *p, uint stride, bool normalized) {
                glVertexAttribPointer(_id, 1, " ~ GLTypeOf!T ~ ", normalized, stride, p);
				fetch_error(\"pointer()\");
            }
        ");
    }

    /* static if to determine if T is vec */
	static if (Compatible!(T, "array")) {
		alias vec_trait!(T).dimension dimension;
		alias vec_trait!T.value_type value_type;

		mixin("
			void pointer(" ~ value_type.stringof ~ " *p, uint stride, bool normalized) {
			    glVertexAttribPointer(_id, " ~ dimension.stringof[0] ~ ", " ~ GLTypeOf!(value_type).stringof ~ ", normalized, stride, p);
				fetch_error(\"pointer()\");
			}
		");
	}

	/* TODO: implement this case */
    /* static if to determine if T is matrix */
}
