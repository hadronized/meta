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

module skp.fields;

mixin template MTFields(F_...) {
    static if (F_.length && !(F_.length & 1)) {
        static assert ( is(typeof(F_[1]) : string), "the type must be string or string-castable" );

        mixin("F_[0] " ~ F_[1] ~ ";");
        mixin MTFields!(F_[2 .. F_.length]);

        alias F_ fields_list;
    }   
}
