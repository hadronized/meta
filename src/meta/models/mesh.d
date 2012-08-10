module meta.models.mesh;

/* imports */
private {
    import meta.math.vecs;
    import meta.utils.fields;
}
public {
}


class mesh(V) {
    alias ulong vertex_id;
    alias V vertex_t;

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

struct vertex(VD...) {
    alias VD definition_list;
    mixin Fields!(VD);
}

alias vec3 space_co;
alias vec3 normal;
alias vec2 uv_co;


unittest {
    alias vertex!(vec3, "sco") vert;

    auto v = vert();
    v.sco = vec3(1, 2, 3);
}
