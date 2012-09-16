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

module meta.models.mesh;

/* imports */
private {
    import meta.math.vecs;
    import skp.fields;
}
public {
}

class CMesh(V_) {
    alias ulong vertex_id;
    alias V_ vertex_t;

    protected vertex_t[] _vertices;

    @property const(vertex_t)[] vertices() const {
        return _vertices;
    }

    vertex_id add_vertex(vertex_t v) {
        ++_vertices.length;
        _vertices[$-1] = v;
        return _vertices.length-1;
    }
}

struct SVertex(VD_...) {
    alias VD_ definition_list;
    mixin MTFields!(VD_);
}

alias SVec3 SCoord;
alias SVec3 SNormal;
alias SVec2 SUVCoord;


unittest {
    alias SVertex!(SCoord, "sco") SVert;

    auto v = SVert();
    v.sco = SVec3(1, 2, 3);
}
