module meta.models.mesh;

import meta.utils.math.vecs;

/**
 * @class mesh
 * @brief Mesh class
 *
 *
 */
class mesh {
    
}


/* Default vertex attribs */
mixin template DefaultVertexAttr() {
    alias vec!(3, float) space_co;
    alias vec!(3, float) normal;
    alias vec!(2, float) uv_co;

    space_co sco;
}

struct vertex(Attr) {
    mixin Attrb;
}