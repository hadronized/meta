/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta, a render framework
    Copyright (C) 2012 Dimitri 'skp' Sabadie <dimitri.sabadie@gmail.com> 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

module meta.wrappers.bass.sample;

/* imports */
private {
    import std.string : toStringz;
    import meta.wrappers.bass.common;
}
public {
}


/* exception when a sample can't be constructed */
class CSampleLoadingError : CRuntimeError {
    this(string reason) {
        super("unable to load sample; reason: " ~ reason);
    }
}

class CSampleError : CRuntimeError {
    this(string reason) {
        super("sample channel error; reason: " ~ reason);
    }
}


class CSample {
    private HSAMPLE _sHnd;
    public immutable HCHANNEL chan;

    this(string file) {
        _sHnd = BASS_SampleLoad(false, cast(void*)toStringz(file), 0, 0, 1, 0);
        if (!_sHnd)
            throw new CSampleLoadingError("unable to provide further information, please add a correct error code checker! ><> \\_o<");
        chan = BASS_SampleGetChannel(_sHnd, false);
        if (!chan)
            throw new CSampleError("unable to retreive the channel of a sample");
    }

    HSAMPLE handle() const @property {
        return _sHnd;
    }

    void play() {
        auto played = BASS_ChannelPlay(chan, true);
        if (!played)
            throw new CSampleError("unable to play a sample");
    }

    double cursor() const @property {
        /* first, get the cursor position */
        auto bcurs = BASS_ChannelGetPosition(chan, BASS_POS_BYTE);
        if (bcurs == -1)
            throw new CSampleError("unable to get cursor position");

        /* then, translate it into seconds */
        auto s = BASS_ChannelBytes2Seconds(chan, bcurs);
        if (s < 0)
            throw new CSampleError("unable to translate cursor position (bytes -> seconds)");

        return s;
    }

    void cursor(double s) @property {
        /* first, translate the time (seconds) into bytes */
        auto b = BASS_ChannelSeconds2Bytes(chan, s);
        if (b == -1)
            throw new CSampleError("unable to translate cursor position (seconds -> bytes)");

        /* then, set the cursor position */
        auto set = BASS_ChannelSetPosition(chan, b, BASS_POS_BYTE);
        if (!set)
            throw new CSampleError("unable to set the cursor position");
    }
}
