module meta.wrappers.glfw.common;

private {
    import meta.wrappers.common;
}
public {
    import derelict.glfw3.glfw3;
    import skp.logger;
    import skp.runtime_error;
}

/* static ctor */
static this() {
    CLogger.inst().deb("Initializing glfw module");

    /* glfw initialization */
    try {
        DerelictGLFW3.load();
        if (!glfwInit())
            throw new Error("failed to init");
    } catch (Error e) {
        throw new CWrapperNotLoaded("glfw", e.msg);
    }
    if (!DerelictGLFW3.isLoaded())
        throw new CWrapperNotLoaded("glfw", "unknown");

    CLogger.inst().deb("Successfully initialized glfw module");
}

