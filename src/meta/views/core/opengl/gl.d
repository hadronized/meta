module meta.views.core.opengl.gl;

/* imports */
private {
    import meta.utils.logger;
    import meta.utils.one_instance;
    import meta.utils.runtime_error;
}
public {
    import derelict.opengl3.gl3;
    import derelict.glfw3.glfw3;
    import meta.utils.color;
}


/* runtime error */
class component_not_loaded : runtime_error {
    this(string component, string reason) {
        super("OpenGL core failed to load the component \'" ~ component ~ "\'; reason: " ~ reason);
    }
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


/* runtime error */
class context_error : runtime_error {
    this(string reason) {
        super("context error; reason: " ~ reason);
    }
}

/* gl context */
class context(int MajVer, int MinVer) {
    mixin OneInstance!context;

    this() {
        logger.inst().deb("Initializing glfw");

        glfwInit();
        glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, MajVer);
        glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, MinVer);
        glfwOpenWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
        glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

        logger.inst().deb("Successfully initialized glfw");
    }

    ~this() {
        glfwTerminate();
    }

    public void create(int w, int h, bool full, string title) {
        auto window = glfwOpenWindow(w, h, GLFW_WINDOWED, cast(const(char)*)title, null);
        if (!window) {
            glfwTerminate();
            throw new context_error("unable to open a window");
        }

        logger.inst().deb("Created a gl context with a window {(%dx%d), fullscreen=%s}", w, h, full ? "on" : "off");
        DerelictGL3.reload();
        logger.inst().deb("Reloaded GL3 module");
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
    
    void set_clear_color(ref const color c) {
        glClearColor(c.r, c.g, c.b, c.a);
    }
}
