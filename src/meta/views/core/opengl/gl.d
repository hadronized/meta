module meta.views.core.opengl.gl;

public import derelict.opengl3.gl3;
public import derelict.glfw3.glfw3;
import meta.utils.logger;
import meta.utils.runtime_error;
public {
    import meta.utils.color;
}

class component_not_loaded : runtime_error {
    this(string component, string reason) {
        super("OpenGL core failed to load the component \'" ~ component ~ "\'; reason: " ~ reason);
    }
}

class globject_error : runtime_error {
    this(string context, string reason) {
        super("\'" ~ context ~ "\' committed an error; reason: " ~ reason);
    }
}

static this() {
    logger.inst().deb("Initializing gl module");

    /* glfw initialization */
    try {
        DerelictGLFW3.load();
    } catch (Error e) {
        throw new component_not_loaded("glfw", e.msg);
    }
    if (!DerelictGLFW3.isLoaded())
        throw new component_not_loaded("glfw", "unknown");
        
    /* gl initialization */
    try {
        DerelictGL3.load();
    } catch (Error e) {
        throw new component_not_loaded("gl", e.msg);
    }
    if (!DerelictGL3.isLoaded())
        throw new component_not_loaded("gl", "unknown");

    logger.inst().deb("Successfully initialized gl module");
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
private scope class error_trap {
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


/* GLObject mixin template */
mixin template GLObject(T) {
    mixin GLError;

    private T _id;

    T id() const @property {
        return _id;
    }

    /* parametered ctor; set the OpenGL ID once and for all */
    private this(T id) {
        _id = id;
    }
}


enum device_buffer_bit {
    DBB_COLOR = GL_COLOR_BUFFER_BIT,
    DBB_DEPTH = GL_DEPTH_BUFFER_BIT,        
}

/* gl device */
class device {
    mixin GLError;

    void clear(device_buffer_bit bb) {
        glClear(bb);
        fetch_error("clear()");
    }
    
    //void set_clear_color(
}
