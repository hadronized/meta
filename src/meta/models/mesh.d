module meta.models.mesh;

import meta.math.vecs;


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


alias vec3 space_co;
alias vec3 normal;
alias vec2 uv_co;

/* default vertex */
class default_vertex {
    space_co sco;
}
