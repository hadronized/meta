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
