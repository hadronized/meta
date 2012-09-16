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

module meta.render.drivers.opengl.mesh_renderer;

/* imports */
private {
    import meta.models.mesh;
    import meta.render.adaptors.mesh_renderer;
    import meta.wrappers.opengl.buffer;
    import skp.fields;
    import skp.logger;
}
public {
}

private mixin template MTArrayFields(F_...) {
    static if (F_.length && !(F_.length & 1)) {
        mixin MTArrayFields!(F_[2 .. F_.length]);
        mixin Fields!(F_[0][], F_[1] ~ "v");
    }   
}

struct SMeshDeintarlacer(V_) {
    mixin MTArrayFields!(V_.fields_list);

    this(mesh!V_ m) in {
        assert ( m !is null );
    } body {
    }
}

class CMeshRendererGL : IMeshRenderer {
    private {
        CBuffer _vbo;
    }

    this(V_)(mesh!V_ m) in {
        assert ( m !is null );
    } body {
        auto deint = new CMeshDeinterlacer!V_;
        auto vert = m.vertices;

        _vbo = new CBuffer;
    }
}


