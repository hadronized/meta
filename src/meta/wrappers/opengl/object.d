module meta.wrappers.opengl.object;

private {
	import meta.wrappers.opengl.common;
}
public {
}


/* GLObject mixin template */
mixin template GLObject(T) {
    mixin GLError;

    private T _id;

    property T id() const @property {
        return _id;
    }
}

