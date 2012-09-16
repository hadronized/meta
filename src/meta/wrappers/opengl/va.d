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

module meta.wrappers.opengl.va;

/* imports */
public {
    import meta.wrappers.opengl.common;
}
private {
}

class CVA {
    mixin MTGLObject!uint;

    this() {
        glGenVertexArrays(1, &_id);
        fetch_error("this()");
    }

    ~this() {
        glDeleteVertexArrays(1, &_id);
    }

    void use() {
        glBindVertexArray(_id);
        fetch_error("use()");
    }

    void done() const {
        glBindVertexArray(0);
    }
}

