import std.stdio;
import meta.utils.math.vecs;
import meta.utils.logger;
import meta.utils.memory;
import meta.models.mesh;

mixin template CustomVertexDef() {
    space_co sco;
    normal no;
}

alias vertex_def!CustomVertexDef custom_vertex;

int main() {
    /* mesh with default vertex */
    auto m = spawn!(mesh!default_vertex);
    return 0;
}