module meta.wrappers.devil.common;

private {
    import meta.wrappers.common;
}
public {
    import derelict.devil.il;
    import skp.logger;
    import skp.runtime_error;
}


enum WRAPPER_NAME = "devil";

/* static ctor */
static this() {
    CLogger.inst().deb("Initializing %s module", WRAPPER_NAME);

    /* devil initialization */
    DerelictIL.load();
    if (!DerelictIL.isLoaded())
        throw new CWrapperNotLoaded(WRAPPER_NAME, "unknown");

    ilInit();
    CLogger.inst().deb("Successfully initialized %s module", WRAPPER_NAME);
}

static ~this() {
    ilShutDown();
}
