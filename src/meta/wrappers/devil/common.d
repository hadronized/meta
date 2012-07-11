module meta.wrappers.devil.common;

private {
    import meta.wrappers.common;
}
public {
    import derelict.devil.il;
    import meta.utils.logger;
    import meta.utils.runtime_error;
}


enum WRAPPER_NAME = "devil";

/* static ctor */
static this() {
    logger.inst().deb("Initializing " ~ WRAPPER_NAME ~ " module");

    /* devil initialization */
    DerelictIL.load();
    if (!DerelictIL.isLoaded())
        throw new wrapper_not_loaded(WRAPPER_NAME, "unknown");

    ilInit();
    logger.inst().deb("Successfully initialized " ~ WRAPPER_NAME ~ " module");
}

static ~this() {
	ilShutDown();
}


