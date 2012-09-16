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

