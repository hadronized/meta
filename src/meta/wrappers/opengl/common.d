module meta.views.core.opengl.common;

private {
	/* TODO: import meta.wrappers.common, wrappers_not_loaded runtime_error */
}
public {
	import derelict.opengl3.gl3;
    import meta.utils.logger;
    import meta.utils.runtime_error;
	import meta.wrappers.opengl.error;
	import meta.wrappers.opengl.object;
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


/* runtime error */
class component_not_loaded : runtime_error {
    this(string component, string reason) {
        super("OpenGL core failed to load the component \'" ~ component ~ "\'; reason: " ~ reason);
    }
}
