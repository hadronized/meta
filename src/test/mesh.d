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
    /* use default vertex */
    {
        scope auto v = spawn!default_vertex;
        writeln(v);
    }

    /* use custom vertex vertex */
    {
        scope auto v = spawn!custom_vertex;
        writeln(v);
    }
    return 0;
}