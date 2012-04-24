import std.stdio;
import meta.utils.math.vecs;
import meta.utils.logger;
import meta.utils.memory;
import meta.models.mesh;

class custom_vertex {
    space_co sco;
    normal no;
}

int main() {
    /* mesh with default vertex */
    auto m = spawn!(mesh!default_vertex);
    alias m.vertex_t vertex_t;

    space_co co, co2;

    co2 = co;

    return 0;
}