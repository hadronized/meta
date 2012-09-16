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

module meta.wrappers.opengl.shader;

private {
    import std.conv : to;
    import meta.wrappers.opengl.common;
}
public {
}

/* runtime error */
class CShaderCompilationError : CRuntimeError {
    this(EShaderType st, string reason) {
        super(to!string(st) ~ " shader failed to compile; reason:\n" ~ reason);
    }
}

enum EShaderType : GLenum {
    VERTEX   = GL_VERTEX_SHADER ,
    FRAGMENT = GL_FRAGMENT_SHADER,
    GEOMETRY = GL_GEOMETRY_SHADER
}

class CShader {
    mixin MTGLObject!GLuint;

    public immutable EShaderType type;

    this(EShaderType st) {
        type = st;
        _id = glCreateShader(type);
        fetch_error("this()");
        assert(_id);
    }

    ~this() {
        glDeleteShader(_id);
    }

    void compile(string src) {
        auto ptr = src.ptr;

        CLogger.inst().deb("pushing %s shader sources (id=%d)", to!string(type), _id);
        /* set the source */
        glShaderSource(_id, 1, &ptr, cast(const(int)*)0);
        fetch_error("compile():source");
        CLogger.inst().deb("successfully pushed %s shader sources! (id=%d)", to!string(type), _id);

        /* compile the shader */
        CLogger.inst().deb("compiling %s shader (id=%d)", to!string(type), _id);
        glCompileShader(_id);
        fetch_error("compile():compilation");
        /* check enventual error(s) */
        check_compilation_();
        CLogger.inst().deb("successfully compiled %s shader! (id=%d)", to!string(type), _id);
    }

    private void check_compilation_() {
        GLint status;
        glGetShaderiv(_id, GL_COMPILE_STATUS, &status);
        fetch_error("check_compilation()");

        if (status == GL_FALSE)
            throw new CShaderCompilationError(type, compilation_log_());
    }

    private string compilation_log_() {
        GLint l;

        char[] log;
        glGetShaderiv(_id, GL_INFO_LOG_LENGTH, &l);
        fetch_error("compilation_log_():length");
        if (l) {
            log = new char[l];
            glGetShaderInfoLog(_id, l, cast(int*)0, log.ptr);
            fetch_error("compilation_log_():info");
        }

        return log.idup;
    }
}
