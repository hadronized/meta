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
