module meta.wrappers.opengl.common;

private {
    import std.stdio;
    import meta.wrappers.common;
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
        throw new wrapper_not_loaded("gl", e.msg);
    }
    if (!DerelictGL3.isLoaded())
        throw new wrapper_not_loaded("gl", "unknown");

    logger.inst().deb("Successfully initialized gl module");
}

