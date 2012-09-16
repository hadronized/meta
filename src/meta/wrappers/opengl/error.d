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

module meta.wrappers.opengl.error;

/* imports */
private {
    import meta.wrappers.opengl.common;
}
public {
}

/* runtime error */
class CGLObjectError : CRuntimeError {
    this(string context, string reason) {
        super("\'" ~ context ~ "\' committed an error; reason: " ~ reason);
    }
}


/* GLErrorGetter mixin template */
mixin template MTGLError() {
    private GLenum _lastError;

    GLenum last_error() const @property {
        return _lastError;
    }

    /* get error and throw exception if there's an error */
    void fetch_error(lazy string context) {
        immutable auto fullContext = typeof(this).stringof ~ '.' ~ context;
        _lastError = glGetError();
        string trmsg; /* translated message */

        switch (_lastError) {
            case GL_NO_ERROR :
                return;

            case GL_INVALID_ENUM :
                trmsg = "invalid enum";
                break;

            case GL_INVALID_VALUE :
                trmsg = "invalid value";
                break;

            case GL_INVALID_OPERATION :
                trmsg = "invalid operation";
                break;

            case GL_OUT_OF_MEMORY :
                trmsg = "out of memory";
                break;

            default :
                throw new CGLObjectError(fullContext, "unknown error");
        }

        throw new CGLObjectError(fullContext, trmsg);
    }
}

/* error trap class; used to discard gl errors */
scope class CErrorTrap {
    mixin MTGLError;

    this() {
        do {
            try {
                fetch_error(null);
            } catch(Error e) {}
            CLogger.inst().deb("avoiding gl error %d", _lastError);
        } while (_lastError != GL_NO_ERROR);
    }
}

/* publicly used to discard gl errors and get a stable GL context */
void discard_gl_errors() {
    scope auto avoider = new CErrorTrap;
}


/* runtime error */
class CContextError : CRuntimeError {
    this(string reason) {
        super("context error; reason: " ~ reason);
    }
}
