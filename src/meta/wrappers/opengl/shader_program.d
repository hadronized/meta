module meta.wrappers.opengl.shader_program;

private {
	import meta.wrappers.opengl.common;
}
public {
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

    void attach(S...)(shader s, S others) {
        logger.inst().deb("attaching %s shader (shader_id=%d, shader_program_id=%d)", to!string(s.type), s.id, _id);
        glAttachShader(_id, s.id);
        fetch_error("attach()");
        logger.inst().deb("successfully attached %s shader (shader_id=%d, shader_program_id=%d)", to!string(s.type), s.id, _id);
        
        static if (others.length)
            attach(others);
    }

    void detach(S...)(shader s, S others) {
        logger.inst().deb("detaching %s shader (shader_id=%d, shader_program_id=%d)", to!string(s.type), s.id, _id);
        glDetachShader(_id, s.id);
        fetch_error("detach()");
        logger.inst().deb("successfully detached %s shader (shader_id=%d, shader_program_id=%d)", to!string(s.type), s.id, _id);

        static if (others.length)
            detach(others);
    }

    void link() {
        logger.inst().deb("linking shader program (id=%d)", _id);
        glLinkProgram(_id);
        fetch_error("link()");
        check_link_();
        logger.inst().deb("successfully linked shader program (id=%d)", _id);
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


