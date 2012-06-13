module meta.wrappers.opengl.glsl.uniform;

/* imports */
public {
	import meta.math.matrix;
	import meta.math.vecs;
	import meta.utils.traits;
	import meta.wrappers.opengl.type;
	import meta.wrappers.opengl.shader_program;
	import meta.wrappers.opengl.glsl.object;
}
private {
}


class uniform(T) {
    mixin GLSLObject;

    this(string name) {
      	this.name = name;
        _id = init;
    }

    void map(shader_program sp) {
        auto ptr = name.ptr;
        GLint l = glGetAttribLocation(sp.id, name.ptr);
        fetch_error("map()");
        _id = l;
    }

    /* static if to determine if T is simple int, float, or what */
    //static if (__trait(isArithmetic, T)) {
	static if (	is(T == float) || is(T == int) || is(T == uint) || is(T == double) ) {
        mixin("
            void push(" ~ T.stringof ~ " p) {
                glUniform1" ~ T.stringof[0] ~ "(_id, p);
            }
			fetch_error(\"push()\");
        ");
    } else {
		/* static if to determine if T is vec */
		static if (Compatible!(T, "array")) {
			alias vec_trait!T.dimension dimension;
			alias vec_trait!T.value_type value_type;

			mixin("
					void push(in " ~ T.stringof ~ " a) {
						glUniform" ~ dimension.stringof[0] ~ value_type.stringof[0] ~ "(_id, a.ptr);
						fetch_error(\"push()\");
					}
			");
		} else {
			/* static if to determine if T is matrix */
			static if (is(T : mat)) {
				void push(in mat m, bool transpose = false) {
					glUniformMatrix4fv(_id, 1, transpose, m.ptr);
				}
			} else {
				static assert (false, "unknown type for uniform");
			}
		}
	}
}
