module meta.wrappers.opengl.object;

private {
    import meta.wrappers.opengl.common;
}
public {
}

mixin template MTGLObject(T_) {
    mixin MTGLError;

    private T_ _id;

    T_ id() const @property {
        return _id;
    }
}
