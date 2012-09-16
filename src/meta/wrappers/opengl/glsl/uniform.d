/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta, a render framework
    Copyright (C) 2012 Dimitri 'skp' Sabadie <dimitri.sabadie@gmail.com> 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

module meta.wrappers.opengl.glsl.uniform;

/* imports */
public {
    import meta.math.matrix;
    import meta.math.vecs;
    import meta.wrappers.opengl.type;
    import meta.wrappers.opengl.shader_program;
    import meta.wrappers.opengl.glsl.object;
    import skp.traits;
}
private {
}

class CUniform(T_) {
    mixin MTGLSLObject;

    this(string name) {
        this.name = name;
        _id = init;
    }

    void into(CShaderProgram sp) {
        auto ptr = name.ptr;
        GLint l = glGetUniformLocation(sp.id, name.ptr);
        fetch_error("map()");
        _id = l;

        if (_id != init) 
            CLogger.inst().deb("uniform \'%s\' is active for shader program (id=%d)", name, sp.id);
    }

    /* static if to determine if T_ is simple int, float, or what */
    //static if (__trait(isArithmetic, T)) {
    static if ( is(T_ == float) || is(T_ == int) || is(T_ == uint) || is(T_ == double) ) {
        mixin("
            void push(" ~ T_.stringof ~ " p) {
                glUniform1" ~ T_.stringof[0] ~ "(_id, p);
                fetch_error(\"push(arith)\");
            }
        ");
    } else {
        /* static if to determine if T_ is vec */
        static if (TLike!(T_, "array")) {
            alias TVecTrait!T_.dimension dimension;
            alias TVecTrait!T_.value_type value_type;

            mixin("
                void push(in " ~ T_.stringof ~ " a) {
                    glUniform" ~ dimension.stringof[0] ~ value_type.stringof[0] ~ "(_id, a.ptr);
                    fetch_error(\"push(array)\");
                }
            ");
        } else {
            /* static if to determine if T_ is matrix */
            static if (is(T_ : SMat44)) {
                void push(in SMat44 m, bool transpose = false) {
                    glUniformMatrix4fv(_id, 1, transpose, m.ptr);
                    fetch_error("push(mat)");
                }
            } else {
                static assert (false, "unknown type for uniform");
            }
        }
    }
}
