module meta.views.core.opengl.gl;

/* imports */
private {
    import meta.views.core.opengl.common;
    import meta.utils.one_instance;
    import meta.utils.memory;
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

    @property T id() const {
        return _id;
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


/* runtime error */
class shader_compilation_error : runtime_error {
    this(shader_type st, string reason) {
        super(to!string(st) ~ " shader failed to compile; reason:\n" ~ reason);
    }
}
        
/* shader */
enum shader_type : GLenum {
    VERTEX   = GL_VERTEX_SHADER ,
    FRAGMENT = GL_FRAGMENT_SHADER,
    GEOMETRY = GL_GEOMETRY_SHADER
}

class shader {
    mixin GLObject!GLuint;

    public immutable shader_type type;

    this(shader_type st) {
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

        /* set the source */
        glShaderSource(_id, 1, &ptr, cast(const(int)*)0);
        fetch_error("compile():source");

        /* compile the shader */
        glCompileShader(_id);
        fetch_error("compile():compilation");

        /* check enventual error(s) */
        check_compilation_();
    }

    private void check_compilation_() {
        GLint status;
        glGetShaderiv(_id, GL_COMPILE_STATUS, &status);
        fetch_error("check_compilation()");

        if (status == GL_FALSE)
            throw new shader_compilation_error(type, compilation_log_());
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


/* runtime error */
class shader_program_error : runtime_error {
    this(string reason) {
        super("shader program error; reason: " ~ reason);
    }
}

/* shader program */
class shader_program {
    mixin GLObject!GLuint;

    this() {
        _id = glCreateProgram();
        fetch_error("this()");
    }

    ~this() {
        glDeleteProgram(_id);
    }

    void attach(shader s) {
        glAttachShader(_id, s.id);
    }

    void detach(shader s) {
        glDetachShader(_id, s.id);
    }

    void link() {
        glLinkProgram(_id);
        fetch_error("link()");
        check_link_();
        debug check_validation_();
    }

    private void check_link_() {
        GLint status;
        glGetProgramiv(_id, GL_LINK_STATUS, &status);
        fetch_error("check_link_()");
        
        if (status == GL_FALSE)
            throw new shader_program_error("shader program failed to link; reason:\n" ~ link_log_());
    }

    private string link_log_() {
        GLint l;

        char[] log;
        glGetProgramiv(_id, GL_INFO_LOG_LENGTH, &l);
        fetch_error("link_log_():length");
        if (l) {
            log = new char[l];
            glGetProgramInfoLog(_id, l, cast(int*)0, log.ptr);
            fetch_error("link_log_():info");
        }

        return log.idup;
    }

    private void check_validation_() {
        GLint valid;
        glValidateProgram(_id);
        fetch_error("check_validation_():validation");
        glGetProgramiv(_id, GL_VALIDATE_STATUS, &valid);
        fetch_error("check_validation_():status");
        
        if (valid == GL_FALSE)
            throw new shader_program_error("shader program isn't valid; reason:\n" ~ link_log_());
    }
}