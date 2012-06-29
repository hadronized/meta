module meta.wrappers.bass.sample;

/* imports */
private {
    import std.string : toStringz;
    import meta.wrappers.bass.common;
}
public {
}


/* exception when a sample can't be constructed */
class sample_loading_error : runtime_error {
    this(string reason) {
        super("unable to load sample; reason: " ~ reason);
    }
}

/* exception when there's some trouble with sample's channel */
class sample_channel_error : runtime_error {
    this(string reason) {
        super("sample channel error; reason: " ~ reason);
    }
}


class sample {
    private HSAMPLE _sHnd;

    this(string file) {
        _sHnd = BASS_SampleLoad(false, cast(void*)toStringz(file), 0, 0, 1, 0);
        if (!_sHnd)
            throw new sample_loading_error("unable to provide further information, please add a correct error code checker! ><> \\_o<");
    }

    HSAMPLE handle() const @property {
        return _sHnd;
    }

    HCHANNEL channel() const @property {
        auto chan = BASS_SampleGetChannel(_sHnd, false); 
        if (!chan)
            throw new sample_channel_error("unable to retreive the channel of a sample");
        return chan;
    }
}

