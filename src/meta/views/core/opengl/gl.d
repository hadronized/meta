module meta.views.core.opengl.gl;

/* imports */
private {
    import meta.views.core.opengl.common;
    import meta.utils.one_instance;
}
public {
    import derelict.opengl3.gl3;
    import meta.views.core.opengl.glfw;
    import meta.utils.color;
}


/* runtime error */
class globject_error : runtime_error {
    this(string context, string reason) {
        super("\'" ~ context ~ "\' committed an error; reason: " ~ reason);
    }
}


/* static ctor */
static this() {
    logger.inst().deb("Initializing gl module");
        
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


/* runtime error */
class context_error : runtime_error {
    this(string reason) {
        super("context error; reason: " ~ reason);
    }
}


enum buffer_bit {
    COLOR = GL_COLOR_BUFFER_BIT,
    DEPTH = GL_DEPTH_BUFFER_BIT,        
}


struct viewport {
    int x;
    int y;
    int w;
    int h;

    this (int x, int y, int w, int h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
}

/* gl device */
class device {
    mixin GLError;

    void clear(buffer_bit bb) {
        glClear(bb);
        fetch_error("clear()");
    }
    
    void set_clear_color(ref const color c) {
        glClearColor(c.r, c.g, c.b, c.a);
        fetch_error("set_clear_color()");
    }

    void set_viewport(ref const viewport v) {
        glViewport(v.x, v.y, v.w, v.h);
        fetch_error("set_viewport()");
    }
}
