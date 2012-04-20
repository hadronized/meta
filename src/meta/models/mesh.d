module meta.models.mesh;

import meta.utils.math.vecs;

/**
 * @class mesh
 * @param VertDef a vertex definition policy
 * @brief Mesh class
 *
 *
 */
class mesh(VertDef) {
    alias uint vertex_id;
    alias VertDef vertex_t;

    private vertex_t[] _vertices;

    @property const ref vertex_t[] vertices() const {
        return _vertices;
    }

    vertex_id add_vertex(in vertex_t v) {
        ++_vertices.length;
        _vertices[$-1] = v;
        return _vertices.length-1;
    }
}


alias vec!(3, float) space_co;
alias vec!(3, float) normal;
alias vec!(2, float) uv_co;

/* default vertex attribs */
mixin template DefaultVertexAttr() {
    space_co sco;
}

struct vertex_def(alias Attr) {
    mixin Attr;
}

/* default vertex definition */
alias vertex_def!DefaultVertexAttr default_vertex;