module meta.wrappers.opengl.common;

private {
    import std.stdio;
    import meta.wrappers.common;
}
public {
    import derelict.opengl3.gl3;
    import meta.wrappers.opengl.error;
    import meta.wrappers.opengl.object;
    import skp.logger;
    import skp.runtime_error;
}

/* static ctor */
static this() {
    CLogger.inst().deb("Initializing gl module");
        
    /* gl initialization */
    try {
        DerelictGL3.load();
    } catch (Error e) {
        throw new CWrapperNotLoaded("gl", e.msg);
    }
    if (!DerelictGL3.isLoaded())
        throw new CWrapperNotLoaded("gl", "unknown");

    CLogger.inst().deb("Successfully initialized gl module");
}

