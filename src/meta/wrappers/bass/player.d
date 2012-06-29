module meta.wrappers.bass.player;

/* imports */
private {
    import meta.wrappers.bass.common;
    import meta.wrappers.bass.sample;
}


class player_error : runtime_error {
    this(string reason) {
        super("player error; reason: " ~ reason);
    }
}


class player {
    this() {
    }

    void play(sample s) {
        auto played = BASS_ChannelPlay(s.channel, true);
        if (!played)
            throw new player_error("unable to play a sample");
    }
}
