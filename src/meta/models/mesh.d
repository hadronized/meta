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
