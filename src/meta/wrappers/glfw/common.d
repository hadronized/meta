module meta.wrappers.glfw.common;

private {
	import meta.wrappers.common;
}
public {
	import derelict.glfw3.glfw3;
    import meta.utils.logger;
    import meta.utils.runtime_error;
}


/* static ctor */
static this() {
    logger.inst().deb("Initializing glfw module");

    /* glfw initialization */
    try {
        DerelictGLFW3.load();
        if (!glfwInit())
            throw new Error("failed to init");
    } catch (Error e) {
        throw new wrapper_not_loaded("glfw", e.msg);
    }
    if (!DerelictGLFW3.isLoaded())
        throw new wrapper_not_loaded("glfw", "unknown");

    logger.inst().deb("Successfully initialized glfw module");
}

