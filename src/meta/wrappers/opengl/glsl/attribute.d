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

module meta.wrappers.opengl.glsl.attribute;

/* imports */
public {
    import meta.math.vecs;
    import meta.wrappers.opengl.type;
    import meta.wrappers.opengl.shader_program;
    import meta.wrappers.opengl.glsl.object;
    import skp.traits;
}
private {
}

/* attribute */
class CAttribute(T_) {
    mixin MTGLSLObject;

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

    void into(CShaderProgram sp) {
        auto ptr = name.ptr;
        GLint l = glGetAttribLocation(sp.id, name.ptr);
        fetch_error("map()");
        _id = l;

        if (_id != init) 
            CLogger.inst().deb("attribute \'%s\' is active for shader program (id=%d)", name, sp.id);
    }

    /* static if to determine if T is simple int, float, or what */
    static if ( is(T_ == float) || is(T_ == int) || is(T_ == uint) || is(T_ == double) ) {
        mixin("
            void pointer(" ~ T_.stringof ~ " *p, uint stride, bool normalized) {
                glVertexAttribPointer(_id, 1, " ~ TGLTypeOf!T_ ~ ", normalized, stride, p);
                fetch_error(\"pointer()\");
            }
        ");
    }

    /* static if to determine if T is vec */
    static if (TLike!(T_, "array")) {
        alias TVecTrait!T_.dimension dimension;
        alias TVecTrait!T_.value_type value_type;

        mixin("
            void pointer(" ~ value_type.stringof ~ " *p, uint stride, bool normalized) {
                glVertexAttribPointer(_id, " ~ dimension.stringof[0] ~ ", " ~ TGLTypeOf!(value_type).stringof ~ ", normalized, stride, p);
                fetch_error(\"pointer()\");
            }
        ");
    }

    /* TODO: implement this case */
    /* static if to determine if T is matrix */
}
