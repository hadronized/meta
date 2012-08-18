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
