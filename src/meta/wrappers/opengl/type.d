module meta.wrappers.opengl.type;

private {
    import std.string : toUpper;
    import meta.wrappers.opengl.common;
}
public {
}


/* gl type */
enum gltype : typeof(GL_FLOAT) {
    FLOAT = GL_FLOAT,
    INT = GL_INT,
    UINT = GL_UNSIGNED_INT,
    BYTE = GL_BYTE,
    DOUBLE = GL_DOUBLE
}

/* useful template that converts a primary type (int, float, uint, ...) to its OpenGL enum type equivalent (INT,
   FLOAT, UINT, ...) */
template GLTypeOf(T) if (__traits(isArithmetic, T)) {
    mixin("alias gltype." ~ toUpper(T.stringof) ~ " GLTypeOf;");
}

