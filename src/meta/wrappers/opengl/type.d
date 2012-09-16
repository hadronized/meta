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

module meta.wrappers.opengl.type;

private {
    import std.string : toUpper;
    import meta.wrappers.opengl.common;
}
public {
}

enum EGLType : typeof(GL_FLOAT) {
    FLOAT = GL_FLOAT,
    INT = GL_INT,
    UINT = GL_UNSIGNED_INT,
    BYTE = GL_BYTE,
    DOUBLE = GL_DOUBLE
}

/* useful template that converts a primary type (int, float, uint, ...) to its OpenGL enum type equivalent (INT,
   FLOAT, UINT, ...) */
template TGLTypeOf(T_) if (__traits(isArithmetic, T_)) {
    mixin("alias EGLType." ~ toUpper(T_.stringof) ~ " TGLTypeOf;");
}
