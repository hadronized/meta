module meta.views.core.opengl.common;

public {
    import meta.utils.logger;
    import meta.utils.runtime_error;
}


/* runtime error */
class component_not_loaded : runtime_error {
    this(string component, string reason) {
        super("OpenGL core failed to load the component \'" ~ component ~ "\'; reason: " ~ reason);
    }
}