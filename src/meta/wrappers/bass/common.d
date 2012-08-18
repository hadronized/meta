module meta.wrappers.bass.common;

/* imports */
private {
    import meta.wrappers.common;
}
public {
    import derelict.bass.bass;
    import skp.logger;
    import skp.runtime_error;
}


/* static ctor */
static this() {
    CLogger.inst().deb("Initializing BASS module");

    DerelictBASS.load();
    if (!BASS_Init(-1, 44100, BASS_DEVICE_SPEAKERS, cast(void*)0, cast(GUID*)0))
        throw new CWrapperNotLoaded("BASS", "failed to init");
    if (!DerelictBASS.isLoaded())
        throw new CWrapperNotLoaded("BASS", "unknown");

    CLogger.inst().deb("Successfully initialized BASS module");
}

static ~this() {
    BASS_Free();
    DerelictBASS.unload();
}
