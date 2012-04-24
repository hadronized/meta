module meta.models.mesh;

import meta.utils.math.vecs;

/**
 * @class mesh
 * @param V a vertex definition
 * @brief Mesh class
 *
 *
 */
class mesh(V) {
    alias ulong vertex_id;
    alias V vertex_t;

    private vertex_t[] _vertices;

    @property const(vertex_t)[] vertices() const {
        return _vertices;
    }

    vertex_id add_vertex(in vertex_t v) {
        ++_vertices.length;
        //_vertices[$-1] = v;
        return _vertices.length-1;
    }
}


alias vec!(3, float) space_co;
alias vec!(3, float) normal;
alias vec!(2, float) uv_co;

/* default vertex */
class default_vertex {
    space_co sco;
}

