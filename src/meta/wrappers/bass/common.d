module meta.wrappers.bass.common;

/* imports */
private {
    import meta.wrappers.common;
}
public {
    import derelict.bass.bass;
    import meta.utils.logger;
    import meta.utils.runtime_error;
}


/* static ctor */
static this() {
    logger.inst().deb("Initializing BASS module");

    DerelictBASS.load();
    if (!BASS_Init(-1, 44100, BASS_DEVICE_SPEAKERS, cast(void*)0, cast(GUID*)0))
        throw new wrapper_not_loaded("BASS", "failed to init");
    if (!DerelictBASS.isLoaded())
        throw new wrapper_not_loaded("BASS", "unknown");

    logger.inst().deb("Successfully initialized BASS module");
}
