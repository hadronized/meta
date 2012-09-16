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

module meta.wrappers.opengl.viewport;

private {
    import meta.wrappers.opengl.common;
    import meta.math.vecs;
}
public {
}

alias SVec!(4, int) SViewportParameters; /* x, y, w, h */

class CViewport {
    mixin MTGLError;

    this() {
    }

    this(int x, int y, int w, int h) {
        glViewport(x, y, w, h);
        fetch_error("this()");
    }

    SViewportParameters parameters() @property {
        int[4] xywh;
        glGetIntegerv(GL_VIEWPORT, xywh.ptr);
        fetch_error("parameters()");
        return SViewportParameters(xywh);
    }    
}

