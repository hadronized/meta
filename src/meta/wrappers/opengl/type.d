module meta.wrappers.opengl.type;

private {
    import std.string : toUpper;
    import meta.wrappers.opengl.common;
}
public {
}

enum EGLType : typeof(GL_FLOAT) {
    FLOAT = GL_FLOAT,
    INT = GL_INT,
    UINT = GL_UNSIGNED_INT,
    BYTE = GL_BYTE,
    DOUBLE = GL_DOUBLE
}

/* useful template that converts a primary type (int, float, uint, ...) to its OpenGL enum type equivalent (INT,
   FLOAT, UINT, ...) */
template TGLTypeOf(T_) if (__traits(isArithmetic, T_)) {
    mixin("alias gltype." ~ toUpper(Tr.stringof) ~ " TGLTypeOf;");
}
