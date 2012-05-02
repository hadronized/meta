import std.stdio;
import meta.utils.math.vecs;
import meta.utils.logger;
import meta.utils.memory;
import meta.models.mesh;

int main() {
    auto m = spawn!(mesh!default_vertex);

    /* add a vertex to the mesh */
    auto v = spawn!default_vertex;
    v.sco = space_co(3, 1, 4);

    m.add_vertex(v);
    return 0;
}