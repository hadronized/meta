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

module skp.traits;

public import std.traits;

template THas(T_, string Q_) if (Q_ == "slice") {
    static if (is(T_ == class) || is(T_ == struct))
        enum THas = __traits(hasMember, T_, "opSlice");
    else
        enum THas = isArray!T_;
}

template TLike(T_, string Q_) if (Q_ == "array") {
    enum TLike = THas!(T_, "slice");
}
