module meta.wrappers.opengl.error;

/* imports */
private {
    import meta.wrappers.opengl.common;
}
public {
}


/* runtime error */
class globject_error : runtime_error {
    this(string context, string reason) {
        super("\'" ~ context ~ "\' committed an error; reason: " ~ reason);
    }
}


/* GLErrorGetter mixin template */
mixin template GLError() {
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
                throw new globject_error(fullContext, "unknown error");
        }

        throw new globject_error(fullContext, trmsg);
    }
}


/* error trap class; used to discard gl errors */
scope class error_trap {
    mixin GLError;

    this() {
        do {
            try {
                fetch_error(null);
            } catch(Error e) {}
            logger.inst().deb("avoiding gl error %d", _lastError);
        } while (_lastError != GL_NO_ERROR);
    }
}


/* avoid_gl_errors(); publicly used to discard gl errors and get a stable GL context */
void discard_gl_errors() {
    scope auto avoider = new error_trap;
}


/* runtime error */
class context_error : runtime_error {
    this(string reason) {
        super("context error; reason: " ~ reason);
    }
}

