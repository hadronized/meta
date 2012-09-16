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

module meta.wrappers.opengl.device;

/* imports */
private {
    import meta.wrappers.opengl.common;
}
public {
    import meta.utils.color;
    import meta.wrappers.opengl.viewport;
}

/* buffer bit */
enum EBufferBit {
    COLOR = GL_COLOR_BUFFER_BIT,
    DEPTH = GL_DEPTH_BUFFER_BIT
}

/* gl device */
class CDevice {
    mixin MTGLError;

    void clear(EBufferBit bb) {
        glClear(bb);
        fetch_error("clear()");
    }
    
    void set_clear_color(ref const SColor c) {
        glClearColor(c.r, c.g, c.b, c.a);
        fetch_error("set_clear_color()");
    }
}

